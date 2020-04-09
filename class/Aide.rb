# Permet de trouver des aides sur un plateau
# @note un résumé de nos aides peut être trouvé à cette adresse https://www.conceptispuzzles.com/index.aspx?uri=puzzle/nurikabe/techniques
# @attr plateau [Plateau] plateau de jeu
class Aide
    @plateau
    
    def initialize(un_plateau)
        @plateau = un_plateau
    end
    
    # Applique toutes les aides et donne la première applicable
    # @return un numéro correspondant à l'aide appicable
    def tester_tout
    
        if self.tester_un
            return 1
        end

        if self.tester_espace
            return 2
        end

        if self.tester_diagonale
            return 3
        end

        if self.tester_blanc_isole
            return 4
        end

        if self.tester_chemin
            return 5
        end

        if self.entoure_ile_complete
            return 6
        end

        if self.trop_loin
            return 7
        end

        return 0

    end

    # Regarde dans le plateau si on peut appliquer la méthode Starting techniques 1 : Island of 1
    def tester_un
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)

                if self.case_1?(i,j)

                        if self.case_blanche?(i+1,j)
                            return true
                        end
              
                        if self.case_blanche?(i,j+1)
                            return true
                        end

                        if self.case_blanche?(i,j-1)
                            return true
                        end
                   
                        if self.case_blanche?(i-1,j)
                            return true
                        end
                end
            end
        end
        return false #Cas où aucun 1 seul n'a été trouvé
    end

    # Regarde dans le plateau si on peut appliquer la méthode Starting techniques 2 : Clues separated by one square
    def tester_espace
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)

                if self.case_chiffre?(i,j)
                  
                        if self.case_chiffre?(i+2,j) && self.case_blanche?(i+1,j)
                            return true
                        end
                
                        if self.case_chiffre?(i,j+2) && self.case_blanche?(i,j+1)
                            return true
                        end
                
                        if self.case_chiffre?(i,j-2) && self.case_blanche?(i,j-1)
                            return true
                        end
                   
                        if self.case_chiffre?(i-2,j) && self.case_blanche?(i-1,j)
                            return true
                        end
                 
                end
            end
        end
        return false #Cas où aucun espace n'a été trouvé entre 2 cases chiffre
    end

    # Regarde dans le plateau si on peut appliquer la méthode Starting techniques 3 : Diagonally adjacent clues 
    def tester_diagonale
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)

                if self.case_chiffre?(i,j)

                        if self.case_chiffre?(i+1,j+1)
                            if !self.case_noire?(i+1,j) || !self.case_noire?(i,j+1)
                                return true
                            end
                        end
                    
                        if self.case_chiffre?(i-1,j-1)
                            if !self.case_noire?(i-1,j)  || !self.case_noire?(i,j-1)
                                return true
                            end
                        end         
                    
                        if self.case_chiffre?(i+1,j-1)
                            if !self.case_noire?(i+1,j)  || !self.case_noire?(i,j-1)
                                return true
                            end
                        end
                       
                        if self.case_chiffre?(i-1,j+1)
                            if !self.case_noire?(i-1,j)  || !self.case_noire?(i,j+1)
                                return true
                            end
                        end
                end
            end
        end
        return false #Cas où on n'a pas trouvé de case vide en diagonale de 2 cases chiffre
    end

    # Regarde dans le plateau si on peut appliquer la méthode Basic Techniques 1 : Surrounded square
    def tester_blanc_isole
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)

                if self.case_blanche?(i,j)

                    if self.case_bord?(i+1,j) || self.case_noire?(i+1,j)
                        if self.case_bord?(i-1,j) || self.case_noire?(i-1,j)
                            if self.case_bord?(i,j+1) || self.case_noire?(i,j+1)
                                if self.case_bord?(i,j-1) || self.case_noire?(i,j-1)
                                    return true
                                end
                            end
                        end
                    end

                end
            end
        end
        return false #Cas où la case n'est pas isolée
    end

    # Regarde dans le plateau si on peut appliquer la méthode Basic Techniques 2 : Wall expansion
    def tester_chemin
        nb_sortie = 0;
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)

                if self.case_noire?(i,j)


                    nb_sortie = 0;#Compteur pour le nombre de case libre autour de la case que l'on analyse
                    x_courant = i
                    y_courant = j

                    while(nb_sortie==1)
                        x_sortie = -1
                        y_sortie = -1
                        
                        #On cherche la ou les cases de sortie
                        if self.case_blanche?(x_courant+1,y_courant) || self.case_noire?(x_courant+1,y_courant)
                            nb_sortie+=1
                            x_sortie = x_courant+1
                            y_sortie = y_courant
                        end

                        if self.case_blanche?(x_courant-1,y_courant) || self.case_noire?(x_courant-1,y_courant)
                            nb_sortie+=1
                            x_sortie = x_courant-1
                            y_sortie = y_courant
                        end

                        if self.case_blanche?(x_courant,y_courant+1) || self.case_noire?(x_courant,y_courant+1)
                            nb_sortie+=1
                            x_sortie = x_courant
                            y_sortie = y_courant+1
                        end

                        if self.case_blanche?(x_courant,y_courant-1) || self.case_noire?(x_courant,y_courant-1)
                            nb_sortie+=1
                            x_sortie = x_courant
                            y_sortie = y_courant-1
                        end

                        if(nb_sortie == 1)
                            if self.case_blanche?(x_sortie,y_sortie)
                                return true
                            else
                              return false
                            end
                                
                        end

                    end

                end


            end
        end
        return false #Cas où la case n'est pas isolée

    end

    # Regarde dans le plateau si on peut appliquer la méthode Basic Techniques 8 : Surrounding a completed island
    def entoure_ile_complete
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)
              if self.case_chiffre?(i,j)
                tab_cases_point = [@plateau.donne_case(i,j)]
                taille_ile = @plateau.donne_case(i,j).to_s
  
                tab_cases_point.each do |c|
                    x = c.x
                    y = c.y
    
                    if case_point?(x+1,y) && !tab_cases_point.include?(@plateau.donne_case(x+1,y))
                        tab_cases_point.push(@plateau.donne_case(x+1,y))
                    end
    
                    if case_point?(x-1,y) && !tab_cases_point.include?(@plateau.donne_case(x-1,y))
                        tab_cases_point.push(@plateau.donne_case(x-1,y))
                    end
    
                    if case_point?(x,y+1) && !tab_cases_point.include?(@plateau.donne_case(x,y+1))
                        tab_cases_point.push(@plateau.donne_case(x,y+1))
                    end
    
                    if case_point?(x,y-1) && !tab_cases_point.include?(@plateau.donne_case(x,y-1))
                        tab_cases_point.push(@plateau.donne_case(x,y-1))
                    end
  
                end
  
                if tab_cases_point.length == taille_ile.to_i
                  tab_cases_point.each do |c|
                    x = c.x
                    y = c.y
  
                    if case_vide?(x+1,y)
                      return true
                    end
                    if case_vide?(x-1,y)
                      return true
                    end
                    if case_vide?(x,y+1)
                      return true
                    end
                    if case_vide?(x,y-1)
                      return true
                    end
                  end
                end
              end
            end
          end
        return false
    end
 
    # Regarde dans le plateau si on peut appliquer la méthode Basic Techniques 10 : Unreachable square
    def trop_loin
        tab_atteignable = []
        for i in (0..@plateau.taille-1)
            for j in (0..@plateau.taille-1)
                if self.case_chiffre?(i,j)
                    if(!tab_atteignable.include?(@plateau.donne_case(i,j)))
                        tab_atteignable.push(@plateau.donne_case(i,j))
                    end
                    taille = (@plateau.donne_case(i,j).chiffre) -1 
                    decalage_x = 0
                    taille.downto(0) do |y|
                        (0..decalage_x).each do |x|
                            if(@plateau.coord_valides?(i+x,j+y) && !tab_atteignable.include?(@plateau.donne_case(i+x,j+y)))
                                tab_atteignable.push(@plateau.donne_case(i+x,j+y))
                            end
                            if(@plateau.coord_valides?(i-x,j+y) && !tab_atteignable.include?(@plateau.donne_case(i-x,j+y)))
                                tab_atteignable.push(@plateau.donne_case(i-x,j+y))
                            end
                            if(@plateau.coord_valides?(i+x,j-y) && !tab_atteignable.include?(@plateau.donne_case(i+x,j-y)))
                                tab_atteignable.push(@plateau.donne_case(i+x,j-y))
                            end
                            if(@plateau.coord_valides?(i-x,j-y) && !tab_atteignable.include?(@plateau.donne_case(i-x,j-y)))
                                tab_atteignable.push(@plateau.donne_case(i-x,j-y))
                            end
                        end
                        decalage_x+=1
                    end 

                end
            end
        end
        (0..@plateau.taille-1).each do |i|
            (0..@plateau.taille-1).each do |j|
                if(!tab_atteignable.include?(@plateau.donne_case(i,j)) && !case_noire?(i,j))
                    return true
                end
            end
        end
        return false
    end
                        



    # Regarde aux coordonnées si la case est une CaseChiffre
    def case_chiffre?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr != 'n' && @plateau.donne_case(i,j).to_s.chr != 'b'
    end
    # Regarde aux coordonnées si la case est noire
    def case_noire?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr == 'n'
    end
    # Regarde aux coordonnées si la case est blanche
    def case_blanche?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr == 'b'
    end
    # Regarde aux coordonnées si la case contient un point
    def case_point?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s == 'b+'
    end
    # Regarde aux coordonnées si la case est vide
    def case_vide?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s == 'b'
    end
    # Regarde aux coordonnées si la case contient un 1
    def case_1?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s == '1'
    end
    # Regarde aux coordonnées si la case est hors du plateau
    def case_bord?(i,j)
        return !@plateau.coord_valides?(i,j)
    end

    
end
