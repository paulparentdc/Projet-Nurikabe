# Sert à mémoriser les coordonnées d'une action
# @attr_reader x [Fixnum] coordonnée x de l'action faite
# @attr_reader y [Fixnum] coordonnée y de l'action faite
# @attr_reader point_de_retour [Boolean] indique si l'action est un point de retour
class Action
    attr_reader :x, :y
    attr_accessor :point_de_retour
    @x
    @y
    @point_de_retour

	# Constructeur de Action
	# @param x [Fixnum] la coordonée x de l'action
	# @param y [Fixnum] la coordonée y de l'action
    def initialize(x,y)
        @x,@y,@point_de_retour=x,y
        @point_de_retour=false;
    end

	# Indique si l'action est un point de retour
	# @return [Boolean] *true* si c'est un point de retour, *false* sinon
    def est_point_de_retour?
        return @point_de_retour
    end

	# @!visibility private
    def to_s
        "Action : Coordonnées : #{@x}, #{@y}  , est un point de retour?:#{point_de_retour}"
    end
end
