<<<<<<< HEAD
###### Documentation Ruby avec Yard : 
    Instalation :
    ------

    gem install yard

    Documation YARD :
    ------
    https://gist.github.com/chetan/1827484
    https://rubydoc.info/gems/yard/file/docs/Tags.md#List_of_Available_Tags

###### Convention de nommage :
    Classe : CamelCase
    Méthode + variables : avec_underscore


ajout :
- @malus_aide sur plateau
- thread timer avec appel de lancer_timer
- deplacement affiche_toi dans jeu

---

malus (à changer probablement):
demande de verif : 10s de pénalité si y'a au moins une faute + 5*(le nombre de faute) si on décide de les afficher

---
=======
# Lancement du jeu : 

ruby ./class/Menu.rb

# Créer des templates:
Bon à savoir :
    On a le droit à 8 templates par difficulté
    Le plateau devra être carré

Voici un exemple de template : 

#Difficulté
Difficile
#Taille
9
#Plateau
b 5 n n 3 b n b b
b n 8 n b n n 5 b
b n b n n n 2 n b
b n b b b n b n n
n n n n b n n n b
n b b n b n b n b
n n 3 n b n b n b
n 3 n n n n 3 n b
n b b n 1 n n 6 b

-> Pour créer un nouveau template on notera 'b' une case blanc, 'n' case noire et un chiffre

L'utilisateur ne verra pas les cases noires. Les cases noire permettront à la verification de la grille et sa correction.

Le template devra être rédigé dans un fichier avec l'extension .nurikabe et si on on le souhaite on pourra ajouter une image .png pour le voir.
Pour se faire, il faudra que les 2 éléments aient le même nom, par exemple
niveau1.nurikabe pour le template et niveau1.png pour l'image.
