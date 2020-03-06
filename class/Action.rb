class Action
    @x
    @y
    @pointDeRetour=false

    def initialize(x,y,retour)
        @x,@y,@pointDeRetour=x,y,retour
    end

    def estPointDeRetour?
        return @pointDeRetour
    end

    def to_s
        "Action : Coordonnées : #{@x}, #{@y}  , est un point de retour?:#{pointDeRetour}"
    end

    




end