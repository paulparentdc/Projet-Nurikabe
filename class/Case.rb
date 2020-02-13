load 'Etat.rb'

class Case
    

    @bouton
    @etat
    @plateau
    @x
    @y

    def initialize(x,y)
        @x, @y = x, y
        @etat = Etat::BLANC
    end

    def to_s
        ' '
    end
end