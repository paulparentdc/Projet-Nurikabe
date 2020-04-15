# Case clicable par le joueur
# @attr CSS_BOUTON_ROUGE [CssProvider] VARIABLE DE CLASSE : code CSS d'un bouton rouge
# @attr CSS_BOUTON_GRIS [CssProvider] VARIABLE DE CLASSE : code CSS d'un bouton gris 
# @attr etat [Etat] état de la case
class CaseClic < Case
    attr_accessor :etat

    @@CSS_BOUTON_ROUGE ||= Gtk::CssProvider.new
    @@CSS_BOUTON_ROUGE.load(data: <<-CSS)
                    button {
                    background-image: image(red);
                    }
                    CSS

    @@CSS_BOUTON_GRIS ||= Gtk::CssProvider.new
    @@CSS_BOUTON_GRIS.load(data: <<-CSS)
                    button {
                    background-image: image(grey);
                    }
                    CSS
    @etat
	
	# Constructeur de CaseClic
	# @param x [Fixnum] la coordonnée x dans le plateau
	# @param y [Fixnum] la coordonnée y dans le plateau
    def initialize(x,y)
        super(x,y)
        @etat = Etat.new
        @bouton.signal_connect('clicked'){@@plateau.on_click_jeu(x,y)}
    end

	# Passe la case à l'état suivant dans l'ordre
	# @return [void]
    def suivant
        @etat.suivant!
        self.actualises_toi
        
    end

	# Passe la case à l'état précédent dans l'ordre
	# @return [void]
    def precedent
        @etat.precedent!
        self.actualises_toi
    end

	# Actualise le style du bouton de la case en fonction de son état
	# @return [void]
    def actualises_toi
        case(@etat.etat)
        when Etat::BLANC
            css = @@CSS_BOUTON_BLANC
            @bouton.set_label('')
        when Etat::NOIR
            css = @@CSS_BOUTON_NOIR
            @bouton.set_label('')
        when Etat::POINT
            css = @@CSS_BOUTON_BLANC
            @bouton.set_label('•')
        else
            css = @@CSS_BOUTON_NOIR
        end
        @bouton.style_context.add_provider(css, Gtk::StyleProvider::PRIORITY_USER)
    end

	# Passe la couleur du bouton en rouge
	# @return [void]
    def en_rouge
        @bouton.style_context.add_provider(@@CSS_BOUTON_ROUGE, Gtk::StyleProvider::PRIORITY_USER)
    end

	# Passe la couleur du bouton en gris
	# @return [void]
    def en_gris
        @bouton.style_context.add_provider(@@CSS_BOUTON_GRIS, Gtk::StyleProvider::PRIORITY_USER)
    end

    # @!visibility private
    def to_s
        return @etat.etat
    end
end