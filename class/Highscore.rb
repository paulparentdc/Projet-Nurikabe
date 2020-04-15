# Cette classe permet de mémoriser les plus gros score des joueurs
# @attr_reader classement_facile [Array[String]] contient les meilleurs scores des grilles faciles
# @attr_reader classement_moyen [Array[String]] contient les meilleurs scores des grilles moyennes
# @attr_reader classement_difficile [Array[String]] contient les meilleurs scores des grilles difficiles
# @attr_reader chemin [String] le chemin d'accès au fichier de sauvegarde des highscores
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

	# Permet de rentrer un nouveau score s'il est supérieur à au moins un des 10 premiers
	# @note un tri est effectué lors de l'insertion
	# @return [void]
    def tri_insertion_score(nom_j, temp, classement)
          classement.push(nom_j + " " + temp.to_s)
          return classement.sort { |a, b|
            a.split(' ')[1].to_i <=> b.split(' ')[1].to_i
          }[0, 10]
    end

	# Appelle tri_insertion_score avec la bonne variable de classe, ici : facile
	# @see Highscore#tri_insertion_score
	# @return [void]
    def inserer_score_facile(nom_j, temp)
        @classement_facile = self.tri_insertion_score(nom_j, temp, @classement_facile)
    end

	# Appelle tri_insertion_score avec la bonne variable de classe, ici : moyen
	# @see Highscore#tri_insertion_score
	# @return [void]
    def inserer_score_moyen(nom_j, temp)
        @classement_moyen = self.tri_insertion_score(nom_j, temp, @classement_moyen)
    end

	# Appelle tri_insertion_score avec la bonne variable de classe, ici : difficile
	# @see Highscore#tri_insertion_score
	# @return [void]
    def inserer_score_difficile(nom_j, temp)
        @classement_difficile = self.tri_insertion_score(nom_j, temp, @classement_difficile)
    end

    # Créer un nouveau fichier highscore.score s'il n'existe pas
    # @note s'il existe, on l'ouvre en binaire
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
