# Case fixe avec un chiffre
# @attr_reader [Fixnum] chiffre - chiffre contenu dans la case
class CaseChiffre < Case
    @chiffre

    attr_reader :chiffre

	# Constructeur de CaseChiffre
	# @param x [Fixnum] la coordonnée x dans le plateau
	# @param y [Fixnum] la coordonnée y dans le platea
	# @param chiffre [Fixnul] le chiffre contenue dans la case
    def initialize(x, y, chiffre)
        super(x, y)
        @chiffre = chiffre
        @bouton.set_label(@chiffre.to_s)
    end

    # @!visibility private
    def to_s 
        "#{@chiffre}"
    end
end