import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    dbname = 'nom_de_votre_base_de_donnees',
    host = 'sqletud.u-pem.fr',
    password = 'mot_de_passe_de_votre_base',
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.autocommit = True
  return conn

