require "gtk3"
load 'Sauvegarde.rb'
load 'Plateau.rb'

class Jeu
    attr_reader :plateau, :timer, :nom_joueur
    @plateau
    @timer
    @nom_joueur
    @nom_joueur_label
    @temps_de_jeu

    @en_jeu

    def initialize(plateau, timer, nom_joueur)
        @plateau, @timer, @nom_joueur = plateau, timer, nom_joueur

        @en_jeu = true
        @malus_timer = 0

        @nom_joueur = "paul"
    end


    def affiche_toi
        builder = Gtk::Builder.new

        builder.add_from_file("../graphic/Ruby/EnJeu.glade")
		window = builder.get_object("fn_select")
        window.signal_connect('destroy') { |_widget| Gtk.main_quit }
        
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
        btn_options.signal_connect('clicked'){@plateau.on_click_option}
        btn_undo.signal_connect('clicked'){@plateau.on_click_undo}
        btn_point_de_retour.signal_connect('clicked'){@plateau.on_click_creer_retour}
        btn_revenir_point_de_retour.signal_connect('clicked'){@plateau.on_click_aller_retour}
        btn_aide.signal_connect('clicked'){@plateau.on_click_aide}
        btn_verification.signal_connect('clicked'){self.afficher_erreur}
        btn_indice.signal_connect('clicked'){@plateau.on_click_aide}
            

            # initialisation du plateau dans la grille
        grid.set_property "row-homogeneous", true
        grid.set_property "column-homogeneous", true
        (0..@plateau.taille-1).each do |i|
            (0..@plateau.taille-1).each do |j|
                temp = @plateau.damier[i][j].bouton
                grid.attach temp, i, j, 1, 1
            end
        end


        # configuration de la fenêtre
        window.set_title "Nurikabe!"
        window.signal_connect "destroy" do 
            Gtk.main_quit 
        end        

        window.set_default_size 300, 250
        window.set_window_position :center
        window.show_all
        
        # lancement du timer
        timer_thread = Thread.new{self.lancer_timer}
        Gtk.main
        
    end

    def lancer_timer
        t1 = Time.now
        while(@en_jeu)
            t2 = Time.now
            @temps_de_jeu = (t2 - t1).round
            @nom_joueur_label.set_label("Joueur : " + @nom_joueur + " | temps : " + @temps_de_jeu.to_s + " s (+ " + @plateau.malus_aide.to_s + " s malus) ")
            sleep(1)
        end
    end

    def afficher_erreur
        return if @plateau.partie_finie
        tab_erreur = @plateau.verifier_damier
        @en_jeu = false if @plateau.partie_finie
        pop = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"),
        Gtk::DialogFlags::DESTROY_WITH_PARENT,
        Gtk::MessageType::QUESTION,
        :yes_no, (!@plateau.partie_finie ?
            "Vous avez  #{tab_erreur.size} erreurs!\nVoulez-vous les visionner ?" : 
            "Bravo " + @nom_joueur +" ! Vous avez finis le jeu en " + (@temps_de_jeu+@plateau.malus_aide).to_s + " seconde.\nVoulez-vous rejouer ?"))
        
        
        reponse = pop.run 
        pop.destroy
        
        # affichage en rouge des erreurs
        if(reponse == Gtk::ResponseType::YES)
            @plateau.malus_aide += tab_erreur.size*5
            tab_erreur.each do |err|
                err.en_rouge
            end
        end
    end
end

jeu = Sauvegarde.charger_template("../data/template/plateau.txt")
puts jeu.affiche_toi
# plateau.afficheToi
# puts plateau