

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
                if(unPlateau.coordValides(i+1,j))
                   
                end
            end
        end

    end
   end

   def testerEspace(unPlateau)
   end

   def testerDiagonale(unPlateau)
   end

   def testerBlancIsole(unPlateau)
   end

end
