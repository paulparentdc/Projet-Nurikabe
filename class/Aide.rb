class Aide
    @plateau
    
    def initialize(un_plateau)

        @plateau = un_plateau

    end

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

        return 0

   end

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

    def tester_blanc_isole
        for i in (0..@plateau.taille)
            for j in (0..@plateau.taille)

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

    def tester_chemin
        nb_sortie = 0;
        for i in (0..@plateau.taille)
            for j in (0..@plateau.taille)

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
 

    #Fonctions de test sur les cases
    def case_chiffre?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr != 'n' && @plateau.donne_case(i,j).to_s.chr != 'b'
    end

    def case_noire?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr == 'n'
    end

    def case_blanche?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr == 'b'
    end

    def case_1?(i,j)
        return @plateau.coord_valides?(i,j) && @plateau.donne_case(i,j).to_s.chr == '1'
    end

    def case_bord?(i,j)
        return !@plateau.coord_valides?(i,j)
    end

    
end