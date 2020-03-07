class Action
    attr_reader :x, :y
    attr_accessor :point_de_retour
    @x
    @y
    @point_de_retour

    def initialize(x,y)
        @x,@y,@point_de_retour=x,y
        @point_de_retour=false;
    end

    def est_point_de_retour?
        return @point_de_retour
    end

    def to_s
        "Action : Coordonnées : #{@x}, #{@y}  , est un point de retour?:#{point_de_retour}"
    end

    




end