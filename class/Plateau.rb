require "gtk3"
load 'Etat.rb'
load 'Aide.rb'
load 'PileAction.rb'

class Plateau
    attr_reader :niveau, :damier_correct, :pile_action, :aide, :taille, :partie_finie, :chemin_template
    attr_accessor :malus_aide, :pile_action, :damier
    @niveau
    @damier
    @damier_correct
    @taille
    @pile_action
    @aide
    @malus_aide
    @partie_finie
    @chemin_template

    def initialize(matrice_plateau, matrice_solution, taille, niveau, chemin_template)
        @damier = matrice_plateau
        @damier_correct = matrice_solution
        @taille = taille
        @niveau = niveau
        @chemin_template = chemin_template

        @pile_action = PileAction.new(self, [])
        @malus_aide =0
        @partie_finie = false
        @aide = Aide.new(self)
        
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

    def get_plateau_caracteres
        tab_char = []
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                tab_char.push(@damier[x][y].to_s)
            end
        end
        return tab_char
    end

    def get_plateau_etat
        tab_etat = []
        (0..(@taille-1)).each do |x|
            tab_ligne = []
            (0..(@taille-1)).each do |y|
                temp = @damier[x][y]
                if temp.is_a? CaseClic
                    tab_etat.push(temp.etat)
                else
                    tab_etat.push(nil)
                end
            end
            tab_etat.push(tab_ligne)
        end
        return tab_etat
    end


    def coord_valides?(x,y)
        if x < @taille && x>= 0 && y < @taille && y>= 0
            return true
        end
        
        return false       
    end

    def donne_case(x,y)
        if coord_valides?(x,y)
            return @damier[x][y]
        end
        
    #raise d une erreur ici car coordonnées invalides;
        
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
        @pile_action.empiler(Action.new(x,y))
        @damier[x][y].suivant
    end

    def on_click_aide(jeu)
        txt =''
        if(self.verifier_damier.empty?)
            nb_aide = @aide.tester_tout()
            p nb_aide
            case nb_aide

                when 1
                    txt ='Il reste des 1 à isoler !'

                when 2
                    txt ='Il y a une case blanche entre 2 chiffres qui pourrait être cliquer!'

                when 3
                    txt = 'Il y a des cases en diagonales qui peuvent être separées'

                when 4
                    txt = "Il y a une case blanche seule"

                when 5
                    txt = "Il y a une case noire qui ne sera pas reliée aux autres"
                    
                else
                    txt = "Aucune aide n'a été trouvé bonne chance !"
                    
            end


            dialog = Gtk::MessageDialog.new(Gtk::Window.new("fenetre"), 
            Gtk::Dialog::DESTROY_WITH_PARENT,
            Gtk::MessageDialog::INFO,
            Gtk::MessageDialog::BUTTONS_OK,
            txt)
            
            dialog.run
            dialog.destroy

        else
            jeu.afficher_erreur
        end
    end

    def on_click_undo
        @pile_action.annuler_dernier_coup
    end

    def on_click_regle
    end

    def on_click_creer_retour
        @pile_action.ajout_point_de_retour
    end

    def on_click_aller_retour
        @pile_action.vers_dernier_point_de_retour
    end

    def on_click_option
    end

    def on_click_quitter
    end
end
