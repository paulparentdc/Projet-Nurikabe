require 'gtk3'
load 'Etat.rb'
# Classe mère qui sert pour créer CaseChiffre et CaseClic
# @attr_reader bouton [Button] bouton lié à la case
# @attr_reader x [Fixnum] coordonnée x de notre case
# @attr_reader y [Fixnum] coordonnée y de notre case
# @attr plateau [Plateau] VARIABLE DE CLASSE : plateau dans lequel est la case
# @attr CSS_BOUTON_NOIR [CssProvider] VARIABLE DE CLASSE : code CSS d'un bouton noir
# @attr CSS_BOUTON_BLANC [CssProvider] VARIABLE DE CLASSE : code CSS d'un bouton blanc
class Case
    attr_reader :bouton, :x, :y

    @@CSS_BOUTON_NOIR ||= Gtk::CssProvider.new
    @@CSS_BOUTON_NOIR.load(data: <<-CSS)
                    button {
                    background-image: image(black);
                    }
                    CSS

    @@CSS_BOUTON_BLANC ||= Gtk::CssProvider.new
    @@CSS_BOUTON_BLANC.load(data: <<-CSS)
                    button {
                    background-image: image(white);
                    }
                    CSS

    @@plateau

    @bouton
    @x
    @y
    
    # Permet de renseigner le plateau de la case
    # @param le plateau de jeu
    def Case.ajout_plateau(plateau)
        @@plateau = plateau
    end

	# Constructeur de Case
	# @param x [Fixnum] la coordonnée x dans le plateau
	# @param y [Fixnum] la coordonnée y dans le plateau
    def initialize(x,y)
        @x, @y = x, y
        @bouton = Gtk::Button.new()
        @bouton.style_context.add_provider(@@CSS_BOUTON_BLANC, Gtk::StyleProvider::PRIORITY_USER)
    end

    # @!visibility private
    def to_s
        ' '
    end

end
