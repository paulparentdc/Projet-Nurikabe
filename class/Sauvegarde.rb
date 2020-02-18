load 'Case.rb'
load 'CaseClic.rb'
load 'CaseChiffre.rb'

class Sauvegarde

    # Chargement du template
    # @note le chemin devra être valide et le fichier correct et lisible
    # @param chemin le chemin à du template choisi
    # @return le damier avec et sans correction par hachage accessible via +:damier+ pour obtenir la matrice de cases et +:damierCorrect+ pour obtenir la matrice de correction indiquand la couleur que les cases doivent prendre
    # @return +nil+ est renvoyé si un problème est rencontré
    def Sauvegarde.chargerTemplate(chemin)
        # Chargement du fichier
        text = File.open(chemin).read
        return nil if text == nil
        text.gsub!(/\r\n?/, "\n")

        #Objets
        niveau, taille = nil
        compteur=0
        matrice_plateau = []
        matrice_solution = []

        #Parcours ligne par ligne
        text.each_line do |line|
            #Retire les commentaires
            next if line.include? "#"

            if niveau == nil
                niveau = line
            elsif taille == nil
                taille = line.to_i
            else
                if (temp = line.split(' ')).length == taille
                    #Solution
                    matrice_solution.push(temp)

                    #Plateau de jeu
                    i=-1
                    matrice_plateau.push(temp.map do |x|
                        i+=1
                        (temp = x.to_i) == 0 ? CaseClic.new(compteur,i) : CaseChiffre.new(compteur,i, temp)
                        
                    end)
                    compteur+=1
                else
                    #Fichier invalide
                    return nil
                end
            end
        end
        
        #Verifier si tout a été initialisé
        if niveau == nil && taille == nil && compteur != taille
            return nil
        else
            plateau = Plateau.new(matrice_plateau, matrice_solution, taille, niveau)
            Case.ajoutPlateau(plateau)
            return Jeu.new(plateau, Time.now, nil)
        end
    end
end
