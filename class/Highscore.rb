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
      if classement
           classement.push(nom_j + " " + temp.to_s)
      else
          for joueur in  classement do
                if(joueur[1] >= temp)
                    classement.insert(i, nom_j+ " " + temp.to_s)
                    return
                end
                i+=1
                return if(i>=TAILLE_MAX)
          end
          classement.push(nom_j + " " + temp.to_s)
      end
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
             mon_fichier = File::open(@chemin,"w+")
             mon_fichier.write(donnees)
             mon_fichier.close
        else
          fichier = File.open(@chemin, "r")
          p File::read(@chemin)
          highscore = Marshal::load(File::read(@chemin))
          fichier.close
	  
	
        end
        return highscore
    end
end
