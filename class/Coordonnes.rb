# Coordonnée constituée d'un x et d'un y
# @attr x [Fixnum] variable x de la coordonnée
# @attr y [Fixnum] variable y de la coordonnée
class Coordonnee
    @x
    @y
    private_class_method :new
    attr_accessor :x , :y

    def Coordonnee(x,y)
        @x,@y=x,y
    end
    
    # @!visibility private
    def to_s
        "%n Coordonnée: #{@x};#{@y} "
    end
end
