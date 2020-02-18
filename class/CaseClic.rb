class CaseClic < Case
    @etat
    def initialize(x,y)
        super(x,y)
        @etat = Etat.new
        @bouton.signal_connect('clicked'){@@plateau.onClickJeu(x,y)}
    end


    def suivant
        @etat.suivant!
        puts @etat.etat
        self.actualisesToi
        
    end


    def precedent
        @etat.precedent!
        self.actualisesToi
    end

    def actualisesToi
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

end