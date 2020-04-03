# Etat d'une case
# @attr_reader etat etat entre BLANC, NOIR ou POINT
# @attr BLANC [String] chaine correspondant à l'état blanc
# @attr NOIR [String] chaine correspondant à l'état noir
# @attr POINT [String] chaine correspondant à l'état point
class Etat
    attr_reader :etat
    BLANC ||= 'b'
    NOIR ||= 'n'
    POINT ||= 'b+'

    @etat

    def initialize
        @etat = BLANC
    end
    
    # Passe l'état à l'état suivant
    def suivant!
        case(@etat)
        when BLANC
            @etat = NOIR
        when NOIR
            @etat = POINT
        when POINT
            @etat = BLANC
        else
            @etat = BLANC
        end
    end

    # Passe l'état à l'état précédent
    def precedent!
        case(etat)
        when BLANC
            @etat = POINT
        when NOIR
            @etat = BLANC
        when POINT
            @etat = NOIR
        else
            @etat = BLANC
        end
    end
end