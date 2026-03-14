from flask import Flask, render_template, request, redirect, url_for, session
import time
from passlib.context import CryptContext
import db

app = Flask(__name__)
app.secret_key = b'faf1e62f442dbafb30ac8d2d5ec527f3d07462c0d8f6a86cea73567991801c44'
password_ctx = CryptContext(schemes=['bcrypt'])

def require_login():
    return "pseudonyme" in session

def mot_de_passe():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT pseudonyme, mot_de_passe FROM utilisateur")
            rows = cur.fetchall()

            for pseudo, mdp in rows:
                if not password_ctx.identify(mdp):
                
                    nouveau_hash = password_ctx.hash(mdp)
                    cur.execute(
                    "UPDATE utilisateur SET mot_de_passe = %s WHERE pseudonyme = %s",
                    (nouveau_hash, pseudo)
                )
            conn.commit()



@app.route("/connexion", methods=['GET', 'POST'])
def connexion():
    message = ""

    if request.method == "POST":
        pseudonyme = request.form.get('pseudonyme')
        mot_de_passe_entre = request.form.get('mot_de_passe')

        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT pseudonyme, mot_de_passe FROM utilisateur WHERE pseudonyme = %s",
                    (pseudonyme,)
                )
                user = cur.fetchone()

        if user:
            print(f"Utilisateur {user[0]} trouvé. Hash dans la base: {user[1]}")
            if password_ctx.verify(mot_de_passe_entre, user[1]):
                session['pseudonyme'] = user[0]
                return redirect(url_for('accueil'))
            else:
                print("Échec de la vérification du mot de passe.")
                message = "Pseudonyme ou mot de passe incorrect"
        else:
            print(f"Utilisateur {pseudonyme} non trouvé.")
            message = "Pseudonyme ou mot de passe incorrect"

    return render_template('connexion.html', message=message)

@app.route("/")   
def index():
    return redirect(url_for('connexion'))



@app.route("/inscription", methods=['GET', 'POST'])
def inscription():
    pseudonyme = request.form.get('pseudonyme')
    mot_de_passe = request.form.get('mot_de_passe')
    confirmation = request.form.get('confirmation')
    email = request.form.get('email')

    if mot_de_passe != confirmation:
        return render_template("connexion.html", message="Les mots de passe ne correspondent pas !")

    if not pseudonyme or not mot_de_passe or not confirmation or not email:
        return render_template("connexion.html", message="Tous les champs sont requis !")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT pseudonyme FROM utilisateur WHERE pseudonyme = %s", (pseudonyme,))
            user = cur.fetchall()

            if user:
                return render_template("connexion.html", message="Ce pseudonyme existe déjà !")

            hash_pw = password_ctx.hash(mot_de_passe)

            cur.execute(
                "INSERT INTO utilisateur(pseudonyme, email, inscription, mot_de_passe) "
                "VALUES (%s, %s, CURRENT_DATE, %s)",
                (pseudonyme, email, hash_pw)
            )
            conn.commit()

    return redirect(url_for('connexion'))

@app.route("/accueil")
def accueil():
    if not require_login():
        return redirect(url_for('connexion'))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT titre, date_parution, nom, im_couverture, id_album FROM album NATURAL JOIN publie NATURAL JOIN groupe ORDER BY date_parution DESC LIMIT 3")
            derniers_albums = cur.fetchall()

            cur.execute("SELECT nom, count(pseudonyme) AS nbsuiveur,image, id_groupe FROM groupe NATURAL JOIN suit_groupe GROUP BY nom, id_groupe ORDER BY nbsuiveur DESC LIMIT 2")
            groupe_populaires = cur.fetchall()

            cur.execute("SELECT titre, count(id_ecoute), id_piste AS nbecoute FROM piste_lecture NATURAL JOIN ecoute WHERE date_ecoute>= CURRENT_DATE -7 GROUP BY titre, id_piste ORDER BY nbecoute LIMIT 2")
            pistes_popu = cur.fetchall()
    return render_template("accueil.html", pseudonyme=session['pseudonyme'],derniers_albums=derniers_albums, groupe_populaires= groupe_populaires, pistes_popu=pistes_popu) 

@app.route("/deconnexion")
def deconnexion():
    session.pop('pseudonyme', None)
    return redirect(url_for('connexion'))

