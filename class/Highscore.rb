#Cette classe permet de mémoriser les plus gros score des joueurs
#@param classement_facile [Array[String]] contient les meilleurs scores des grilles faciles
#@param classement_moyen [Array[String]] contient les meilleurs scores des grilles moyennes
#@param classement_difficile [Array[String]] contient les meilleurs scores des grilles difficiles
#@param chemin [String] le chemin d'accès au fichier de sauvegarde des highscores
class Highscore

  attr_reader :classement_facile, :classement_moyen, :classement_difficile, :chemin

  @classement_facile
  @classement_moyen
  @classement_difficile
  @chemin = "../data/highscore.score"
  @TAILLE_MAX ||= 10

    def initialize()
        @classement_facile = []
        @classement_moyen = []
        @classement_difficile = []
    end

    #permet de rentrer un nouveau score s'il est supérieur à au moins un des 10 premiers
    def tri_insertion_score(nom_j, temp, classement)
          classement.push(nom_j + " " + temp.to_s)
          return classement.sort { |a, b|
            a.split(' ')[1] <=> b.split(' ')[1]
          }[0, 10]

          temphighscore = Highscore.recuperer_ds_fichier
          Sauvegarde.sauvegarde_highscore(temphighscore)
    end

    #appelle tri_insertion_score avec la bonne variable de classe, ici : facile
    def inserer_score_facile(nom_j, temp)
        @classement_facile = self.tri_insertion_score(nom_j, temp, @classement_facile)
    end

    #appelle tri_insertion_score avec la bonne variable de classe, ici : moyen
    def inserer_score_moyen(nom_j, temp)
        @classement_moyen = self.tri_insertion_score(nom_j, temp, @classement_moyen)
    end

    #appelle tri_insertion_score avec la bonne variable de classe, ici : difficile
    def inserer_score_difficile(nom_j, temp)
        @classement_difficile = self.tri_insertion_score(nom_j, temp, @classement_difficile)
    end

    #créer un nouveau fichier highscore.score s'il n'existe pas
    #s'il existe, l'ouvre en binaire
    def Highscore.recuperer_ds_fichier
        if !File.exist?(@chemin)
             highscore = Highscore.new
             donnees = Marshal::dump(highscore)
             mon_fichier = File::open(@chemin,"wb")
             mon_fichier.write(donnees)
             mon_fichier.close
        else
          fichier = File.open(@chemin, "rb")
          highscore = Marshal::load(File::binread(@chemin))
          fichier.close
        end
        return highscore
    end
end
