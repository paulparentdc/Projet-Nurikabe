require "gtk3"
load 'Etat.rb'

class Plateau
    @niveau
    @damier
    @damier_correct
    @taille
    @pileAction
    @aide

    def initialize(matrice_plateau, matrice_solution, taille, niveau)
        @damier = matrice_plateau
        @damier_correct = matrice_solution
        @taille = taille
        @niveau = niveau
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
        tabErreur = []
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                if (@damier[x][y].to_i == 0) && (@damier[x][y].to_s == 'n') && @damier_correct[x][y] != 'n'
                        tabErreur.push(@damier[x][y])
                end
            end
        end
        return tabErreur
    end

    def afficherErreur
        tabErreur = self.verifier_damier
        pop = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"),
        Gtk::Dialog::DESTROY_WITH_PARENT,
        Gtk::MessageType::QUESTION,
        Gtk::MessageDialog::BUTTONS_YES_NO, "Vous avez  #{tabErreur.size} erreurs!\nVoulez-vous les visionner ?")
        pop.run
        pop.destroy
    end

    def coord_valides?(x,y)
        if x < @taille && x>= 0 && y < @taille && y>= 0
            return true
        end
        
        return false       
    end

    def donne_ta_case_int(x,y)
        if coord_valides(x,y)
            return @damier[x][y].getEtatEntier()   
        end
        
    #raise d une erreur ici car coordonnées invalides;
        
    end

    def affiche_toi
        builder = Gtk::Builder.new

        builder.add_from_file("../graphic/Ruby/EnJeu.glade")
		window = builder.get_object("fn_select")
        window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		
        nom_joueur_label = builder.get_object("nom_joueur")
        grid = builder.get_object("grilleJeu")

        grid.set_property "row-homogeneous", true
        grid.set_property "column-homogeneous", true

        (0..@taille-1).each do |i|
            (0..@taille-1).each do |j|
                temp = @damier[i][j].bouton
                grid.attach temp, i, j, 1, 1
            end
        end

        # plateauBox.pack_start grid, :expand => true, :fill => true, :padding => 0

        # grilleBox.attach grid, 0, 1, 1, 1
        #window.add grid

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
        self.afficherErreur
    end

    def on_click_jeu(x,y)
        @damier[x][y].suivant
    end

    def on_click_aide
        txt =''
        if(self.verifier_damier.empty?)
            nbAide = @aide.testerTout(self)

            case(nbAide)

            when nbAide == 1
                txt ='Il reste des 1 à isoler !'

            when nbAide == 2
                txt ='Il y a une case blanche entre 2 chiffres qui pourrait être cliquer!'

            when nbAide == 3
                txt = 'Il y a des cases en diagonales qui peuvent être separées'

            when nbAide == 4
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
            self.afficherErreur
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
