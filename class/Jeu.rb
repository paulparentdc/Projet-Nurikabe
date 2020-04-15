#require "gtk3"
#load 'Sauvegarde.rb'
load 'Plateau.rb'
load 'Highscore.rb'

# Coeur et gestion du jeu
# @attr_reader plateau [Plateau] le plateau de jeu
# @attr_reader nom_joueur [String]
# @attr nom_joueur_label [Gtk::Label]
# @attr_reader temps_de_jeu
# @attr window [Gtk::Window] composant Gtk de la fenêtre
# @attr_reader en_jeu [Boolean] prédicat de la continuité du Jeu
class Jeu
    attr_reader :plateau, :nom_joueur,:temps_de_jeu,:en_jeu
    @plateau
    @nom_joueur
    @nom_joueur_label
    @temps_de_jeu
    @window
    @en_jeu

	# Constructeur du jeu
	# @param [Plateau] le plateau dans lequel se déroule le jeu
	# @param [String] le nom du joueur
	# @param [Fixnum] le temps de jeu
    def initialize(plateau:, nom_joueur:, temps_de_jeu:)
        @plateau, @nom_joueur, @temps_de_jeu = plateau, nom_joueur, temps_de_jeu
        @en_jeu = true
    end

	# Affichage de notre jeu
	# @return [void]
    def affiche_toi
        builder = Gtk::Builder.new

        builder.add_from_file("../Glade/EnJeu.glade")
		    @window = builder.get_object("fn_select")
        @window.signal_connect('destroy') { |_widget| exit!() }

        # Récupérations des objets
            # Boutons
        btn_options = builder.get_object("Options")
        btn_undo = builder.get_object("Undo")
        btn_point_de_retour = builder.get_object("Point de retour")
        btn_revenir_point_de_retour = builder.get_object("Revenir point de retour")
        btn_aide = builder.get_object("Aide")
        btn_verification = builder.get_object("Verification")
        btn_indice = builder.get_object("Indice")

            # Autres
        @nom_joueur_label = builder.get_object("nom_joueur")
        grid = builder.get_object("grilleJeu")

        # Configurations des objets récupéré
            # Boutons
        btn_options.signal_connect('clicked'){afficherOption()}
        btn_undo.signal_connect('clicked'){@plateau.on_click_undo}
        btn_point_de_retour.signal_connect('clicked'){@plateau.on_click_creer_retour}
        btn_revenir_point_de_retour.signal_connect('clicked'){@plateau.on_click_aller_retour}
        btn_aide.signal_connect('clicked'){@plateau.on_click_regle(self)}
        btn_verification.signal_connect('clicked'){self.afficher_erreur}
        btn_indice.signal_connect('clicked'){@plateau.on_click_aide(self)}


            # initialisation du plateau dans la grille
        grid.set_property "row-homogeneous", true
        grid.set_property "column-homogeneous", true
        (0..@plateau.taille-1).each do |i|
            (0..@plateau.taille-1).each do |j|
                temp = @plateau.damier[i][j].bouton
                grid.attach temp, j, i, 1, 1
            end
        end


        # configuration de la fenêtre
        @window.set_title "Nurikabe!"
        @window.signal_connect "destroy" do
            #Sauvegarde.creer_sauvegarde(self)
            @en_jeu = false
            @window.destroy()
            exit!()
        end

        @window.set_window_position :center
        @window.show_all

        # lancement du timer
        timer_thread = Thread.new{self.lancer_timer}
        Gtk.main

    end

	# Affichages des différentes options possible
	# @return [void]
    def afficherOption
        builder_opt = Gtk::Builder.new
        builder_opt.add_from_file("../Glade/Options.glade")
        windowOpt = builder_opt.get_object("fen_opt")
        windowOpt.signal_connect('destroy') { |_widget| windowOpt.hide() }
        btn_sav = builder_opt.get_object("btn_sav")
        btn_sav.signal_connect('clicked') {Sauvegarde.creer_sauvegarde(self) }
        btn_quit = builder_opt.get_object("btn_quit")
        btn_quit.signal_connect('clicked') {|_widget| tout_fermer(windowOpt)}
        windowOpt.show_all()
    end

	# Fermeture des fernêtre
	# @return [void]
    def tout_fermer(windowOpt)
        @en_jeu = false
        @window.destroy()
        windowOpt.destroy()
        exit!()
    end

	# Lancement d'une boucle qui enregistre le temps tant que le jeu n'est pas finit
	# @return [void]
    def lancer_timer
        t1 = Time.now - @temps_de_jeu
        while(@en_jeu)
            t2 = Time.now
            @temps_de_jeu = (t2 - t1).round
            @nom_joueur_label.set_label("Joueur : " + @nom_joueur + " | temps : " + @temps_de_jeu.to_s + " s (+ " + @plateau.malus_aide.to_s + " s malus) | " + @plateau.niveau)
            sleep(1)
        end
    end

	# Affichage du résultat de la vérification du plateau
	# @return [void]
    def afficher_erreur
      # return if @plateau.partie_finie
        tab_erreur = @plateau.verifier_damier
        @en_jeu = false if @plateau.partie_finie
        pop = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"),
        Gtk::DialogFlags::DESTROY_WITH_PARENT,
        (tab_erreur.empty?  && !@plateau.partie_finie ? Gtk::MessageType::INFO : Gtk::MessageType::QUESTION),
        (tab_erreur.empty? && !@plateau.partie_finie ? :OK : :yes_no),
        (@plateau.partie_finie ? "Bravo " + @nom_joueur +" ! Vous avez fini le jeu en " + (@temps_de_jeu+@plateau.malus_aide).to_s + " seconde.\nVoulez-vous rejouer ?" :
        (tab_erreur.empty? ? "Vous avez  #{tab_erreur.size} erreurs! " : "Vous avez  #{tab_erreur.size} erreurs!\nVoulez-vous les visionner ?")))

        reponse = pop.run
        pop.destroy
        if(@plateau.partie_finie)
          classement = @plateau.niveau.chomp.downcase
          getHighscore = Highscore.recuperer_ds_fichier
          if(classement == "facile")
              getHighscore.inserer_score_facile(@nom_joueur,@temps_de_jeu+@plateau.malus_aide)
          elsif(classement == "moyen")
              getHighscore.inserer_score_moyen(@nom_joueur,@temps_de_jeu+@plateau.malus_aide)
          else
              getHighscore.inserer_score_difficile(@nom_joueur,@temps_de_jeu+@plateau.malus_aide)
          end
          Sauvegarde.sauvegarde_highscore(getHighscore)
          if(reponse == Gtk::ResponseType::YES)
              @window.hide
              menu = Menu.getInstance()
              menu.afficheChoixMode(@nom_joueur)

          end
        elsif(reponse == Gtk::ResponseType::YES)  # affichage en rouge des erreurs
            @plateau.malus_aide += tab_erreur.size*5
            tab_erreur.each do |err|
               err.en_rouge
           end
        end
    end
end
