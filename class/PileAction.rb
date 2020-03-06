class PileAction

    @pile 
    @nb_point_de_retour

    def initialize()
        @nb_point_de_retour=0
        @pile=[]
    end

    def empiler(une_action)
        @pile.push(une_action)
    end
    
    def depiler()
        if(@pile.size>0)
            return @pile.pop()
        else
            raise "Plus rien à dépiler"
        end
    end

    def est_vide?()
        return (@pile.size == 0)
    end

    def combien_de_PDR()
        return @nb_point_de_retour
    end
end