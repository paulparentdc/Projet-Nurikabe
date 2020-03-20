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
    def initialize(x,y)
        super(x,y)
        @etat = Etat.new
        @bouton.signal_connect('clicked'){@@plateau.on_click_jeu(x,y)}
    end


    def suivant
        @etat.suivant!
        self.actualises_toi
        
    end

    def precedent
        @etat.precedent!
        self.actualises_toi
    end

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

    def en_rouge
        @bouton.style_context.add_provider(@@CSS_BOUTON_ROUGE, Gtk::StyleProvider::PRIORITY_USER)
    end

    def en_gris
        @bouton.style_context.add_provider(@@CSS_BOUTON_GRIS, Gtk::StyleProvider::PRIORITY_USER)
    end


    def to_s
        return @etat.etat
    end
end