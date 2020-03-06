

class Aide
   def Aide.testerTout(unPlateau)

    if Aide.testerUn(unPlateau) 
        return 1
    end

    if Aide.testerEspace(unPlateau) 
        return 2
    end

    if Aide.testerDiagonale(unPlateau) 
        return 3
    end

    if Aide.testerBlancIsole(unPlateau) 
        return 4
    end

    return 0

   end

   def Aide.testerUn(unPlateau)
    for i in range(unPlateau.taille)
        for j in range(unPlateau.taille)
            if unPlateau.donneTaCaseInt(i,j) == 1
                if unPlateau.coordValides?(i+1,j)
                    if(unPlateau.donneTaCaseInt(i+1,j)) != -1
                        return true
                    end
                end
                   

                if unPlateau.coordValides?(i,j+1)
                    if unPlateau.donneTaCaseInt(i,j+1) != -1
                        return true
                    end
                    
                end
                

                if unPlateau.coordValides?(i,j-1)
                    
                    if unPlateau.donneTaCaseInt(i,j-1) != -1
                        return true
                    end


                end
                

                if unPlateau.coordValides?(i-1,j)

                    if unPlateau.donneTaCaseInt(i-1,j) != -1
                        return true
                    end
                   
                end
               

               return false


            end
        end

    end
   end

   def Aide.testerEspace(unPlateau)
        for i in range(unPlateau.taille)
            for j in range(unPlateau.taille)
                
                if unPlateau.donneTaCaseInt(i,j) > 0

                    if unPlateau.coordValides?(i+2,j)
                        if unPlateau.donneTaCaseInt(i+2,j) > 0 && unPlateau.donneTaCaseInt(i+1,j) !=-1
                            return true
                        end
                    end
                    

                    if unPlateau.coordValides?(i,j+2)
                        if unPlateau.donneTaCaseInt(i,j+2) >0 && unPlateau.donneTaCaseInt(i,j+1) !=-1
                            return true
                        end  
                    end
                    

                    if unPlateau.coordValides?(i,j-2)    
                        if unPlateau.donneTaCaseInt(i,j-2) >0 && unPlateau.donneTaCaseInt(i,j-1) !=-1
                            return true
                        end
                    end
                    
                    
                    if unPlateau.coordValides?(i-2,j)
                        if unPlateau.donneTaCaseInt(i-2,j) > 0 && unPlateau.donneTaCaseInt(i-1,j) !=-1
                            return true
                        end
                    end            
                end
            end
        end
        return false
   end

    def Aide.testerDiagonale(unPlateau)
        for i in range(unPlateau.taille)
            for j in range(unPlateau.taille)

                if unPlateau.donneTaCaseInt(i,j) > 0

                    if unPlateau.coordValides?(i+1,j+1)
                        if unPlateau.donneTaCaseInt(i+1,j+1) > 0 
                            if unPlateau.donneTaCaseInt(i+1,j) !=-1 || unPlateau.donneTaCaseInt(i,j+1) !=-1
                                return true
                            end
                        end
                    end
                    

                    if unPlateau.coordValides?(i-1,j-1)
                        if unPlateau.donneTaCaseInt(i-1,j-1) >0 
                            if unPlateau.donneTaCaseInt(i-1,j) !=-1 || unPlateau.donneTaCaseInt(i,j-1) !=-1
                                return true
                            end
                        end
                        
                    end
        

                    if unPlateau.coordValides?(i+1,j-1)
                        if unPlateau.donneTaCaseInt(i+1,j-1) >0
                            if unPlateau.donneTaCaseInt(i+1,j) !=-1 || unPlateau.donneTaCaseInt(i,j-1) !=-1
                                return true
                            end
                        end
                    end
                    
                    
                    if unPlateau.coordValides?(i-1,j+1)
                        if unPlateau.donneTaCaseInt(i-1,j+1) > 0
                            if unPlateau.donneTaCaseInt(i-1,j) !=-1 || unPlateau.donneTaCaseInt(i,j+1) !=-1
                                return true
                            end
                        end
                    
                    end
                
                

                end
            end
        end
        return false
    end

    def Aide.testerBlancIsole(unPlateau)
        for i in range(unPlateau.taille)
            for j in range(unPlateau.taille)
                
                if unPlateau.donneTaCaseInt(i,j) == 0

                    if !unPlateau.coordValides?(i+1,j) || unPlateau.donneTaCaseInt(i+1,j)==-1
                        if !unPlateau.coordValides?(i-1,j) || unPlateau.donneTaCaseInt(i-1,j)==-1
                            if !unPlateau.coordValides?(i,j+1) || unPlateau.donneTaCaseInt(i,j+1)==-1
                                if !unPlateau.coordValides?(i,j-1) || unPlateau.donneTaCaseInt(i,j-1)==-1
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
