

class Aide
   def Aide.tester_tout(un_plateau)

    if Aide.tester_un(un_plateau) 
        return 1
    end

    if Aide.tester_espace(un_plateau) 
        return 2
    end

    if Aide.tester_diagonale(un_plateau) 
        return 3
    end

    if Aide.tester_blanc_isole(un_plateau) 
        return 4
    end

    return 0

   end

   def Aide.tester_un(un_plateau)
    for i in range(un_plateau.taille)
        for j in range(un_plateau.taille)
            if un_plateau.donne_ta_case_int(i,j) == 1
                if un_plateau.coord_valides?(i+1,j)
                    if(un_plateau.donne_ta_case_int(i+1,j)) != -1
                        return true
                    end
                end
                   

                if un_plateau.coord_valides?(i,j+1)
                    if un_plateau.donne_ta_case_int(i,j+1) != -1
                        return true
                    end
                    
                end
                

                if un_plateau.coord_valides?(i,j-1)
                    
                    if un_plateau.donne_ta_case_int(i,j-1) != -1
                        return true
                    end


                end
                

                if un_plateau.coord_valides?(i-1,j)

                    if un_plateau.donne_ta_case_int(i-1,j) != -1
                        return true
                    end
                   
                end
               

               return false


            end
        end

    end
   end

   def Aide.tester_espace(un_plateau)
        for i in range(un_plateau.taille)
            for j in range(un_plateau.taille)
                
                if un_plateau.donne_ta_case_int(i,j) > 0

                    if un_plateau.coord_valides?(i+2,j)
                        if un_plateau.donne_ta_case_int(i+2,j) > 0 && un_plateau.donne_ta_case_int(i+1,j) !=-1
                            return true
                        end
                    end
                    

                    if un_plateau.coord_valides?(i,j+2)
                        if un_plateau.donne_ta_case_int(i,j+2) >0 && un_plateau.donne_ta_case_int(i,j+1) !=-1
                            return true
                        end  
                    end
                    

                    if un_plateau.coord_valides?(i,j-2)    
                        if un_plateau.donne_ta_case_int(i,j-2) >0 && un_plateau.donne_ta_case_int(i,j-1) !=-1
                            return true
                        end
                    end
                    
                    
                    if un_plateau.coord_valides?(i-2,j)
                        if un_plateau.donne_ta_case_int(i-2,j) > 0 && un_plateau.donne_ta_case_int(i-1,j) !=-1
                            return true
                        end
                    end            
                end
            end
        end
        return false
   end

    def Aide.tester_diagonale(un_plateau)
        for i in range(un_plateau.taille)
            for j in range(un_plateau.taille)

                if un_plateau.donne_ta_case_int(i,j) > 0

                    if un_plateau.coord_valides?(i+1,j+1)
                        if un_plateau.donne_ta_case_int(i+1,j+1) > 0 
                            if un_plateau.donne_ta_case_int(i+1,j) !=-1 || un_plateau.donne_ta_case_int(i,j+1) !=-1
                                return true
                            end
                        end
                    end
                    

                    if un_plateau.coord_valides?(i-1,j-1)
                        if un_plateau.donne_ta_case_int(i-1,j-1) >0 
                            if un_plateau.donne_ta_case_int(i-1,j) !=-1 || un_plateau.donne_ta_case_int(i,j-1) !=-1
                                return true
                            end
                        end
                        
                    end
        

                    if un_plateau.coord_valides?(i+1,j-1)
                        if un_plateau.donne_ta_case_int(i+1,j-1) >0
                            if un_plateau.donne_ta_case_int(i+1,j) !=-1 || un_plateau.donne_ta_case_int(i,j-1) !=-1
                                return true
                            end
                        end
                    end
                    
                    
                    if un_plateau.coord_valides?(i-1,j+1)
                        if un_plateau.donne_ta_case_int(i-1,j+1) > 0
                            if un_plateau.donne_ta_case_int(i-1,j) !=-1 || un_plateau.donne_ta_case_int(i,j+1) !=-1
                                return true
                            end
                        end
                    
                    end
                
                

                end
            end
        end
        return false
    end

    def Aide.tester_blanc_isole(un_plateau)
        for i in range(un_plateau.taille)
            for j in range(un_plateau.taille)
                
                if un_plateau.donne_ta_case_int(i,j) == 0

                    if !un_plateau.coord_valides?(i+1,j) || un_plateau.donne_ta_case_int(i+1,j)==-1
                        if !un_plateau.coord_valides?(i-1,j) || un_plateau.donne_ta_case_int(i-1,j)==-1
                            if !un_plateau.coord_valides?(i,j+1) || un_plateau.donne_ta_case_int(i,j+1)==-1
                                if !un_plateau.coord_valides?(i,j-1) || un_plateau.donne_ta_case_int(i,j-1)==-1
                                    return true
                                end
                            end
                        end
                    end
                
                end
            end
        end
        return false
    end

end
