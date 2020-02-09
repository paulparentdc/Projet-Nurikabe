load 'Sauvegarde.rb'
load 'Plateau.rb'

class Jeu
    @plateau
    @timer
    @nomJoueur

    def initialize

    end
end


plateau = Plateau.new(Sauvegarde.chargerTemplate("./data/template/plateau.txt"))
puts plateau