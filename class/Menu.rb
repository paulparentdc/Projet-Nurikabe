require 'rubygems'
require 'gtk3'
load 'Sauvegarde.rb'
load 'Highscore.rb'
#Cette classe gère tout l'aspect graphique du début de l'application, elle utilise le DP singleton
#@param nom_joueur [String] le nom du joueur
#@param window [GTK::Window] la fenetre actuelle
#@@param builder [GTK::Builder] le constructeur contenant toutes les fenetres .glade
#@@param menu [Menu] l'instance de la classe Menu

class Menu
	@nom_joueur
	@window
	@@builder ||= Gtk::Builder.new
	@@menu ||= Menu.new

	#retourne l'instance du Menu
	def Menu.getInstance()
		return @@menu
	end

	#Gère la première page de l'application
	def afficheDemarrage()
		if(@window != nil) then
				@window.hide()
		end
		@@builder.add_from_file("../Glade/Menu.glade") #récupère Menu.glade
		#déclaration de toute la page et des boutons
		@window = @@builder.get_object("fn_debut")
		bt_ok = @@builder.get_object("bt_ok")
		bt_ok.signal_connect('clicked') { |_widget| onClickDemarrage() }
		@window.signal_connect("key-press-event") do |w, e|
			onClickDemarrage() if Gdk::Keyval.to_name(e.keyval) == "Return"
		end
		@window.signal_connect('destroy') { |_widget| exit!() }
		@window.show_all()
		Gtk.main() #exécution du GTK
	end

	def onClickDemarrage()
		ch_pseudo= @@builder.get_object("ch_pseudo")
		@nom_joueur=ch_pseudo.text().gsub('/',"")
		afficheChoixMode(nil)
	end


	def afficheChoixMode(nom_j)
		if(nom_j != nil)
				@nom_joueur = nom_j
		end
		if(@window != nil)
				@window.hide()
		end
		@@builder = Gtk::Builder.new
		@@builder.add_from_file("../Glade/Menu-titre.glade")
		#déclaration de toute la page et des boutons
		@window = @@builder.get_object("fn_menu")
		@window.signal_connect('destroy') { |_widget| exit!() }
		bt_quit = @@builder.get_object("bt_quit")
		bt_quit.signal_connect('clicked') { |_widget| exit!() }

		bt_nv = @@builder.get_object("bt_nv")
		bt_nv.signal_connect('clicked') { |_widget| afficheChoixPlateau() }

		bt_cs = @@builder.get_object("bt_cs")
		bt_cs.signal_connect('clicked') { |_widget| afficheChoixSauvegarde() }
		stack_box_fac = @@builder.get_object("stack_box_fac")
		stack_box_int = @@builder.get_object("stack_box_int")
		stack_box_dif = @@builder.get_object("stack_box_dif")

		#récupèration des highscores grâce à la classe Highscore
		getHighscore = Highscore.recuperer_ds_fichier
		Sauvegarde.sauvegarde_highscore(getHighscore)
		getHighscore = Highscore.recuperer_ds_fichier
    classement_fac = getHighscore.classement_facile
		classement_int = getHighscore.classement_moyen
		classement_dif = getHighscore.classement_difficile

		#génération dynamique des classement
    if(classement_fac)
        for score in classement_fac do
              label_fac = Gtk::Label.new(score)
              stack_box_fac.add(label_fac)
        end
    end
		if(classement_int)
        for score in classement_int do
              label_int = Gtk::Label.new(score)
              stack_box_int.add(label_int)
        end
    end
		if(classement_dif)
        for score in classement_dif do
              label_dif = Gtk::Label.new(score)
              stack_box_dif.add(label_dif)
        end
    end
		@window.show_all
		Gtk.main()
	end

	def afficheChoixPlateau()

		if(@window != nil)
			@window.hide()
		end

		@@builder.add_from_file("../Glade/Selection_niveau.glade")
		#déclaration de toute la page et des boutons
		@window = @@builder.get_object("fn_selec")
		bouton_retour = @@builder.get_object("btn_retour")
		bouton_retour.signal_connect('clicked'){ |_widget| afficheChoixMode(nil)}
		@window.signal_connect('destroy') { |_widget| exit!() }
		lab_pseu = @@builder.get_object("lab_pseu")
		lab_pseu.set_text("Pseudo : " + @nom_joueur)

		box_fac_haut = @@builder.get_object("box_fac_haut")
		box_fac_bas = @@builder.get_object("box_fac_bas")

		i = 0
		files_fac = Dir["../data/template/Facile/*.png"]

		#génération des images cliquables de chaques maps faciles disponibles
		if files_fac.length() <= 8 then
			toggles_fac = []
			for n in files_fac do

				toggles_fac[i] = Gtk::Button.new()
				image = Gtk::Image.new(:file => n)
				toggles_fac[i].signal_connect('clicked') { |_widget|  btn_to_img(toggles_fac, files_fac,_widget) }
				toggles_fac[i].add(image)
				if(i <= 3) then
					box_fac_haut.add(toggles_fac[i])
				else
					box_fac_bas.add(toggles_fac[i])
				end
				i += 1
			end
		end

		box_int_haut = @@builder.get_object("box_int_haut")
		box_int_bas = @@builder.get_object("box_int_bas")

		i = 0
		files_int = Dir["../data/template/Intermediaire/*.png"]

		#génération des images cliquables de chaques maps intermédiaires disponibles
		if files_int.length() <= 8 then
			toggles_int = []
			for n in files_int do
				toggles_int[i] = Gtk::Button.new()
				image = Gtk::Image.new(:file => n)
				toggles_int[i].signal_connect('clicked') { |_widget| btn_to_img(toggles_int, files_int,_widget) }
				toggles_int[i].add(image)
				if(i <= 3) then
					box_int_haut.add(toggles_int[i])
				else
					box_int_bas.add(toggles_int[i])
				end
				i += 1
			end
		end

		box_dif_haut = @@builder.get_object("box_dif_haut")
		box_dif_bas = @@builder.get_object("box_dif_bas")

		i = 0

		files_dif = Dir["../data/template/Difficile/*.png"]

		#génération des images cliquables de chaques maps difficiles disponibles
		if files_dif.length() <= 8 then
			toggles_dif = []
			for n in files_dif do

				toggles_dif[i] = Gtk::Button.new()
				image = Gtk::Image.new(:file => n)
				toggles_dif[i].signal_connect('clicked') { |_widget| btn_to_img(toggles_dif, files_dif, _widget)}
				toggles_dif[i].add(image)
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

	#affiche toutes les sauvegardes du joueur *nom_joueur*
	#lui permet de charger ou de supprimer chaque sauvegarde
	def afficheChoixSauvegarde()
		if(@window != nil)
				@window.hide()
		end
		@@builder.add_from_file("../Glade/Charger_sauvegarde.glade")
		#déclaration de toute la page et des boutons
		@window = @@builder.get_object("fn_save")

		bouton_retour = @@builder.get_object("btn_retour")
		bouton_retour.signal_connect('clicked'){ |_widget| afficheChoixMode(nil)}

		@window.signal_connect('destroy') { |_widget| exit!() }
		scrl = @@builder.get_object("scrl_save")
		file = Dir["../data/save/"+@nom_joueur+"/*.snurikabe"]
		box_save = @@builder.get_object("box_liste_save")
		box_save.margin = 20
		bouton_charger = []
		bouton_supprimer = []
		i = 0
		#affichage si le joueur n'a aucune sauvegarde
		if(file.length == 0)
					label = Gtk::Label.new("Vous n'avez aucune sauvegarde.")
					box_save.add(label)
		else
			#créer une box contenant deux boutons, charger et supprimer, pour chaque sauvegarde
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
		end
		@window.show_all
		Gtk.main()
	end

	#permet de charger une sauvegarde
	def charger_save(boutons, files, btn)
		j = 0
		for b in boutons do
			if(b == btn)
				@window.hide()
				jeu = Sauvegarde.charger_sauvegarde(files[j])
				jeu.affiche_toi()
			end
		end
	end

	#permet de supprimer une sauvegarde
	def supprimer_save(boutons, files, btn)
		j = 0
		for b in boutons do
			if(b == btn)
				File.delete(files[j]) if File.exist?(files[j])
			end
		end
		afficheChoixSauvegarde()
	end

	#permet de récupérer la map correspondante au bouton sélectionner
	def btn_to_img(toggles, files, btn)
		j = 0
		for b in toggles do
			if(btn == b)
				 executer_map(files[j])
			end
			j+=1
		end
	end

	#executer la map correspondante
	def executer_map(file_image)
		file_niveau = file_image[0..file_image.length-4]
		file_niveau +="nurikabe"

		@window.hide()
		jeu = Jeu.new(plateau: Sauvegarde.charger_template(file_niveau), nom_joueur: @nom_joueur, temps_de_jeu: 0)
		puts jeu.affiche_toi

	end

end

menu = Menu.new()
menu.afficheDemarrage()
