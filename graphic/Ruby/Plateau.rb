require 'rubygems'
require 'gtk3'

class Menus
	@nomJoueur
	@window
	@builder

	def initialize()
		@builder = Gtk::Builder.new
		@builder.add_from_file("Menu.glade")
		@window = @builder.get_object("fn_debut")
	end

	def afficheDemarrage()
		
		@window.show()
		
		bt_ok = @builder.get_object("bt_ok")
		#bt_ok.sensitive = FALSE
		bt_ok.signal_connect('clicked') { |_widget| onClickDemarrage() }
		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		Gtk.main()
	end

	def onClickDemarrage()
		ch_pseudo= @builder.get_object("ch_pseudo")
		if @nomJoueur != "" then
			@nomJoueur=ch_pseudo.text()
			puts @nomJoueur
			@window.destroy()
			afficheChoixMode()
		end
	end

	def afficheChoixMode
		@builder.add_from_file("Menu-titre.glade")
		@window = @builder.get_object("fn_menu")
		@window.show()
		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		bt_quit = @builder.get_object("bt_quit")
		bt_quit.signal_connect('clicked') { |_widget| Gtk.main_quit }
		bt_nv = @builder.get_object("bt_nv")
		bt_nv.signal_connect('clicked') { |_widget| afficheChoixPlateau() }
		bt_cs = @builder.get_object("bt_cs")
		bt_cs.signal_connect('clicked') { |_widget| afficheChoixSauvegarde() }
		Gtk.main()
	end
	

	def affichePlateau()
		@builder.add_from_file("EnJeu.glade")
		@window = @builder.get_object("fn_selec")
		@window.show()
		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		
		plateauBox = @builder.get_object("PlateauBox")
	end

	def afficheChoixPlateau()
		@window.destroy()
		@builder.add_from_file("Selection_niveau.glade")
		@window = @builder.get_object("fn_selec")
		@window.show()
		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		lab_pseu = @builder.get_object("lab_pseu")
		lab_pseu.set_text("Pseudo : " + @nomJoueur)
		bt_jouer = @builder.get_object("bt_jouer")
		bt_jouer.signal_connect('clicked') { |_widget| onClickMap()}

		box_fac = @builder.get_object("box_fac")
		box_fac_haut = @builder.get_object("box_fac_haut")
		box_fac_bas = @builder.get_object("box_fac_bas")
		files = Dir["../Niveaux/Facile/*.png"]

		i = 1
		 
		if files.length() <= 8 then
			for n in files do
			
				toggle = Gtk::ToggleButton.new()
				image = Gtk::Image.new(n) #voir si image ds toggle ?????????

				toggle.add(image)
				toggle.set_visible(TRUE)
				if(i <= 4) then 
					box_fac_haut.add(toggle)
				else
					box_fac_bas.add(toggle)
				end
				i += 1
			end
		end

		box_int = @builder.get_object("box_int")
		box_int_haut = @builder.get_object("box_int_haut")
		box_int_bas = @builder.get_object("box_int_bas")
		files = Dir["../Niveaux/Intermediaire/*.png"]

		i = 1
		
		 
		if files.length() <= 8 then
			for n in files do
			
				toggle = Gtk::ToggleButton.new()
				image = Gtk::Image.new(n) #voir si image ds toggle ?????????

				toggle.add(image)
				toggle.set_visible(TRUE)
				if(i <= 4) then 
					box_int_haut.add(toggle)
				else
					box_int_bas.add(toggle)
				end
				i += 1
			end
		end

		box_dif = @builder.get_object("box_fac")
		box_dif_haut = @builder.get_object("box_dif_haut")
		box_dif_bas = @builder.get_object("box_dif_bas")
		files = Dir["../Niveaux/Difficile/*.png"]

		i = 1
		
		 
		if files.length() <= 8 then
			for n in files do
			
				toggle = Gtk::ToggleButton.new()
				image = Gtk::Image.new(n) #voir si image ds toggle ?????????

				toggle.add(image)
				toggle.set_visible(TRUE)
				if(i <= 4) then 
					box_dif_haut.add(toggle)
				else
					box_dif_bas.add(toggle)
				end
				i += 1
			end
		end
 		@window.show_all  
		Gtk.main()
	end

	def afficheChoixSauvegarde()
		
	end

end

menu = Menus.new()
menu.afficheDemarrage()

