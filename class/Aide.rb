class Aide

   def Aide.tester_tout(un_plateau)

        if Aide.tester_un(un_plateau)
            return 1
        end

        if Aide.tester_espace(un_plateau)
            return 2
        end

        if Aide.tester_diagonale(un_plateau)
            return 3
        end

        if Aide.tester_blanc_isole(un_plateau)
            return 4
        end

        return 0

   end

   def Aide.tester_un(un_plateau)
        for i in (0..un_plateau.taille-1)
            for j in (0..un_plateau.taille-1)

                if case_1?(un_plateau.donne_case(i,j))

                    if un_plateau.coord_valides?(i+1,j)

                        if case_blanche?(un_plateau.donne_case(i+1,j))
                            return true
                        end
                    end


                    if un_plateau.coord_valides?(i,j+1)
                        if case_blanche?(un_plateau.donne_case(i,j+1))
                            return true
                        end
                    end


                    if un_plateau.coord_valides?(i,j-1)

                        if case_blanche?(un_plateau.donne_case(i,j-1))
                            return true
                        end
                    end


                    if un_plateau.coord_valides?(i-1,j)
                        if case_blanche?(un_plateau.donne_case(i-1,j))
                            return true
                        end
                    end


                end
            end
        end
        return false #Cas où aucun 1 seul n'a été trouvé
   end

   def Aide.tester_espace(un_plateau)
        for i in (0..un_plateau.taille-1)
            for j in (0..un_plateau.taille-1)

                if case_chiffre?(un_plateau.donne_case(i,j))
                    if un_plateau.coord_valides?(i+2,j)
                        if case_chiffre?(un_plateau.donne_case(i+2,j)) && case_blanche?(un_plateau.donne_case(i+1,j))
                            return true
                        end
                    end


                    if un_plateau.coord_valides?(i,j+2)
                        if case_chiffre?(un_plateau.donne_case(i,j+2)) && case_blanche?(un_plateau.donne_case(i,j+1))
                            return true
                        end
                    end


                    if un_plateau.coord_valides?(i,j-2)
                        if case_chiffre?(un_plateau.donne_case(i,j-2)) && case_blanche?(un_plateau.donne_case(i,j-1))
                            return true
                        end
                    end


                    if un_plateau.coord_valides?(i-2,j)
                        if case_chiffre?(un_plateau.donne_case(i-2,j)) && case_blanche?(un_plateau.donne_case(i-1,j))
                            return true
                        end
                    end
                end
            end
        end
        return false #Cas où aucun espace n'a été trouvé entre 2 cases chiffre
   end

    def Aide.tester_diagonale(un_plateau)
        for i in (0..un_plateau.taille-1)
            for j in (0..un_plateau.taille-1)

                if case_chiffre?(un_plateau.donne_case(i,j))

                    if un_plateau.coord_valides?(i+1,j+1)
                        if case_chiffre?(un_plateau.donne_case(i+1,j+1))
                            if !case_noire?(un_plateau.donne_case(i+1,j)) || !case_noire?(un_plateau.donne_case(i,j+1))
                                return true
                            end
                        end
                    end


                    if un_plateau.coord_valides?(i-1,j-1)
                        if case_chiffre?(un_plateau.donne_case(i-1,j-1))
                            if !case_noire?(un_plateau.donne_case(i-1,j))  || !case_noire?(un_plateau.donne_case(i,j-1))
                                return true
                            end
                        end
                    end


                    if un_plateau.coord_valides?(i+1,j-1)
                        if case_chiffre?(un_plateau.donne_case(i+1,j-1))
                            if !case_noire?(un_plateau.donne_case(i+1,j))  || !case_noire?(un_plateau.donne_case(i,j-1))
                                return true
                            end
                        end
                    end


                    if un_plateau.coord_valides?(i-1,j+1)
                        if case_chiffre?(un_plateau.donne_case(i-1,j+1))
                            if !case_noire?(un_plateau.donne_case(i-1,j))  || !case_noire?(un_plateau.donne_case(i,j+1))
                                return true
                            end
                        end
                    end
                end
            end
        end
        return false #Cas où on n'a pas trouvé de case vide en diagonale de 2 cases chiffre
    end

    def Aide.tester_blanc_isole(un_plateau)
        for i in (0..un_plateau.taille)
            for j in (0..un_plateau.taille)

                if case_blanche?(un_plateau.donne_case(i,j))

                    if !un_plateau.coord_valides?(i+1,j) || case_noire?(un_plateau.donne_case(i+1,j))
                        if !un_plateau.coord_valides?(i-1,j) || case_noire?(un_plateau.donne_case(i-1,j))
                            if !un_plateau.coord_valides?(i,j+1) || case_noire?(un_plateau.donne_case(i,j+1))
                                if !un_plateau.coord_valides?(i,j-1) || case_noire?(un_plateau.donne_case(i,j-1))
                                    return true
                                end
                            end
                        end
                    end

                end
            end
        end
        return false #Cas où la case n'est pas isolée
    end

 

    #Fonctions de test sur les cases
    def Aide.case_chiffre?(une_case)
        return uneCase.to_s.chr != 'n' && uneCase.to_s.chr != 'b'
    end

    def Aide.case_noire?(une_case)
        return uneCase.to_s.chr == 'n'
    end

    def Aide.case_blanche?(une_case)
        return uneCase.to_s.chr == 'b'
    end

    def Aide.case_1?(une_case)
        return uneCase.to_s.chr == '1'
    end



end
