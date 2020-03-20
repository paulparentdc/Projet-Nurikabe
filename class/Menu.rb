require 'rubygems'
require 'gtk3'
load 'Sauvegarde.rb'
load 'Highscore.rb'
class Menus
	@nom_joueur
	@window
	@builder
	@files_fac
	@files_int
	@files_dif

	def initialize()
		@builder = Gtk::Builder.new
	end

	def afficheDemarrage()
		if(@window != nil) then
			@window.destroy()
		end
		@builder.add_from_file("../Glade/Menu.glade")
		@window = @builder.get_object("fn_debut")
		bt_ok = @builder.get_object("bt_ok")
		#bt_ok.sensitive = FALSE
		bt_ok.signal_connect('clicked') { |_widget| onClickDemarrage() }
		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		@window.show()
		Gtk.main()
	end

	def onClickDemarrage()
		ch_pseudo= @builder.get_object("ch_pseudo")
		@nom_joueur=ch_pseudo.text().gsub('/',"")
		puts @nom_joueur
		afficheChoixMode()
	end

	def afficheChoixMode
		@window.destroy()
		@builder.add_from_file("../Glade/Menu-titre.glade")
		@window = @builder.get_object("fn_menu")
		@window.show()

		bouton_retour = @builder.get_object("btn_retour")
		bouton_retour.signal_connect('clicked'){ |_widget| afficheDemarrage()}

		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		bt_quit = @builder.get_object("bt_quit")
		bt_quit.signal_connect('clicked') { |_widget| Gtk.main_quit }
		bt_nv = @builder.get_object("bt_nv")
		bt_nv.signal_connect('clicked') { |_widget| afficheChoixPlateau() }
		bt_cs = @builder.get_object("bt_cs")
		bt_cs.signal_connect('clicked') { |_widget| afficheChoixSauvegarde() }

		stack_box_fac = @builder.get_object("stack_box_fac")
        stack_box_int = @builder.get_object("stack_box_int")
        stack_box_dif = @builder.get_object("stack_box_dif")

        getHighscore = Highscore.new()
        classement_fac = getHighscore.classement_facile

        puts "classement = "
        puts classement_fac
        if(classement_fac)
            for score in classement_fac

                    label_fac = Gtk::Label.new(score)
                  stack_box_fac.add(label_fac)
            end
      	end
		Gtk.main()
	end

	def afficheChoixPlateau()
		@window.destroy()
		@builder.add_from_file("../Glade/Selection_niveau.glade")
		@window = @builder.get_object("fn_selec")
		@window.show()

		bouton_retour = @builder.get_object("btn_retour")
		bouton_retour.signal_connect('clicked'){ |_widget| afficheChoixMode()}

		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		lab_pseu = @builder.get_object("lab_pseu")
		lab_pseu.set_text("Pseudo : " + @nom_joueur)

		box_fac_haut = @builder.get_object("box_fac_haut")
		box_fac_bas = @builder.get_object("box_fac_bas")

		i = 0
		files_fac = Dir["../data/template/Facile/*.png"]

		if files_fac.length() <= 8 then
			toggles_fac = []
			for n in files_fac do

				toggles_fac[i] = Gtk::Button.new()
				image = Gtk::Image.new(n)
				toggles_fac[i].signal_connect('clicked') { |_widget|  btn_to_img(toggles_fac, files_fac,_widget) }
				toggles_fac[i].add(image)
				toggles_fac[i].set_visible(TRUE)
				if(i <= 3) then
					box_fac_haut.add(toggles_fac[i])
				else
					box_fac_bas.add(toggles_fac[i])
				end
				i += 1
			end
		end

		box_int_haut = @builder.get_object("box_int_haut")
		box_int_bas = @builder.get_object("box_int_bas")

		i = 0
		files_int = Dir["../data/template/Intermediaire/*.png"]

		if files_int.length() <= 8 then
			toggles_int = []
			for n in files_int do

				toggles_int[i] = Gtk::Button.new()
				image = Gtk::Image.new(n)
				toggles_int[i].signal_connect('clicked') { |_widget| btn_to_img(toggles_int, files_int,_widget) }
				toggles_int[i].add(image)
				toggles_int[i].set_visible(TRUE)
				if(i <= 3) then
					box_int_haut.add(toggles_int[i])
				else
					box_int_bas.add(toggles_int[i])
				end
				i += 1
			end
		end

		box_dif_haut = @builder.get_object("box_dif_haut")
		box_dif_bas = @builder.get_object("box_dif_bas")

		i = 0

		files_dif = Dir["../data/template/Difficile/*.png"]

		if files_dif.length() <= 8 then
			toggles_dif = []
			for n in files_dif do

				toggles_dif[i] = Gtk::Button.new()
				image = Gtk::Image.new(n)
				toggles_dif[i].signal_connect('clicked') { |_widget| btn_to_img(toggles_dif, files_dif, _widget)}
				toggles_dif[i].add(image)
				toggles_dif[i].set_visible(TRUE)
				if(i <= 3) then
					box_dif_haut.add(toggles_dif[i])
				else
					box_dif_bas.add(toggles_dif[i])
				end
				i += 1
			end
		end
 		@window.show_all
		Gtk.main()
	end

	def afficheChoixSauvegarde()
		@window.destroy()
		@builder.add_from_file("../Glade/Charger_sauvegarde.glade")
		@window = @builder.get_object("fn_save")

		bouton_retour = @builder.get_object("btn_retour")
		bouton_retour.signal_connect('clicked'){ |_widget| afficheChoixMode()}

		@window.signal_connect('destroy') { |_widget| Gtk.main_quit }
		scrl = @builder.get_object("scrl_save")
		@window.show()
		file = Dir["../data/save/"+@nom_joueur+"/*.snurikabe"]
		box_save = @builder.get_object("box_liste_save")
		box_save.margin = 20

		bouton_charger = []
		bouton_supprimer = []
		i = 0
		for n in file do
			hbox = Gtk::Box.new(:horizontal, 0)
			hbox.margin = 20
			nom_save = n.split("/")
			label = Gtk::Label.new("Sauvegarde du " + nom_save[4].split(".")[0])
			bouton_charger[i] = Gtk::Button.new(:label => "Charger")
			bouton_supprimer[i] = Gtk::Button.new(:label => "Supprimer")
			bouton_charger[i].signal_connect('clicked'){|_widget| charger_save(bouton_charger, file, _widget)}
			bouton_supprimer[i].signal_connect('clicked'){|_widget| supprimer_save(bouton_supprimer, file, _widget)}
			hbox.pack_start(label,:expand => true, :fill => false, :padding => 0)
			hbox.add(bouton_charger[i])
			hbox.add(bouton_supprimer[i])
			box_save.add(hbox)
			i+=1
		end
		@window.show_all
		Gtk.main()
	end

	def charger_save(boutons, files, btn)
		j = 0
		for b in boutons do
			if(b == btn)
				@window.destroy()
				jeu = Sauvegarde.charger_sauvegarde(files[j])
				jeu.affiche_toi()
			end
		end
	end

	def supprimer_save(boutons, files, btn)
		j = 0
		for b in boutons do
			if(b == btn)
				File.delete(files[j]) if File.exist?(files[j])
			end
		end
		afficheChoixSauvegarde()
	end

	def btn_to_img(toggles, files, btn)
		j = 0
		for b in toggles do
			if(btn == b)
				 executer_map(files[j])
			end
			j+=1
		end
	end

	def executer_map(file_image)
		file_niveau = file_image[0..file_image.length-4]
		file_niveau +="nurikabe"

		@window.destroy()
		jeu = Jeu.new(plateau: Sauvegarde.charger_template(file_niveau), nom_joueur: @nom_joueur, temps_de_jeu: 0)
		puts jeu.affiche_toi

	end

end

menu = Menus.new()
menu.afficheDemarrage()