@app.route("/recherche", methods=['GET', 'POST'])
def recherche():
    if not require_login():
        return redirect(url_for('connexion'))

    if request.method == 'POST':
        terme = request.form.get('terme', '')
    else:
        terme = request.args.get('terme', '')


    type_filter = request.args.get('type', 'all')
    resultats_morceaux=[]
    result_album = []
    result_playlists=[]

    if terme:
        t= "%" + terme + "%"

        with db.connect() as conn:
            with conn.cursor() as cur:
                if type_filter in ['all', 'morceaux']:
                    cur.execute("SELECT id_piste, titre FROM piste_lecture NATURAL JOIN interprete NATURAL JOIN groupe WHERE titre ILIKE %s OR nom ILIKE %s ORDER BY titre", (t,t))
                    resultats_morceaux = cur.fetchall()

                if type_filter in ['all', 'albums']:
                    cur.execute("SELECT id_album,titre FROM album NATURAL JOIN publie NATURAL JOIN groupe WHERE titre ILIKE %s OR nom ILIKE %s ORDER BY titre", (t,t))
                    result_album=cur.fetchall()

                if type_filter in ['all', 'playlists']:
                    cur.execute("SELECT id_playlist,titre FROM playlist WHERE titre ILIKE %s ORDER BY titre",(t,))
                    result_playlists = cur.fetchall()

    return render_template("recherche.html",pseudonyme=session['pseudonyme'],terme=terme,type_filter=type_filter,resultats_morceaux=resultats_morceaux,result_album=result_album,result_playlists=result_playlists)



@app.route("/morceau/<id_piste>")
def morceau(id_piste):
    if not require_login():
        return redirect(url_for('connexion'))

    with db.connect() as conn:
        with conn.cursor() as cur:

            cur.execute("SELECT p.titre, p.paroles, p.duree, a.titre as album_titre, a.date_parution, a.im_couverture FROM piste_lecture p JOIN album a ON a.id_album = p.id_album WHERE p.id_piste = %s ", (id_piste,))
            morceau = cur.fetchone()

            if not morceau:
                return "Morceau non trouvé", 404

            cur.execute("SELECT id_artiste, nom, prenom, image FROM artiste NATURAL JOIN participe WHERE id_piste=%s;", (id_piste,))
            artistes = cur.fetchall()

            cur.execute("SELECT nom,genre, id_groupe FROM groupe NATURAL JOIN interprete WHERE id_piste=%s;", (id_piste,))
            groupes = cur.fetchall()

            cur.execute("""
                SELECT COUNT(*) FROM ecoute WHERE id_piste = %s
            """, (id_piste,))
            nb_ecoutes = cur.fetchone()[0]


    return render_template("morceau.html",pseudonyme=session['pseudonyme'],id_piste=id_piste,morceau=morceau,artistes=artistes,groupes=groupes,nb_ecoutes=nb_ecoutes)

@app.route("/ecouter_album/<id_album>")
def ecouter_album(id_album):
    if not require_login():
        return redirect(url_for("connexion"))

    pseudo = session["pseudonyme"]

    with db.connect() as conn:
        with conn.cursor() as cur:

            # Infos album
            cur.execute("SELECT titre FROM album WHERE id_album=%s", (id_album,))
            album = cur.fetchone()
            if not album:
                return "Album introuvable", 404

            # Récupérer toutes les pistes
            cur.execute("""
                SELECT id_piste FROM piste_lecture WHERE id_album=%s
            """, (id_album,))
            pistes = cur.fetchall()

            # Ajouter toutes les écoutes
            for p in pistes:
                cur.execute("""
                    INSERT INTO ecoute (pseudonyme, id_piste, date_ecoute)
    VALUES (%s, %s, NOW())
                """, (pseudo, p[0]))

            conn.commit()

    return render_template("ecouter.html", titre="l’album " + album[0])

@app.route("/ecouter/<id_piste>")
def ecouter(id_piste):
    if not require_login():
        return redirect(url_for("connexion"))

    pseudo = session["pseudonyme"]

    with db.connect() as conn:
        with conn.cursor() as cur:

            # Info du morceau
            cur.execute("SELECT titre FROM piste_lecture WHERE id_piste=%s", (id_piste,))
            piste = cur.fetchone()
            if not piste:
                return "Morceau introuvable", 404

            # Ajouter une écoute
            cur.execute("INSERT INTO ecoute (pseudonyme, id_piste, date_ecoute) VALUES (%s, %s, NOW())", (pseudo, id_piste))
            conn.commit()

    return render_template("ecouter.html", titre=piste[0])


@app.route("/playlist/<id_playlist>")
def playlist(id_playlist):
    if not require_login():
        return redirect(url_for('connexion'))

    with db.connect() as conn:
        with conn.cursor() as cur:
            # Récupérer les infos de la playlist
            cur.execute("SELECT titre, description, visibilite, pseudonyme FROM playlist WHERE id_playlist=%s", (id_playlist,))
            pl = cur.fetchone()
            if not pl:
                return "Playlist non trouvée", 404

            # Récupérer les pistes de la playlist
            cur.execute("""
                SELECT id_piste, titre
                FROM comprend 
                NATURAL JOIN piste_lecture
                WHERE id_playlist = %s
            """, (id_playlist,))
            pistes = cur.fetchall()

    return render_template("playlist.html", playlist=pl, pistes=pistes)

