
class Etat
    attr_reader :etat
    BLANC ||= 'b'
    NOIR ||= 'n'
    POINT ||= 'b+'

    @etat

    def initialize
        @etat = BLANC
    end
    
    def suivant!
        case(@etat)
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

    def precedent!
        case(etat)
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
end