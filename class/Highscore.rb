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

    def inserer_score(nom_j, temp, classement)
          i = 0
          classement.push(nom_j + " " + temp.to_s)
          #classement.sort { |a, b| b.split(' ')[1] <=> a.split(' ')[1] }
          classement = classement.sort { |a, b|
            puts a.split(' ')[1]
            puts b.split(' ')[1]
            b.split(' ')[1] <=> a.split(' ')[1]
          }
          puts classement
          puts "classement fac"
          puts @classement_facile
    end

    def inserer_score_facile(nom_j, temp)
        inserer_score(nom_j, temp, @classement_facile)
    end

    def inserer_score_moyen(nom_j, temp)
        inserer_score(nom_j, temp, @classement_moyen)
    end

    def inserer_score_difficile(nom_j, temp)
        inserer_score(nom_j, temp, @classement_difficile)
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