@app.route("/profil/playlists", methods=["GET", "POST"])
def profil_playlists():
    if not require_login():
        return redirect(url_for('connexion'))

    pseudo = session['pseudonyme']
    playlist_a_editer = None
    with db.connect() as conn:
        with conn.cursor() as cur:

            if request.method == "POST":
                # Récupération des données du formulaire
                titre = request.form.get("titre")
                description = request.form.get("description", "")
                visibilite = request.form.get("visibilite") == "on"
                id_playlist = request.form.get("id_playlist")

                if id_playlist:
                    # Édition existante
                    cur.execute("""
                        UPDATE playlist
                        SET titre=%s, description=%s, visibilite=%s
                        WHERE id_playlist=%s AND pseudonyme=%s
                    """, (titre, description, visibilite, id_playlist, pseudo))
                    
                else:
                    # Création nouvelle playlist
                    cur.execute("INSERT INTO playlist (titre, description, visibilite, pseudonyme) VALUES (%s, %s, %s, %s)", (titre, description, visibilite, pseudo))
                    
                conn.commit()
                return redirect(url_for('profil_playlists'))
            
            edit_id = request.args.get("edit_id")
            if edit_id:
                cur.execute("""
                    SELECT id_playlist, titre, description, visibilite
                    FROM playlist
                    WHERE id_playlist=%s AND pseudonyme=%s
                """, (edit_id, pseudo))
                playlist_a_editer = cur.fetchone()

            
            cur.execute("""
                SELECT id_playlist, titre, description, visibilite
                FROM playlist
                WHERE pseudonyme=%s
                ORDER BY id_playlist DESC
            """, (pseudo,))
            playlists = cur.fetchall()

    return render_template("profil_playlists.html", pseudonyme=pseudo, playlists=playlists, playlist_a_editer=playlist_a_editer)

@app.route("/profil/playlists/supprimer/<id_playlist>", methods=["POST"])
def supprimer_playlist(id_playlist):
    if not require_login():
        return redirect(url_for('connexion'))

    pseudo = session['pseudonyme']

    with db.connect() as conn:
        with conn.cursor() as cur:
            
            cur.execute("SELECT id_playlist FROM playlist WHERE id_playlist=%s AND pseudonyme=%s", (id_playlist, pseudo))
            if cur.fetchone():
                cur.execute("DELETE FROM playlist WHERE id_playlist=%s", (id_playlist,))
                conn.commit()

    return redirect(url_for('profil_playlists'))

@app.route("/suggestions")
def suggestions():
    if 'pseudonyme' not in session:
        return redirect(url_for("connexion"))

    pseudo = session['pseudonyme']

    with db.connect() as conn:
        with conn.cursor() as cur:

            cur.execute("SELECT id_artiste, nom, prenom, COUNT(*) AS nb FROM ecoute NATURAL JOIN participe NATURAL JOIN artiste WHERE pseudonyme=%s GROUP BY id_artiste,nom,prenom ORDER BY nb DESC LIMIT 1;", (pseudo,))
            top_art = cur.fetchone()

            suggested_tracks = []
            if top_art:
                cur.execute("""
                    SELECT DISTINCT p.id_piste, p.titre, a.id_album, a.titre AS album
                    FROM participe pa
                    JOIN piste_lecture p ON p.id_piste = pa.id_piste
                    LEFT JOIN album a ON a.id_album = p.id_album
                    WHERE pa.id_artiste = %s
                    ORDER BY p.titre
                    LIMIT 5
                """, (top_art[0],))
                suggested_tracks = cur.fetchall()

            #GROUPES AIMÉS PAR DES UTILISATEURS SIMILAIRES
            cur.execute("""SELECT id_groupe, nom, COUNT(*) AS nb FROM suit_groupe NATURAL JOIN groupe WHERE pseudonyme IN ( 
                        SELECT DISTINCT e.pseudonyme FROM ecoute e JOIN ecoute p ON e.id_piste=p.id_piste WHERE p.pseudonyme = %s
                        AND e.pseudonyme <> %s ) 
                        AND id_groupe NOT IN (
                        SELECT id_groupe FROM suit_groupe WHERE pseudonyme=%s ) 
                        GROUP BY id_groupe, nom ORDER BY nb DESC LIMIT 5""", (pseudo, pseudo, pseudo))
            suggested_groups = cur.fetchall()

            #PLAYLISTS PUBLIQUES QUI CORRESPONDENT
            cur.execute("""SELECT id_playlist, titre, pseudonyme, COUNT(*) AS nb FROM playlist 
                        NATURAL JOIN comprend WHERE visibilite=TRUE AND id_piste IN (
                         SELECT DISTINCT id_piste FROM ecoute WHERE pseudonyme=%s )
            GROUP BY id_playlist, titre, pseudonyme ORDER BY nb DESC LIMIT 5""", (pseudo,))
            suggested_playlists = cur.fetchall()

    return render_template("suggestions.html",pseudonyme=pseudo,top_art=top_art,suggested_tracks=suggested_tracks,suggested_groups=suggested_groups,suggested_playlists=suggested_playlists)

