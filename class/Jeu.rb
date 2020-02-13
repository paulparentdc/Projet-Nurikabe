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

jeu = Sauvegarde.chargerTemplate("../data/template/plateau.txt")
puts jeu.plateau.afficheToi
# plateau.afficheToi
# puts plateau