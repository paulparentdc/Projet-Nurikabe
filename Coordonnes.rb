class Coordonnee
    @x
    @y
    private_class_method :new
    attr_accessor :x , :y

    def Coordonnee(x,y)
        @x,@y=x,y
    end
    
    def to_s
        "%n Coordonnée: {@x};{@y} "
    end
end
