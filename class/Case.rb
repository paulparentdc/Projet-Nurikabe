require 'gtk3'
load 'Etat.rb'

class Case
    attr_reader :bouton

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

    @@CSS_BOUTON_ROUGE ||= Gtk::CssProvider.new
    @@CSS_BOUTON_ROUGE.load(data: <<-CSS)
                    button {
                    background-image: image(red);
                    }
                    CSS
    @@plateau

    @bouton
    @x
    @y

    def Case.ajout_plateau(plateau)
        @@plateau = plateau
    end

    def initialize(x,y)
        @x, @y = x, y
        @bouton = Gtk::Button.new()
        @bouton.style_context.add_provider(@@CSS_BOUTON_BLANC, Gtk::StyleProvider::PRIORITY_USER)
    end

    def to_s
        ' '
    end

    def changer_suivant
    end
    

    def changer
        
    end
end