require "gtk3"
load 'Etat.rb'
load 'Aide.rb'
load 'PileAction.rb'

# Le plateau de jeu
# @attr_reader [String] niveau le niveau de difficulté
# @attr_reader [Array<String>] damier_correct le damier réponse au jeu en cours
# @attr_reader [Aide] aide une aide sur le plateau
# @attr_reader [Fixnum] taille la taille du plateau
# @attr_reader [Boolean] partie_finie indique si la partie finis
# @attr_reader [String] chemin_template le chemin du template utilisé pour le plateau
# @attr [Fixnum] malus_aide le nombre de point de malus
# @attr [Array<Array<Case>>] damier la matrice du plateau
# @attr [PileAction] pile_action une pile des actions réalisées par le joueur
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

    # @!visibility private
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

	# Vérifie le damier, indique si la partie est finis ou non, actualise le montant du malus en fonction du nombre d'erreurs
	# @return [void]
    def verifier_damier
        tab_erreur = []
        @partie_finie = true
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                # check erreur
                if (@damier[x][y].to_s == 'n') && @damier_correct[x][y] != 'n' || ((@damier[x][y].to_s == 'b+') && (@damier_correct[x][y] != 'b'))
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

	# Permet d'obtenir un tableau de caractère
	# @note utile seulement pour l'affichage terminal
	# @return [Array<String>]
    def get_plateau_caracteres
        tab_char = []
        (0..(@taille-1)).each do |x|
            (0..(@taille-1)).each do |y|
                tab_char.push(@damier[x][y].to_s)
            end
        end
        return tab_char
    end

	#Récupère l'état du plateau, utile pour la sauvegarde
	# @return [void]
    def get_plateau_etat
        tab_etat = []
        (0..(@taille-1)).each do |x|
            tab_ligne = []
            (0..(@taille-1)).each do |y|
                temp = @damier[x][y]
                if temp.is_a? CaseClic
                    tab_ligne.push(temp.etat)
                else
                    tab_ligne.push(nil)
                end
            end
            tab_etat.push(tab_ligne)
        end
        return tab_etat
    end

    #Vérifie si les coordonnées passées en paramètre désignent une case du plateau
    # @param x [Fixnum] l'abscisse de la case
	# @param y [Fixnum] l'ordonnée de la case
	# @return [void]
    def coord_valides?(x,y)
        if x < @taille && x>= 0 && y < @taille && y>= 0
            return true
        end
        
        return false       
    end

    #Retourne la case aux coordonnées passées en paramètre
    # @param x [Fixnum] l'abscisse de la case
	# @param y [Fixnum] l'ordonnée de la case
	# @return [void]
    def donne_case(x,y)
        if coord_valides?(x,y)
            return @damier[x][y]
        end
        
    #raise d une erreur ici car coordonnées invalides;
        
    end

	# Vérifie si le jeu est finis ou non
	# @return [Boolean] *vrai* si il a gagné, *faux* sinon
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

	# Affiche dans une fenêtre si la partie est finie ou si il y a des erreurs ou non
	# @return [void]
    def on_click_verif
        self.afficher_erreur
    end

    # Empile dans la pile d'action l'action effectué sur la case concernée par les coordonnées passées en paramètre
    # @param x [Fixnum] l'abscisse de la case
	# @param y [Fixnum] l'ordonnée de la case
	# @return [void]
    def on_click_jeu(x,y)
        @pile_action.empiler(Action.new(x,y))
        @damier[x][y].suivant
    end

    # Ouvre une fenêtre pop-up qui affiche une aide si il y en a une de disponible sur le jeu en cours
	# @param jeu [Jeu] le jeu tester
	# @return [void]
    def on_click_aide(jeu)
        txt =''
        if(self.verifier_damier.empty?)
            nb_aide = @aide.tester_tout()
            p nb_aide
            case nb_aide

                when 1
                    txt ='Il reste des 1 à isoler !'
                    @malus_aide += 5

                when 2
                    txt ='Il y a une case blanche entre 2 chiffres qui pourrait être cliquer!'
                    @malus_aide += 5

                when 3
                    txt = 'Il y a des cases en diagonales qui peuvent être separées'
                    @malus_aide += 5

                when 4
                    txt = "Il y a une case blanche seule"
                    @malus_aide += 10

                when 5
                    txt = "Il y a une case noire qui ne sera pas reliée aux autres"
                    @malus_aide += 10
		    
		        when 6
                    txt = "Une ile terminée n'est pas complètement entourée"
                    @malus_aide += 5

                when 7
                    txt = "Des cases ne sont pas atteignable par les iles, il faut les colorer en noire"
                    @malus_aide += 10
                    
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

    #Annule le dernier coup joué
    def on_click_undo
        @pile_action.annuler_dernier_coup
    end

    #Ouvre la fenêtre de règles du jeu
	# @param jeu [Jeu] le jeu en cours
	# @return [void]
    def on_click_regle(jeu)
        builder = Gtk::Builder.new

        builder.add_from_file("../Glade/regles.glade")
		window = builder.get_object("fen_regle")
        window.signal_connect('destroy') { |_widget| window.destroy}

        btn_compris = builder.get_object("btn_compris")
        btn_compris.signal_connect('clicked'){|_widget| window.destroy}

        window.show_all
        Gtk.main();
    end

	#Créer un point de retour dans la pile d'actions
	# @return [void]
    def on_click_creer_retour
        @pile_action.ajout_point_de_retour
    end

	#Nous repositionne sur le dernier point de retour de la pile d'actions
	# @return [void]
    def on_click_aller_retour
        @pile_action.vers_dernier_point_de_retour
    end

end
