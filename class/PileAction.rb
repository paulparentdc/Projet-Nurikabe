class PileAction

    @pile 
    @nbPointDeRetour

    def initialize()
        @nbPointDeRetour=0
        @pile=[]
    end

    def empiler(uneAction)
        @pile.push(uneAction)
    end
    
    def depiler()
        if(@pile.size>0)
            return @pile.pop()
        else
            raise "Plus rien à dépiler"
        end
    end

    def estVide?()
        return (@pile.size == 0)
    end

    def combienDePDR()
        return @nbPointDeRetour
    end
end