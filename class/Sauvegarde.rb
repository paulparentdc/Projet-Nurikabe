load 'Case.rb'
load 'CaseClic.rb'
load 'CaseChiffre.rb'
load 'Plateau.rb'
load 'Jeu.rb'
load 'PileAction.rb'
load 'Etat.rb'

require 'fileutils'

# Ensemble de méthodes permettant la gestion des données sauvegardé
class Sauvegarde
    
    # Classe qui permet de sauvegarder le jeu sans les boutons
    # @private
    # @note Nous ne prennons que les données essentiels pour la sérialisation
	# @attr_reader [Array<Etat>] plateau_etat l'état de chaque cases du plateau
	# @attr_reader [Array<Action>] pile_action pile d'actions effectué durant la partie
    # @attr_reader [Fixnum] malus_aide malus du jeu contracté
    # @attr_reader [String] chemin_template chemin du template de jeu utilisé pour la partie
    # @attr_reader [String] nom_joueur le nom du joueur
    # @attr_reader [Fixnum] temps_de_jeu le temps de jeu
    class DonneesJeu
        attr_reader :plateau_etat, :pile_action, :malus_aide, :nom_joueur, :temps_de_jeu, :chemin_template

        # Construction de la base de donnée du jeu nécessaire pour la sauvegarde
        # @param jeu [Jeu] Le jeu à sauvegarder
        def initialize(jeu)
            @nom_joueur, @temps_de_jeu = jeu.nom_joueur, jeu.temps_de_jeu
            @pile_action = jeu.plateau.pile_action.serialiser
            @malus_aide = jeu.plateau.malus_aide
            @chemin_template = jeu.plateau.chemin_template
            @plateau_etat = jeu.plateau.get_plateau_etat
        end
    end

    # Chargement d'une partie
    # @param jeu [Jeu] Le jeu a sauvegarder
    # @return [void]
    def Sauvegarde.creer_sauvegarde(jeu)

        jeu_filtree = DonneesJeu.new(jeu)
        donnees = Marshal::dump(jeu_filtree)

        chemin_de_base = "../data/save/"+jeu.nom_joueur+"/"+Time.new.strftime("%d-%m-%Y   %Hh%Mm%Ss")+".snurikabe"

        # creation d'un dossier par joueur, qui contiendra toutes les sauvegardes de ce dernier
        dirname=File::dirname(chemin_de_base)
        unless File.directory?(dirname)
            FileUtils.mkdir_p(dirname)
        end

        # Sauvegarde dans un fichier
        mon_fichier = File::open(chemin_de_base,"w+")
        mon_fichier.write(donnees)
        mon_fichier.close

        builderPopup = Gtk::Builder.new
        builderPopup.add_from_file("../Glade/Popup.glade")
        windowPopup = builderPopup.get_object("fn_popup")
        btn_ok = builderPopup.get_object("btn_ok")
        btn_ok.signal_connect('clicked') {windowPopup.destroy()}
        windowPopup.show_all()
    end


    # Chargement d'une partie
    # @note le chemin devra être valide
    # @param chemin_de_base [String] le chemin de la sauvegarde
    # @return [Jeu] le jeu correspondant au chemin
    def Sauvegarde.charger_sauvegarde(chemin_de_base)

        if !File.exist?(chemin_de_base)
            raise "Fichier inexistant"
            return
        end

		# Chargement des donnees de sauvegarde
        fichier=File.open(chemin_de_base,"r")
        donnees=Marshal::load(File::read(chemin_de_base))
        fichier.close

		# Initialisation du plateau
        plateau = Sauvegarde.charger_template(donnees.chemin_template)

        plateau.pile_action = PileAction.new(plateau, donnees.pile_action)
        plateau.malus_aide = donnees.malus_aide

        plateau_etat = donnees.plateau_etat

        (0..plateau.taille-1).each do |i|
            (0..plateau.taille-1).each do |j|
                if plateau.damier[i][j].instance_of? CaseClic
                    plateau.damier[i][j].etat = plateau_etat[i][j]
                    plateau.damier[i][j].actualises_toi
                end
            end
        end

		# Initialisation du jeu
        jeu = Jeu.new(plateau: plateau, nom_joueur: donnees.nom_joueur, temps_de_jeu: donnees.temps_de_jeu)

        return jeu

    end

    # Suppression d'une partie
    # @note le chemin devra être valide
    # @param chemin le chemin de la sauvegarde a supprimer
    # @raise la sauvegarde n'existe pas
    def Sauvegarde.supprimer_sauvegarde(chemin)
        if File.exist?(chemin)
             File.delete(chemin)
        else
             raise "Impossible de supprimer le fichier car il est inexistant, chemin : " + chemin
        end
    end

    # Chargement du template
    # @note le chemin devra être valide et le fichier correct et lisible
    # @param chemin [String] le chemin à du template choisi
    # @return [Plateau, nil] le plateau avec et sans correction par hachage accessible via +:damier+ pour obtenir la matrice de cases et +:damierCorrect+ pour obtenir la matrice de correction indiquand la couleur que les cases doivent avoir pour gagner
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
                        (temp = x.to_i) == 0 ? CaseClic.new(compteur,i) : CaseChiffre.new(compteur,i, temp)

                    end)
                    compteur+=1
                else
                    #Fichier invalide
                    return nil
                end
            end
        end

        # Verifier que tout a été initialisé
        if niveau == nil && taille == nil && compteur != taille
            return nil
        else
            plateau = Plateau.new(matrice_plateau, matrice_solution, taille, niveau, chemin_template)
            Case.ajout_plateau(plateau)
            return plateau
        end
    end

    # Sauvegarde de l'highscore
    # @param highscore [Highscore] l'objet highscore à sauvegarder
    # @return [void]
    def Sauvegarde.sauvegarde_highscore(highscore)
        donnees = Marshal::dump(highscore)
        chemin_de_base = "../data/highscore.score"
        mon_fichier = File::open(chemin_de_base,"wb")
        mon_fichier.write(donnees)
        mon_fichier.close
    end

end
