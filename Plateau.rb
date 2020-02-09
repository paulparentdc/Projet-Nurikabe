load 'Etat.rb'

class Plateau
    @damier
    @damierCorrect
    @taille
    @pileAction
    @aide

    def initialize(template)
        @damier = template[:damier]
        @damierCorrect = template[:damierCorrect]
        @taille = template[:taille]
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

    def verifier
    end

    def afficherErreur
    end

    def donneTaCaseInt(x,y)
    end

    def afficheToi
    end

    def onClickVerif
    end

    def onClickVerif
    end

    def onClickJeu(x,y)
    end

    def onClickAide
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