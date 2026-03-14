The Wave — Plateforme de streaming musical
-----------------------------------------

TheWave est un projet de développement web dynamique réalisé dans le cadre de la L2 à l'Université Gustave Eiffel.
C'est une application web de streaming musical permettant aux utilisateurs de découvrir, écouter et organiser de la musique à partir d’un catalogue d’artistes, groupes, albums et morceaux.

Technologies et Outils
----------------------
Python
Flask
PostgreSQL
psycopg2
HTML / CSS
Jinja2

Installation et Configuration
-----------------------------
Avoir Python installé sur votre système
Installer le module de base de données : pip install flask psycopg2-binary bcrypt
Configuration de la base de données
Lancement
Exécutez le programme principal via un terminal ou un IDE comme VS Code

Structure du dépôt
------------------
main.py : routes Flask et logique applicative ;  
db.py : connexion à la base de données ;  
templates/ : templates HTML ;  
static/ : fichiers statiques ;  
dump.sql : dump complet de la base ;  
rapport.pdf : documentation du projet.  

Ma Contribution :
-----------------
Développement des pages Suggestions et Recherche
Implémentation du système de recommandations basé sur l’historique d’écoute et les playlists publiques
Développement des fonctionnalités connexion, inscription et gestion des sessions utilisateur
Mise en place du hachage et de la sécurité des mots de passe
Écriture de plusieurs requêtes SQL utilisées pour les suggestions personnalisées et la recherche

Équipe (LASgame)
----------------
Laeticia KHRIS
Manon QUIVY