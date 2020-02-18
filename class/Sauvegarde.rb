load 'Case.rb'
load 'CaseClic.rb'
load 'CaseChiffre.rb'
require 'fileutils'


class Sauvegarde


    #Chargement d'une partie
    #@param le jeu a sauvegarder
    def Sauvegarde.creerSauvegarde(jeu)
       a= Marshal::dump(jeu)
       chemin_de_base="data/save/"+jeu.nomJoueur+"/"+Time.new.strftime("%d_%m_%Y__%H_%M")+".txt"

       dirname=File::dirname(chemin_de_base)
       unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
       end

       #puts chemin_de_base
       myFile = File::open(chemin_de_base,"w+")
       myFile.write(a)
       myFile.close
    end

    #Chargement d'une partie
    #@note le chemin devra être valide 
    #@param le chemin de la sauvegarde
    #@return le jeu correspondant au chemin


    def Sauvegarde.chargerSauvegarde(chemin_de_base)
        #chemin_de_base="data/save/"+joueur+"/"+Time.new.strftime("%d_%m_%Y__%H_%M")+".txt"
        if File.exist?(chemin_de_base)
            a=File.open(chemin_de_base,"r")
            jeu=Marshal::load(File::read(chemin_de_base))
            a.close
            return jeu
        else
            raise "no Such file for ChargerSauvegarde"
        end

    end
    #Suppression d'une partie
    #@note le chemin devra être valide 
    #@param le chemin de la sauvegarde a supprimer
    def Sauvegarde.supprimerSauvegarde(chemin)
        if File.exist?(chemin)
             File.delete(chemin)
        else
             raise "no such file"
        end
    end    
    
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
                        (temp = x.to_i) == 0 ? CaseClic.new(i,compteur) : CaseChiffre.new(i,compteur, temp)
                        
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
            return Jeu.new(plateau, Time.now, nil)
        end
    end
end
