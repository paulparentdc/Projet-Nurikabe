load 'Sauvegarde.rb'
load 'Plateau.rb'

class Jeu
    attr_reader :plateau, :timer, :nomJoueur
    @plateau
    @timer
    @nomJoueur

    def initialize(plateau, timer, nomJoueur)
        @plateau, @timer, @nomJoueur = plateau, timer, nomJoueur
    end

end

jeu = Sauvegarde.charger_template("../data/template/plateau.txt")
puts jeu.plateau.affiche_toi
# plateau.afficheToi
# puts plateau