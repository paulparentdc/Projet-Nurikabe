require "gtk3"
load 'Etat.rb'
load 'Aide.rb'
load 'PileAction.rb'

class Plateau
    attr_reader :niveau, :damier, :damier_correct, :pile_action, :aide, :taille,  :partie_finie
    attr_accessor :malus_aide
    @niveau
    @damier
    @damier_correct
    @taille
    @pile_action
    @aide
    @malus_aide
    @partie_finie

    def initialize(matrice_plateau, matrice_solution, taille, niveau)
        @damier = matrice_plateau
        @damier_correct = matrice_solution
        @taille = taille
        @niveau = niveau

        @pile_action = PileAction.new()
        @malus_aide = 0
        @partie_finie = false
        
    end

    def to_s
        (0..(@taille-1)).each do |y|
            (0..(@taille-1)).each do |x|
                print " #{
                    temp = @damier_correct[y][x]
                    if temp.to_i == 0
                        temp == 'n' ? 'X' : ' '
                    else
                        temp
                    end
                } |"
            end
            puts ""
        end
    end

    def verifier_damier
        tab_erreur = []
        @partie_finie = true
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                # check erreur
                if (@damier[x][y].to_s == 'n') && @damier_correct[x][y] != 'n'
                        tab_erreur.push(@damier[x][y])
                end
                # check fin de partie
                if(@damier[x][y].to_s.chr != @damier_correct[x][y])
                    @partie_finie = false
                end
            end
        end
        @malus_aide += 10 if(tab_erreur.size != 0)
        return tab_erreur
    end

    #suppr
    def afficher_erreur
        tab_erreur = self.verifier_damier
        pop = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"),
        Gtk::DialogFlags::DESTROY_WITH_PARENT,
        Gtk::MessageType::QUESTION,
        :yes_no, "Vous avez  #{tab_erreur.size} erreurs!\nVoulez-vous les visionner ?")
        
        
        reponse = pop.run 
        pop.destroy

        @malus_aide += 10 if(tab_erreur.size != 0)
        
        # affichage en rouge des erreurs
        if(reponse == Gtk::ResponseType::YES)
            @malus_aide += tab_erreur.size*5
            tab_erreur.each do |err|
                err.en_rouge
            end
        end
    end

    def coord_valides?(x,y)
        if x < @taille && x>= 0 && y < @taille && y>= 0
            return true
        end
        
        return false       
    end

    def donne_ta_case_int(x,y)
        if coord_valides(x,y)
            return @damier[x][y].get_etat_entier()   
        end
        
    #raise d une erreur ici car coordonnées invalides;
        
    end

    def affiche_toi(nom_du_joueur)
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
        nom_joueur_label = builder.get_object("nom_joueur")
        grid = builder.get_object("grilleJeu")

        # Configurations des objets récupéré
            # Boutons
        btn_options.signal_connect('clicked'){self.on_click_option}
        btn_undo.signal_connect('clicked'){self.on_click_undo}
        btn_point_de_retour.signal_connect('clicked'){self.on_click_creer_retour}
        btn_revenir_point_de_retour.signal_connect('clicked'){self.on_click_aller_retour}
        btn_aide.signal_connect('clicked'){self.on_click_aide}
        btn_verification.signal_connect('clicked'){self.on_click_verif}
        btn_indice.signal_connect('clicked'){self.on_click_aide}
            

            # initialisation du plateau dans la grille
        grid.set_property "row-homogeneous", true
        grid.set_property "column-homogeneous", true
        (0..@taille-1).each do |i|
            (0..@taille-1).each do |j|
                temp = @damier[i][j].bouton
                grid.attach temp, i, j, 1, 1
            end
        end

            # label
        nom_joueur_label.set_label("Joueur : " + nom_du_joueur + " ")


        # configuration de la fenêtre
        window.set_title "Nurikabe!"
        window.signal_connect "destroy" do 
            Gtk.main_quit 
        end        

        window.set_default_size 300, 250
        window.set_window_position :center
        
        window.show_all
        Gtk.main
    end

    def gagner?
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                if @damier[x][y].to_s != @damier_correct[x][y]
                        return false
                end
            end
        end
        return true
    end

    def on_click_verif
        self.afficher_erreur
    end
    
    def on_click_jeu(x,y)
        # @pile_action.empiler(Action.new(x,y,false))
        @damier[x][y].suivant
    end

    def on_click_aide
        txt =''
        if(self.verifier_damier.empty?)
            nb_aide = @aide.tester_tout(self)

            case(nb_aide)

            when nb_aide == 1
                txt ='Il reste des 1 à isoler !'

            when nb_aide == 2
                txt ='Il y a une case blanche entre 2 chiffres qui pourrait être cliquer!'

            when nb_aide == 3
                txt = 'Il y a des cases en diagonales qui peuvent être separées'

            when nb_aide == 4
                txt = "Il y a une case blanche seule"
            
            else 
                txt = "Aucune aide n'a été trouvé bonne chance !"
            


            dialog = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"), 
            Gtk::Dialog::DESTROY_WITH_PARENT,
            Gtk::MessageDialog::INFO,
            Gtk::MessageDialog::BUTTONS_OK,
            txt)

            
            
            dialog.run
            dialog.destroy

        end
    
        else
            self.afficher_erreur
        end
    end

    def on_click_undo
    end

    def on_click_regle
    end

    def on_click_creer_retour
    end

    def on_click_aller_retour
    end

    def on_click_option
    end

    def on_click_quitter
    end
end
