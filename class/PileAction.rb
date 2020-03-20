load 'Action.rb'
class PileAction
    attr_reader :nb_point_de_retour

    @pile 
    @nb_point_de_retour
    @plateau

    def initialize(plateau)
        @nb_point_de_retour=0
        @pile=[]
        @plateau = plateau
    end

    def initialize(plateau, pile)
        @nb_point_de_retour = 0
        @pile=pile
        @plateau = plateau

        @pile.each do |action|
            @nb_point_de_retour +=1 if action.est_point_de_retour?
        end
    end

    def empiler(une_action)
        @pile.push(une_action)
    end
    
    def depiler!()
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
    

    def get_derniere_action
        return @pile[@pile.size-1]
    end

    def annuler_dernier_coup
        return if self.est_vide?
        derniere_action = self.depiler!
        x = derniere_action.x
        y = derniere_action.y
        case_temp = @plateau.damier[x][y]
        case_temp.precedent
    end

    def ajout_point_de_retour
        return if self.get_derniere_action.est_point_de_retour? == true

        self.get_derniere_action.point_de_retour = true
        @nb_point_de_retour += 1
    end

    def vers_dernier_point_de_retour
        return if @nb_point_de_retour == 0

        while(!self.est_vide? && !self.get_derniere_action.est_point_de_retour?)
            p get_derniere_action
            self.annuler_dernier_coup
        end
        
        self.get_derniere_action.point_de_retour = false if !self.est_vide?
        @nb_point_de_retour -= 1
    end
    
    def serialiser
        return @pile
    end
end