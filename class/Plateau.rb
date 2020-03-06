require "gtk3"
load 'Etat.rb'

class Plateau
    @niveau
    @damier
    @damierCorrect
    @taille
    @pileAction
    @aide

    def initialize(matrice_plateau, matrice_solution, taille, niveau)
        @damier = matrice_plateau
        @damierCorrect = matrice_solution
        @taille = taille
        @niveau = niveau
    end

    def to_s
        (0..(@taille-1)).each do |y|
            (0..(@taille-1)).each do |x|
                print " #{
                    temp = @damierCorrect[y][x]
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

    def verifierDamier
        tabErreur = []
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                if (@damier[x][y].to_i == 0) && (@damier[x][y].to_s == 'n') && @damierCorrect[x][y] != 'n'
                        tabErreur.push(@damier[x][y])
                end
            end
        end
        return tabErreur
    end

    def afficherErreur
        tabErreur = self.verifierDamier
        pop = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"),
        Gtk::Dialog::DESTROY_WITH_PARENT,
        Gtk::MessageType::QUESTION,
        Gtk::MessageDialog::BUTTONS_YES_NO, "Vous avez  #{tabErreur.size} erreurs!\nVoulez-vous les visionner ?")
        pop.run
        pop.destroy
    end

    def coordValides?(x,y)
        if x < @taille && x>= 0 && y < @taille && y>= 0
            return true
        end
        
        return false       
    end

    def donneTaCaseInt(x,y)
        if coordValides(x,y)
            return @damier[x][y].getEtatEntier()   
        end
        
    #raise d une erreur ici car coordonnées invalides;
        
    end

    def afficheToi
        window = Gtk::Window.new
        
        vbox = Gtk::Box.new :vertical, 2
               

        grid = Gtk::Grid.new
        grid.set_property "row-homogeneous", true
        grid.set_property "column-homogeneous", true

        (0..@taille-1).each do |i|
            (0..@taille-1).each do |j|
                temp = @damier[i][j].bouton
                grid.attach temp, i, j, 1, 1
            end
        end

        vbox.pack_start grid, :expand => true, :fill => true, 
            :padding => 0


        window.add vbox

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
                if @damier[x][y].to_s != @damierCorrect[x][y]
                        return false
                end
            end
        end
        return true
    end

    def onClickVerif
        self.afficherErreur
    end

    def onClickVerif
    end

    def onClickJeu(x,y)
        @damier[x][y].suivant
    end

    def onClickAide
        txt =''
        if(self.verifierDamier.empty?)
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

    def onClickUndo
    end

    def onClickRegle
    end

    def onClickCreerRetour
    end

    def onClickAllerRetour
    end

    def onClickOption
    end

    def onClickQuitter
    end
end
