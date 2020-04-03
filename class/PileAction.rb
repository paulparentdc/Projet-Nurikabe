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
        return if @pile.empty?
        return if self.get_derniere_action.est_point_de_retour? == true

        self.get_derniere_action.point_de_retour = true
        @nb_point_de_retour += 1
        self.appliquer_couleur
    end

    def vers_dernier_point_de_retour
        return if @nb_point_de_retour == 0

        while(!self.est_vide? && !self.get_derniere_action.est_point_de_retour?)
            p get_derniere_action
            self.annuler_dernier_coup
        end
        
        self.get_derniere_action.point_de_retour = false if !self.est_vide?
        @nb_point_de_retour -= 1

        return if @nb_point_de_retour < 1

        self.appliquer_couleur
        #retire la couleur grise pour ce point de retour
        i=0
        @pile.each do |coord|
            i+=1
            next if i <= @nb_point_de_retour
            puts "on actualise " + coord.x.to_s + " et " + coord.y.to_s
            @plateau.damier[coord.x][coord.y].actualises_toi
        end

    end
    
    def serialiser
        return @pile
    end

    def appliquer_couleur
        tab_temp = []
        tab_cases_noires = []
        
        @pile.each do |coord|
            tab_temp << [coord.x, coord.y]
        end

        # Ajoute les coordonnées une seule fois dans la liste et retire ceux qui sont présent un nombre paire de fois
            #On obtient une liste de cases noire
        tab_temp.each do |coord|
            tab_cases_noires << coord if (tab_temp.count(coord) % 2 != 0) && (tab_cases_noires.count(coord) == 0) 
        end

        tab_cases_noires.each do |coord|
            @plateau.damier[coord[0]][coord[1]].en_gris
        end


    end
end