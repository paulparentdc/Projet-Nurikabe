class Highscore

  attr_reader :classement_facile, :classement_moyen, :classement_difficile
  @@classement_facile
  @@classement_moyen
  @@classement_difficile
  TAILLE_MAX = 10

    def initialize()
    end

    inserer_score(nom_j, temp, classement)
      i = 0
      if classement
           classement.push([nom_j, temp])
      else
          for joueur in  classement do
                if(joueur[1] >= temp)
                    classement.insert(i, [nom_j, temp])
                    return
                end
                i+=1
                return if(i>=TAILLE_MAX)
          end
          classement.push([nom_j, temp])
      end
    end

    inserer_score_facile(nom_j, temp)
        inserer_score(nom_j, temp, @@classement_facile)
    end

    inserer_score_moyen(nom_j, temp)
        inserer_score(nom_j, temp, @@classement_moyen)
    end

    inserer_score_difficile(nom_j, temp)
        inserer_score(nom_j, temp, @@classement_difficile)
    end
end
