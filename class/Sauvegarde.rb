load 'Case.rb'
load 'CaseClic.rb'
load 'CaseChiffre.rb'
load 'Plateau.rb'
load 'Jeu.rb'
load 'PileAction.rb'
load 'Etat.rb'

require 'fileutils'


class Sauvegarde

    class DonneesJeu
        attr_reader :plateau_etat, :pile_action, :malus_aide, :nom_joueur, :temps_de_jeu, :chemin_template


        @plateau_char
        @plateau_etat
        @pile_action
        @malus_aide
        @chemin_template
        
        @nom_joueur
        @temps_de_jeu
    
        
        def initialize(jeu)
            @nom_joueur, @temps_de_jeu = jeu.nom_joueur, jeu.temps_de_jeu
            
            @pile_action = jeu.plateau.pile_action.serialiser
            @malus_aide = jeu.plateau.malus_aide
            @chemin_template = jeu.plateau.chemin_template
            @plateau_etat = jeu.plateau.get_plateau_etat
        end
    end

    #Chargement d'une partie
    #@param le jeu a sauvegarder
    def Sauvegarde.creer_sauvegarde(jeu)
        
        #return if jeu.en_jeu == false
        jeu_filtree = DonneesJeu.new(jeu)
        donnees = Marshal::dump(jeu_filtree)

        chemin_de_base="../data/save/"+jeu.nom_joueur+"/"+Time.new.strftime("%d-%m-%Y   %Hh%Mm%Ss")+".snurikabe"

        dirname=File::dirname(chemin_de_base)
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end

       #puts chemin_de_base
       mon_fichier = File::open(chemin_de_base,"w+")
       mon_fichier.write(donnees)
       mon_fichier.close
    end


    # Chargement d'une partie
    # @note le chemin devra être valide 
    # @param le chemin de la sauvegarde
    # @return le jeu correspondant au chemin
    def Sauvegarde.charger_sauvegarde(chemin_de_base)
        #chemin_de_base="data/save/"+joueur+"/"+Time.new.strftime("%d_%m_%Y__%H_%M")+".txt"
        if !File.exist?(chemin_de_base)
            raise "Fichier inexistant"
            return
        end


        fichier=File.open(chemin_de_base,"r")
        donnees=Marshal::load(File::read(chemin_de_base))
        fichier.close

        # :plateau_char

        plateau = Sauvegarde.charger_template(donnees.chemin_template)
        
        plateau.pile_action = PileAction.new(plateau, donnees.pile_action)
        plateau.malus_aide = donnees.malus_aide

        plateau_etat = donnees.plateau_etat
        
        (0..plateau.taille-1).each do |i|
            (0..plateau.taille-1).each do |j|
                p plateau.damier[i][j]  if plateau.damier[i][j].instance_of? CaseClic
                plateau.damier[i][j].etat = plateau_etat[i][j] if plateau.damier[i][j].instance_of? CaseClic
            end
        end

        jeu = Jeu.new(plateau: plateau, nom_joueur: donnees.nom_joueur, temps_de_jeu: donnees.temps_de_jeu)
        

        

        return jeu

    end

    #Suppression d'une partie
    #@note le chemin devra être valide 
    #@param le chemin de la sauvegarde a supprimer
    def Sauvegarde.supprimer_sauvegarde(chemin)
        if File.exist?(chemin)
             File.delete(chemin)
        else
             raise "Impossible de supprimer le fichier car il est inexistant, chemin : " + chemin
        end
    end
    
   # Chargement du template
    # @note le chemin devra être valide et le fichier correct et lisible
    # @param chemin le chemin à du template choisi
    # @return le damier avec et sans correction par hachage accessible via +:damier+ pour obtenir la matrice de cases et +:damierCorrect+ pour obtenir la matrice de correction indiquand la couleur que les cases doivent prendre
    # @return +nil+ est renvoyé si un problème est rencontré
    def Sauvegarde.charger_template(chemin)
        chemin_template = chemin

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
            #Retire les commentaires du traitement
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
            plateau = Plateau.new(matrice_plateau, matrice_solution, taille, niveau, chemin_template)
            Case.ajout_plateau(plateau)
            return plateau
            #return Jeu.new(plateau: plateau, nom_joueur: nom_joueur, temps_de_jeu: 0)
        end
    end
end