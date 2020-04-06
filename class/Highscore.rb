class Highscore

  attr_reader :classement_facile, :classement_moyen, :classement_difficile, :chemin

  @classement_facile
  @classement_moyen
  @classement_difficile
  @chemin = "../data/highscore.score"
  TAILLE_MAX = 10

    def initialize()
        @classement_facile = []
        @classement_moyen = []
        @classement_difficile = []
    end

    def tri_insertion_score(nom_j, temp, classement)
          classement.push(nom_j + " " + temp.to_s)
          return classement.sort { |a, b|
            a.split(' ')[1] <=> b.split(' ')[1]
          }[0, 10]

          temphighscore = Highscore.recuperer_ds_fichier
          Sauvegarde.sauvegarde_highscore(temphighscore)
    end

    def inserer_score_facile(nom_j, temp)
        @classement_facile = self.tri_insertion_score(nom_j, temp, @classement_facile)
    end

    def inserer_score_moyen(nom_j, temp)
        @classement_moyen = self.tri_insertion_score(nom_j, temp, @classement_moyen)
    end

    def inserer_score_difficile(nom_j, temp)
        @classement_difficile = self.tri_insertion_score(nom_j, temp, @classement_difficile)
    end

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
