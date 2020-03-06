class Action
    @x
    @y
    @point_de_retour=false

    def initialize(x,y,retour)
        @x,@y,@point_de_retour=x,y,retour
    end

    def est_point_de_retour?
        return @point_de_retour
    end

    def to_s
        "Action : Coordonnées : #{@x}, #{@y}  , est un point de retour?:#{point_de_retour}"
    end

    




end