@app.route("/album/<id_album>")
def album(id_album):
    if not require_login():
        return redirect(url_for('connexion'))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_album, titre, date_parution, description, im_couverture FROM album WHERE id_album=%s", (id_album,))
            album = cur.fetchone()
            if not album:
                return "Album non trouvé", 404

            cur.execute("SELECT id_groupe,nom,genre FROM groupe NATURAL JOIN publie WHERE id_album=%s", (id_album,))
            groupes = cur.fetchall()

            cur.execute("SELECT id_piste,titre,duree FROM piste_lecture  WHERE id_album=%s ORDER BY num_piste", (id_album,))
            pistes = cur.fetchall()

    return render_template("album.html", pseudonyme=session['pseudonyme'],id_album=id_album, album=album, groupes=groupes, pistes=pistes)

@app.route("/groupe/<id_groupe>")
def groupe(id_groupe):
    if 'pseudonyme' not in session:
        return redirect(url_for('connexion'))

    with db.connect() as conn:
        with conn.cursor() as cur:

            # Infos groupe
            cur.execute("""SELECT id_groupe, nom, genre, image, nationalite, date_creation  
                           FROM groupe 
                           WHERE id_groupe=%s""", (id_groupe,))
            g = cur.fetchone()

            if not g:
                return "Groupe non trouvé", 404

            # Membres du groupe
            cur.execute("""
                SELECT prenom, nom, image
                FROM artiste NATURAL JOIN appartient
                WHERE id_groupe=%s AND date_depart IS NULL
            """, (id_groupe,))
            membres_actu = cur.fetchall()

            cur.execute("""
                SELECT prenom, nom, image
                FROM artiste NATURAL JOIN appartient
                WHERE id_groupe=%s AND date_depart IS NOT NULL
            """, (id_groupe,))
            membres_passé = cur.fetchall()

            # Albums publiés
            cur.execute("""
                SELECT id_album, titre, date_parution, im_couverture
                FROM album NATURAL JOIN publie
                WHERE id_groupe=%s
            """, (id_groupe,))
            albums = cur.fetchall()

            cur.execute("SELECT COUNT(*) FROM suit_groupe WHERE id_groupe = %s", (id_groupe,))
            nb_followers = cur.fetchone()[0]


    return render_template("groupe.html",pseudonyme=session['pseudonyme'],groupe=g,membres_actu=membres_actu,membres_passé=membres_passé,nb_followers=nb_followers,albums=albums)

@app.route("/profil")
def profil():
    if not require_login():
        return redirect(url_for('connexion'))

    pseudo = session['pseudonyme']

    with db.connect() as conn:
        with conn.cursor() as cur:

            cur.execute("SELECT id_piste,titre, count(id_ecoute) AS nb FROM piste_lecture NATURAL JOIN ecoute WHERE pseudonyme=%s GROUP BY titre, id_piste ORDER BY nb DESC LIMIT 5", (pseudo,))
            top_morceaux = cur.fetchall()

            cur.execute("SELECT id_piste,titre, date_ecoute FROM ecoute NATURAL JOIN piste_lecture WHERE pseudonyme=%s ORDER BY date_ecoute DESC LIMIT 5", (pseudo,))
            historique = cur.fetchall()

            cur.execute("SELECT id_album,titre, nom, date_parution, id_groupe FROM suit_groupe NATURAL JOIN groupe NATURAL JOIN publie NATURAL JOIN album WHERE pseudonyme=%s ORDER BY date_parution DESC LIMIT 5", (pseudo,))
            actu_groupes = cur.fetchall()

            cur.execute("SELECT u.pseudonyme, titre, id_playlist FROM suit_utilisateur s JOIN utilisateur u ON u.pseudonyme = s.id_suivi NATURAL JOIN playlist WHERE s.id_suiveur = %s AND visibilite=TRUE LIMIT 5", (pseudo,))
            actu_utilisateurs = cur.fetchall()

            cur.execute("SELECT titre,description, visibilite FROM playlist WHERE pseudonyme = %s ORDER BY id_playlist DESC", (pseudo,))
            mes_playlists = cur.fetchall()

    return render_template("profil.html",pseudonyme=pseudo,top_morceaux=top_morceaux,historique=historique,actu_groupes=actu_groupes,actu_utilisateurs=actu_utilisateurs,mes_playlists=mes_playlists)




if __name__ == '__main__':
    mot_de_passe()
    app.run(debug=True)