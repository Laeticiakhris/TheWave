-- SUPPRESSION
DROP TABLE IF EXISTS ecoute CASCADE;
DROP TABLE IF EXISTS suit_utilisateur CASCADE;
DROP TABLE IF EXISTS comprend CASCADE;
DROP TABLE IF EXISTS publie CASCADE;
DROP TABLE IF EXISTS interprete CASCADE;
DROP TABLE IF EXISTS appartient CASCADE;
DROP TABLE IF EXISTS suit_groupe CASCADE;
DROP TABLE IF EXISTS participe CASCADE;
DROP TABLE IF EXISTS playlist CASCADE;
DROP TABLE IF EXISTS utilisateur CASCADE;
DROP TABLE IF EXISTS piste_lecture CASCADE;
DROP TABLE IF EXISTS album CASCADE;
DROP TABLE IF EXISTS groupe CASCADE;
DROP TABLE IF EXISTS role CASCADE;
DROP TABLE IF EXISTS artiste CASCADE;


CREATE TABLE artiste(
    id_artiste serial PRIMARY KEY,
    nom varchar(50) NOT NULL,
    prenom varchar(50) NOT NULL,
    date_naissance date,
    date_mort date,
    image varchar(255)
);

CREATE TABLE role(
    id_role serial PRIMARY KEY,
    nom_role varchar(50) NOT NULL
);

CREATE TABLE groupe(
    id_groupe serial primary key,
    nom varchar(50) NOT NULL,
    date_creation date ,
    nationalite varchar(50),
    genre varchar(50),
    image varchar(255)
);

CREATE TABLE album(
    id_album serial PRIMARY KEY,
    titre varchar(50) NOT NULL,
    date_parution date CHECK (date_parution <= CURRENT_DATE),
    im_couverture varchar(255),
    description text
);

CREATE TABLE piste_lecture(
    id_piste serial PRIMARY KEY,
    titre varchar(100) NOT NULL,
    duree numeric(5,2),
    paroles text,
    id_album int REFERENCES album(id_album) ON DELETE SET NULL,
    num_piste int,
    UNIQUE(id_album,num_piste)
);

CREATE TABLE utilisateur(
    pseudonyme varchar(50) primary key,
    email varchar(50) UNIQUE,
    inscription date,
    mot_de_passe varchar(255) NOT NULL
);


CREATE TABLE playlist(
    id_playlist serial PRIMARY KEY,
    titre varchar(25) NOT NULL,
    description text,
    visibilite boolean DEFAULT true,
    pseudonyme varchar(50) REFERENCES utilisateur(pseudonyme) ON DELETE CASCADE
);
    
CREATE TABLE ecoute (
    id_ecoute serial PRIMARY KEY,
    date_ecoute timestamp,
    id_piste int REFERENCES piste_lecture(id_piste) ON DELETE CASCADE,
    pseudonyme varchar(50) REFERENCES utilisateur(pseudonyme) ON DELETE CASCADE
);
   
 -- Table d'associations   
    
CREATE TABLE participe (
    id_artiste int REFERENCES artiste(id_artiste) ON DELETE CASCADE,
    id_piste int REFERENCES piste_lecture(id_piste) ON DELETE CASCADE,
    PRIMARY KEY (id_artiste, id_piste)
);    
    
CREATE TABLE suit_groupe (
    id_groupe int REFERENCES groupe(id_groupe) ON DELETE CASCADE,
    pseudonyme varchar(50) REFERENCES utilisateur(pseudonyme) ON DELETE CASCADE,
    PRIMARY KEY (id_groupe, pseudonyme)
);    

CREATE TABLE interprete (
    id_groupe int REFERENCES groupe(id_groupe) ON DELETE CASCADE,
    id_piste int REFERENCES piste_lecture(id_piste) ON DELETE CASCADE,
    PRIMARY KEY (id_groupe, id_piste)
);
    
CREATE TABLE appartient(
    id_artiste int REFERENCES artiste(id_artiste) ON DELETE CASCADE,
    id_role int REFERENCES role(id_role) ON DELETE CASCADE,
    id_groupe int REFERENCES groupe(id_groupe) ON DELETE CASCADE,
    date_arrivee date,
    date_depart date,
    CHECK (date_depart IS NULL OR date_depart >= date_arrivee),
    PRIMARY KEY(id_artiste, id_role, id_groupe)
);

CREATE TABLE publie (
    id_groupe int REFERENCES groupe(id_groupe) ON DELETE CASCADE,
    id_album int REFERENCES album(id_album) ON DELETE CASCADE,
    PRIMARY KEY (id_groupe, id_album)
);

CREATE TABLE comprend (
    id_playlist int REFERENCES playlist(id_playlist) ON DELETE CASCADE,
    id_piste int REFERENCES piste_lecture(id_piste) ON DELETE CASCADE,
    position int,
    UNIQUE(id_playlist,position),
    PRIMARY KEY (id_playlist, id_piste)
);

CREATE TABLE suit_utilisateur (
    id_suiveur varchar(50) REFERENCES utilisateur(pseudonyme) ON DELETE CASCADE,
    id_suivi varchar(50) REFERENCES utilisateur(pseudonyme) ON DELETE CASCADE,
    PRIMARY KEY (id_suiveur, id_suivi),
    CHECK (id_suiveur <> id_suivi)
);


-- Artistes
INSERT INTO artiste (id_artiste, nom, prenom, date_naissance, date_mort, image) VALUES
(1,'Lennon','John','1940-10-09','1980-12-08','artistes/1.jpg'),
(2,'McCartney','Paul','1942-06-18',NULL,'artistes/2.jpg'),
(3,'Harrison','George','1943-02-25','2001-11-29','artistes/3.jpg'),
(4,'Starr','Ringo','1940-07-07',NULL,'artistes/4.jpg'),
(5,'Mercury','Freddie','1946-09-05','1991-11-24','artistes/5.jpg'),
(6,'May','Brian','1947-07-19',NULL,'artistes/6.jpg'),
(7,'Taylor','Roger','1949-07-26',NULL,'artistes/7.jpg'),
(8,'Deacon','John','1951-08-19',NULL,'artistes/8.jpg'),
(9,'Cobain','Kurt','1967-02-20','1994-04-05','artistes/9.jpg'),
(10,'Grohl','Dave','1969-01-14',NULL,'artistes/10.jpg'),
(11,'Novoselic','Krist','1965-05-16',NULL,'artistes/11.jpg'),
(12,'Hetfield','James','1963-08-03',NULL,'artistes/12.jpg'),
(13,'Ulrich','Lars','1963-12-26',NULL,'artistes/13.jpg'),
(14,'Hammett','Kirk','1962-11-18',NULL,'artistes/14.jpg'),
(15,'Bowie','David','1947-01-08','2016-01-10','artistes/15.jpg'),
(16,'Jagger','Mick','1943-07-26',NULL,'artistes/16.jpg'),
(17,'Richards','Keith','1943-12-18',NULL,'artistes/17.jpg'),
(18,'Plant','Robert','1948-08-20',NULL,'artistes/18.jpg'),
(19,'Page','Jimmy','1944-01-09',NULL,'artistes/19.jpg'),
(20,'Swift','Taylor','1989-12-13',NULL,'artistes/20.jpg'),
(21,'Turner','Tina','1939-11-26','2023-05-24','artistes/21.jpg'),
(22,'Morrison','Jim','1943-12-08','1971-07-03','artistes/22.jpg'),
(23,'Anthony','Marc','1968-09-16',NULL,'artistes/23.jpg'),
(24,'Jackson','Michael','1958-08-29','2009-06-25','artistes/24.jpg'),
(25,'Presley','Elvis','1935-01-08','1977-08-16','artistes/25.jpg'),
(26,'Marley','Bob','1945-02-06','1981-05-11','artistes/26.jpg'),
(27,'Gaye','Marvin','1939-04-02','1984-04-01','artistes/27.jpg'),
(28,'Wonder','Stevie','1950-05-13',NULL,'artistes/28.jpg'),
(29,'Adele','Adele','1988-05-05',NULL,'artistes/29.jpg'),
(30,'Eilish','Billie','2001-12-18',NULL,'artistes/30.jpg'),
(31,'Young','Neil','1945-11-12',NULL,'artistes/31.jpg'),
(32,'Pearl','Eddie','1964-08-08','2019-10-06','artistes/32.jpg'),
(33,'Dylan','Bob','1941-05-24',NULL,'artistes/33.jpg'),
(34,'Lorde','Ella','1996-11-07',NULL,'artistes/34.jpg'),
(35,'Bieber','Justin','1994-03-01',NULL,'artistes/35.jpg'),
(36,'Beyoncé','Beyoncé','1981-09-04',NULL,'artistes/36.jpg'),
(37,'Theodora','Theodora','2003-10-23',NULL,'artistes/37.jpg'),
(38,'Nakamura','Aya','1995-05-10',NULL,'artistes/38.jpg'),
(39,'The Weeknd','','1990-02-16',NULL,'artistes/39.jpg');

-- INSERTS : ROLES
INSERT INTO role (id_role, nom_role) VALUES
(1,'Chanteur'),
(2,'Guitariste'),
(3,'Bassiste'),
(4,'Batteur'),
(5,'Compositeur'),
(6,'Pianiste'),
(7,'Producteur'),
(8,'Auteur');

-- INSERTS : GROUPES (10)

INSERT INTO groupe (id_groupe, nom, date_creation, nationalite, genre, image) VALUES
(1,'The Beatles','1960-01-01','Britannique','Rock','groupes/1.jpg'),
(2,'Queen','1970-01-01','Britannique','Rock','groupes/2.jpg'),
(3,'Nirvana','1987-01-01','Américaine','Grunge','groupes/3.jpg'),
(4,'Metallica','1981-01-01','Américaine','Metal','groupes/4.jpg'),
(5,'The Rolling Stones','1962-01-01','Britannique','Rock','groupes/5.jpg'),
(6,'Led Zeppelin','1968-01-01','Britannique','Hard Rock','groupes/6.jpg'),
(7,'The Doors','1965-01-01','Américaine','Psych Rock','groupes/7.jpg'),
(8,'Bee Gees','1958-01-01','Britannique','Pop','groupes/8.jpg'),
(9,'Jackson 5','1964-01-01','Américaine','Soul','groupes/9.jpg'),
(10,'The Wailers','1963-01-01','Jamaïcaine','Reggae','groupes/10.jpg'),
(11,'Michael Jackson','1980-01-01','Américaine','Pop','groupes/11.jpg'),
(12,'Bob Marley','1965-01-01','Jamaïcaine','Reggae','groupes/12.jpg'),
(13,'Adele','2011-01-01','Britannique','Pop','groupes/13.jpg'),
(14,'Billie Eilish','2019-01-01','Américaine','Pop','groupes/14.jpg'),
(15,'Pearl Jam','1990-01-01','Américaine','Grunge','groupes/15.jpg'),
(16,'Fleetwood Mac','1967-01-01','Britannique','Rock','groupes/16.jpg'),
(17,'The Weeknd','2010-01-01','Canadienne','Pop/R&B','groupes/17.jpg'),
(18,'Coldplay','1996-01-01','Britannique','Pop/Rock','groupes/18.jpg'),
(19,'Justin Bieber','2009-01-01','Canadienne','Pop','groupes/19.jpg'),
(20,'Beyoncé ','2003-01-01','Américaine','R&B','groupes/20.jpg'),
(21, 'Theodora', '2018-01-01', 'Francaise', 'Pop', 'groupes/21.jpg'),
(22, 'Aya Nakamura', '2014-01-01', 'Francaise', 'Pop', 'groupes/22.jpg'),
(23,'David Bowie','1969-01-01','Britannique','Rock','groupes/23.jpg'),
(24,'Tina Turner','1958-01-01','Américaine','Rock/Soul','groupes/24.jpg'),
(25,'Jim Morrison ','1965-01-01','Américaine','Rock','groupes/25.jpg'),
(26,'Marc Anthony','1988-01-01','Américaine','Salsa','groupes/26.jpg'),
(27,'Stevie Wonder','1961-01-01','Américaine','Soul/R&B','groupes/27.jpg'),
(28,'Bob Dylan','1962-01-01','Américaine','Folk/Rock','groupes/28.jpg'),
(29,'Ella Lorde','2014-01-01','Néo-Zélandaise','Pop','groupes/29.jpg'),
(30,'Taylor Swift','2006-01-01','Américaine','Pop/Country','groupes/30.jpg');


INSERT INTO appartient (id_artiste, id_role, id_groupe, date_arrivee, date_depart) VALUES
(1,1,1,'1960-01-01','1980-12-08'),    -- John Lennon -> The Beatles
(2,3,1,'1960-01-01',NULL),            -- Paul McCartney -> The Beatles
(3,2,1,'1960-01-01','2001-11-29'),    -- George Harrison -> The Beatles
(4,4,1,'1962-08-18',NULL),            -- Ringo Starr -> The Beatles
(5,1,2,'1970-01-01','1991-11-24'),    -- Freddie Mercury -> Queen
(6,2,2,'1970-01-01',NULL),            -- Brian May -> Queen
(7,2,2,'1970-01-01',NULL),            -- Roger Taylor -> Queen
(8,3,2,'1970-01-01',NULL),            -- John Deacon -> Queen
(9,1,3,'1987-01-01','1994-04-05'),    -- Kurt Cobain -> Nirvana
(10,4,3,'1987-01-01',NULL),           -- Dave Grohl -> Nirvana
(11,3,3,'1987-01-01',NULL),           -- Krist Novoselic -> Nirvana
(12,1,4,'1981-01-01',NULL),           -- James Hetfield -> Metallica
(13,4,4,'1981-01-01',NULL),           -- Lars Ulrich -> Metallica
(14,2,4,'1983-01-01',NULL),           -- Kirk Hammett -> Metallica
(15,1,5,'1970-01-01','1991-11-24'),   -- David Bowie -> David Bowie (solo)
(16,1,6,'1962-01-01',NULL),           -- Mick Jagger -> The Rolling Stones
(17,2,6,'1962-01-01',NULL),           -- Keith Richards -> The Rolling Stones
(18,1,7,'1968-01-01',NULL),           -- Robert Plant -> Led Zeppelin
(19,2,7,'1968-01-01',NULL),           -- Jimmy Page -> Led Zeppelin
(20,1,8,'2006-01-01',NULL),           -- Taylor Swift -> Taylor Swift (solo)
(21,1,24,'1958-01-01','2023-05-24'),  -- Tina Turner -> Tina Turner (solo)
(22,1,25,'1965-01-01','1971-07-03'),  -- Jim Morrison -> Jim Morrison (solo)
(23,1,26,'1988-01-01',NULL),          -- Marc Anthony -> Marc Anthony (solo)
(24,1,11,'1980-01-01','2009-06-25'),  -- Michael Jackson -> Michael Jackson (solo)
(25,1,27,'1965-01-01','1981-05-11'),  -- Bob Marley -> Bob Marley (solo)
(26,1,28,'1961-01-01',NULL),          -- Marvin Gaye -> solo
(27,1,29,'1950-01-01',NULL),          -- Stevie Wonder -> solo
(28,1,13,'2011-01-01',NULL),          -- Adele -> Adele (solo)
(29,1,14,'2019-01-01',NULL),          -- Billie Eilish -> Billie Eilish (solo)
(30,1,15,'1990-01-01',NULL),          -- Neil Young -> Pearl Jam
(31,1,16,'1967-01-01','1977-01-01'),  -- Fleetwood Mac -> Neil Young
(32,1,15,'1990-01-01',NULL),          -- Eddie Vedder -> Pearl Jam
(35,1,19,'2009-01-01',NULL),          -- Justin Bieber -> Justin Bieber (solo)
(36,1,20,'2003-01-01',NULL),          -- Beyoncé -> Beyoncé (solo)
(37,1,21,'2018-01-01',NULL),          -- Theodora -> Theodora (solo)
(38,1,22,'2014-01-01',NULL),
(39,1,17,'2010-01-01',NULL),
(15,1,23,'1969-01-01',NULL),          -- David Bowie
(28,1,27,'1961-01-01',NULL),          -- Stevie Wonder
(33,1,28,'1962-01-01',NULL),          -- Bob Dylan
(34,1,29,'2014-01-01',NULL),          -- Ella Lorde
(20,1,30,'2006-01-01',NULL);  

-- INSERTS : ALBUMS (15)
INSERT INTO album (id_album, titre, date_parution, im_couverture, description) VALUES
(1,'Abbey Road','1969-09-26','album/1.jpg','Album culte des Beatles'),
(2,'A Night at the Opera','1975-11-21','album/2.jpg','Queen classique'),
(3,'Nevermind','1991-09-24','album/3.jpg','Album majeur du grunge'),
(4,'Master of Puppets','1986-03-03','album/4.jpg','Thrash metal emblématique'),
(5,'Sticky Fingers','1971-04-23','album/5.jpg','Rolling Stones iconique'),
(6,'IV','1971-11-08','album/6.jpg','Led Zeppelin IV'),
(7,'Dangerous','1991-11-26','album/7.jpg','Michael Jackson'),
(8,'Legend','1984-05-08','album/8.jpg','Compilation Bob Marley'),
(9,'Bad','1987-08-31','album/9.jpg','Michael Jackson bestseller'),
(10,'21','2011-01-24','album/10.jpg','Adele'),
(11,'When We All Fall Asleep','2019-03-29','album/11.jpg','Billie Eilish'),
(12,'Let It Be','1970-05-08','album/12.jpg','Beatles dernier album'),
(13,'In Utero','1993-09-21','album/13.jpg','Nirvana album final'),
(14,'Exodus','1977-06-03','album/14.jpg','Bob Marley & The Wailers'),
(15,'Greatest Hits','1981-10-26','album/15.jpg','Compilation variée'),
(16,'Rumours','1977-02-04','album/16.jpg','Album de Fleetwood Mac'),
(17,'After Hours','2020-03-20','album/17.jpg','Album de The Weeknd'),
(18,'Parachutes','2000-07-10','album/18.jpg','Album de Coldplay'),
(19,'Purpose','2015-11-13','album/19.jpg','Album de Justin Bieber'),
(20,'Dangerously in Love','2003-06-24','album/20.jpg','Album de Beyoncé'),
(21,'Bad Boy Lovestory','2024-05-01','album/21.jpg','Album de Boss Lady'),
(22,'DNK','2023-01-27','album/22.jpg','Album de La Reine'),
(23,'Thriller','1982-11-30','album/23.jpg','Michael Jackson album emblématique'),
(24,'Off The Wall','1979-08-10','album/24.jpg','Michael Jackson classique'),
(25,'25','2015-11-20','album/25.jpg','Adele troisième album'),
(26,'My World 2.0','2010-03-23','album/26.jpg','Justin Bieber deuxième album'),
(27,'B\Day','2006-09-04','album/27.jpg','Beyoncé deuxième album'),
(28,'Taylor Swift','2006-10-24','album/28.jpg','Taylor Swift premier album solo'),
(29,'Let\s Dance','1983-04-14','album/29.jpg','David Bowie album culte'),
(30,'Private Dancer','1984-06-20','album/30.jpg','Tina Turner album iconique'),
(31,'L.A. Woman','1971-04-19','album/31.jpg','Jim Morrison & The Doors'),
(32,'Marc Anthony','1999-06-29','album/32.jpg','Marc Anthony salsa album'),
(33,'Songs In The Key Of Life','1976-09-28','album/33.jpg','Stevie Wonder classique'),
(34,'Highway 61 Revisited','1965-08-30','album/34.jpg','Bob Dylan album emblématique'),
(35,'Melodrama','2017-06-16','album/35.jpg','Lorde album populaire'),
(36,'1989','2014-10-27','album/36.jpg','Taylor Swift pop album');

-- INSERTS : PISTES (40) - tous les id_piste explicités, num_piste unique par album
INSERT INTO piste_lecture (id_piste, titre, duree, paroles, id_album, num_piste) VALUES
(1,'Come Together',4.20,'Here come old flat top, he come grooving up slowly...',1,1),
(2,'Something',3.03,'Something in the way she moves...',1,2),
(3,'Oh! Darling',3.27,'Oh! Darling, please believe me...',1,3),
(4,'Here Comes The Sun',3.05,'Here comes the sun, and I say, it''s all right...',1,4),
(5,'Something - Demo',3.05,'Demo version with alternate lyrics.',1,5),
(6,'I Want You (She''s So Heavy)',7.47,NULL,1,6),
(7,'Maxwell''s Silver Hammer',3.27,NULL,1,7),
(8,'Because',2.45,NULL,1,8),
(9,'You Never Give Me Your Money',4.02,NULL,1,9),
(10,'Sun King',2.26,NULL,1,10),
(11,'Mean Mr. Mustard',1.06,NULL,1,11),
(12,'Polythene Pam',1.12,NULL,1,12),
(13,'She Came In Through the Bathroom Window',1.57,NULL,1,13),
(14,'Golden Slumbers',1.31,NULL,1,14),
(15,'Carry That Weight',1.36,NULL,1,15),
(16,'The End',2.21,NULL,1,16),
(17,'Her Majesty',0.23,NULL,1,17),

(18,'Bohemian Rhapsody',5.55,'Is this the real life? Is this just fantasy?...',2,1),
(19,'You''re My Best Friend',2.50,'Ooh, you make me live...',2,2),
(20,'Love of My Life',3.40,'Love of my life, you''ve hurt me...',2,3),
(21,'Another One Bites the Dust',3.35,'Steve walks warily down the street...',2,4),
(22,'Don''t Stop Me Now',3.30,'Tonight I''m gonna have myself a real good time...',2,5),
(23,'Somebody to Love',4.56,'Can anybody find me somebody to love?',2,6),
(24,'I''m in Love with My Car',3.05,NULL,2,7),
(25,'39',3.30,NULL,2,8),
(26,'Sweet Lady',4.03,NULL,2,9),
(27,'Seaside Rendezvous',2.13,NULL,2,10),
(28,'The Prophet''s Song',8.21,NULL,2,11),
(29,'Good Company',3.26,NULL,2,12),
(30,'God Save the Queen',1.20,NULL,2,13),
(31,'Death on Two Legs',3.43,NULL,2,14),
(32,'Lazing on a Sunday Afternoon',1.07,NULL,2,15),

(33,'Smells Like Teen Spirit',5.01,'Load up on guns, bring your friends...',3,1),
(34,'Come As You Are',3.38,'Come as you are, as you were...',3,2),
(35,'Lithium',4.17,'I''m so happy, '',''cause today I found my friends...',3,3),
(36,'In Bloom',4.15,'Sell the kids for food...',3,4),
(37,'Come As You Were - Live',4.10,'Live version.',3,5),
(38,'Lithium - Remastered',4.20,'Remastered edition.',3,6),
(39,'Territorial Pissings',2.23,NULL,3,7),
(40,'Drain You',3.44,NULL,3,8),
(41,'Lounge Act',2.36,NULL,3,9),
(42,'Stay Away',3.32,NULL,3,10),
(43,'On a Plain',3.16,NULL,3,11),
(44,'Something in the Way',3.52,NULL,3,12),
(45,'Endless, Nameless',6.47,NULL,3,13),
(46,'Breed',3.03,NULL,3,14),
(47,'Polly',2.57,NULL,3,15),

(48,'Master of Puppets',8.36,'End of passion play, crumbling away...',4,1),
(49,'Battery',5.12,'Lashing out the action, returning the reaction...',4,2),
(50,'Disposable Heroes',8.15,'Bodies fill the fields I see...',4,3),
(51,'The Thing That Should Not Be',6.36,NULL,4,4),
(52,'Welcome Home (Sanitarium)',6.27,NULL,4,5),
(53,'Leper Messiah',5.40,NULL,4,6),
(54,'Orion',8.27,NULL,4,7),
(55,'Damage, Inc.',5.32,NULL,4,8),

(56,'Brown Sugar',3.50,'Gold coast slave ship bound for cotton fields...',5,1),
(57,'Wild Horses',5.43,'I watched you suffer a dull aching pain...',5,2),
(58,'Cant You Hear Me Knocking',7.15,NULL,5,3),
(59,'You Gotta Move',2.33,NULL,5,4),
(60,'Bitch',3.37,NULL,5,5),
(61,'I Got the Blues',3.54,NULL,5,6),
(62,'Sister Morphine',5.34,NULL,5,7),
(63,'Dead Flowers',4.05,NULL,5,8),
(64,'Moonlight Mile',5.57,NULL,5,9),

(65,'Stairway to Heaven',8.02,'There''s a lady who''s sure all that glitters is gold...',6,1),
(66,'Black Dog',4.55,'Hey hey mama said the way you move...',6,2),

(67,'Billie Jean',4.54,'She was more like a beauty queen from a movie scene...',9,1),
(68,'Thriller',5.57,'It''s close to midnight and something evil''s lurking in the dark...',9,2),
(69,'Bad',4.07,NULL,9,3),
(70,'The Way You Make Me Feel',4.58,NULL,9,4),
(71,'Speed Demon',4.01,NULL,9,5),
(72,'Liberian Girl',3.52,NULL,9,6),
(73,'Just Good Friends',4.06,NULL,9,7),
(74,'Another Part of Me',3.54,NULL,9,8),
(75,'Man in the Mirror',5.19,NULL,9,9),
(76,'Dirty Diana',4.52,NULL,9,10),
(77,'Smooth Criminal',4.17,NULL,9,11),

(78,'Hello',4.55,'Hello, it''s me...',10,1),
(79,'Rolling in the Deep',3.48,'There''s a fire starting in my heart...',10,2),
(80,'Turning Tables',4.10,NULL,10,3),
(81,'Dont You Remember',4.03,NULL,10,4),
(82,'Set Fire to the Rain',4.02,NULL,10,5),
(83,'He Wont Go',4.38,NULL,10,6),
(84,'Take It All',3.48,NULL,10,7),
(85,'Ill Be Waiting',4.01,NULL,10,8),
(86,'One and Only',5.48,NULL,10,9),
(87,'Lovesong',5.16,NULL,10,10),
(88,'Someone Like You',4.45,NULL,10,11),

(89,'!!!!!!!',0.14,NULL,11,3),
(90,'xanny',4.04,NULL,11,4),
(91,'you should see me in a crown',3.08,NULL,11,5),
(92,'wish you were gay',3.41,NULL,11,6),
(93,'ilomilo',2.36,NULL,11,7),
(94,'my strange addiction',3.00,NULL,11,8),
(95,'8',2.53,NULL,11,9),
(96,'listen before i go',4.03,NULL,11,10),
(97,'i love you',4.51,NULL,11,11),
(98,'goodbye',1.59,NULL,11,12),
(99,'Bad Guy',3.14,'White shirt now red, my bloody nose...',11,1),
(100,'bury a friend',3.13,'What do you want from me? Why don''t you run from me?...',11,2),

(101,'Two of Us',3.36,NULL,12,4),
(102,'Dig a Pony',3.55,NULL,12,5),
(103,'Across the Universe',3.47,NULL,12,6),
(104,'I Me Mine',2.25,NULL,12,7),
(105,'Dig It',0.51,NULL,12,8),
(106,'Maggie Mae',0.40,NULL,12,9),
(107,'Ive Got a Feeling',3.37,NULL,12,10),
(108,'One After 909',2.54,NULL,12,11),
(109,'The Long and Winding Road',3.38,NULL,12,12),
(110,'Let It Be',4.03,'When I find myself in times of trouble, Mother Mary comes to me...',12,1),
(111,'Get Back',3.09,'Jojo was a man who thought he was a loner...',12,2),
(112,'Hey Jude',7.11,'Hey Jude, don''t make it bad...',12,3),


(113,'Heart-Shaped Box',4.41,'She eyes me like a Pisces when I am weak...',13,1),
(114,'All Apologies',3.50,'What else should I be? All apologies...',13,2),
(115,'Scentless Apprentice',3.48,NULL,13,3),
(116,'Serve the Servants',3.36,NULL,13,4),
(117,'Rape Me',2.50,NULL,13,5),
(118,'Frances Farmer Will Have Her Revenge on Seattle',4.09,NULL,13,6),
(119,'Dumb',2.32,NULL,13,7),
(120,'Very Ape',1.55,NULL,13,8),
(121,'Milk It',3.52,NULL,13,9),
(122,'Pennyroyal Tea',3.37,NULL,13,10),
(123,'Radio Friendly Unit Shifter',4.51,NULL,13,11),
(124,'Tourettes',1.35,NULL,13,12),

(125,'Exodus',7.40,'Movement of Jah people...',14,1),
(126,'Three Little Birds',3.00,'Don''t worry about a thing, cause every little thing gonna be all right...',14,2),
(127,'Natural Mystic',3.28,NULL,14,4),
(128,'So Much Things to Say',3.08,NULL,14,5),
(129,'Guiltiness',3.19,NULL,14,6),
(130,'The Heathen',2.32,NULL,14,7),
(131,'Turn Your Lights Down Low',3.40,NULL,14,8),
(132,'The Exodus (Reprise)',1.50,NULL,14,9),
(133,'I Shot The Sheriff',4.36,'I shot the sheriff, but I didn''t shoot no deputy...',14,3),

(134,'Killer Queen',3.00,NULL,15,3),
(135,'Fat Bottomed Girls',3.22,NULL,15,4),
(136,'Bicycle Race',3.01,NULL,15,5),
(137,'Youre My Best Friend',2.50,NULL,15,6),
(138,'Flash',2.48,NULL,15,7),
(139,'Seven Seas of Rhye',2.47,NULL,15,8),
(140,'Play the Game',3.33,NULL,15,9),
(141,'Body Language',4.34,NULL,15,10),
(142,'Good Old-Fashioned Lover Boy',2.54,NULL,15,11),
(143,'I Want to Break Free',4.18,NULL,15,12),
(144,'Radio Ga Ga',5.48,NULL,15,13),
(145,'Under Pressure',4.08,NULL,15,14),
(146,'A Kind of Magic',4.22,NULL,15,15),
(147,'Friends Will Be Friends',4.12,NULL,15,16),
(148,'One Vision',4.05,NULL,15,17),

(149,'Never Going Back Again',2.14,NULL,16,3),
(150,'Dont Stop',3.13,NULL,16,4),
(151,'Songbird',3.20,NULL,16,5),
(152,'The Chain',4.32,NULL,16,6),
(153,'You Make Loving Fun',3.31,NULL,16,7),
(154,'Second Hand News',2.56,NULL,16,8),
(155,'Gold Dust Woman',5.02,NULL,16,9),
(156,'Oh Daddy',3.54,NULL,16,10),
(157,'I Dont Want to Know',3.11,NULL,16,11),

(158,'Alone Again',4.10,NULL,17,3),
(159,'Too Late',3.59,NULL,17,4),
(160,'Hardest to Love',3.31,NULL,17,5),
(161,'Scared to Live',3.12,NULL,17,6),
(162,'Snowchild',4.07,NULL,17,7),
(163,'Escape from LA',5.55,NULL,17,8),
(164,'Heartless',3.21,NULL,17,9),
(165,'Faith',4.43,NULL,17,10),
(166,'Repeat After Me',3.15,NULL,17,11),
(167,'Until I Bleed Out',3.10,NULL,17,12),

(168,'Spies',5.18,NULL,18,3),
(169,'Sparks',3.47,NULL,18,4),
(170,'Trouble',4.34,NULL,18,5),
(171,'Parachutes',0.52,NULL,18,6),
(172,'High Speed',4.14,NULL,18,7),
(173,'We Never Change',4.09,NULL,18,8),
(174,'Everythings Not Lost',5.27,NULL,18,9),
(175,'Yellow',4.48,NULL,18,1),
(176,'Shiver',3.95,NULL,18,2),

(177,'Mark My Words',2.14,NULL,19,3),
(178,'Ill Show You',3.20,NULL,19,4),
(179,'The Feeling',4.05,NULL,19,5),
(180,'Life Is Worth Living',3.56,NULL,19,6),
(181,'Where Are Ãœ Now',4.08,NULL,19,7),
(182,'Company',3.28,NULL,19,8),
(183,'No Pressure',4.46,NULL,19,9),
(184,'No Sense',4.35,NULL,19,10),
(185,'We Are',3.24,NULL,19,11),
(186,'Children',3.43,NULL,19,12),
(187,'Purpose',3.31,NULL,19,13),
(188,'Love Yourself',3.53,'For all the times that you rained on my parade...',19,14),

(189,'Sorry',3.33,NULL,19,1),
(190,'What Do You Mean?',3.47,NULL,19,2),

(191,'Crazy In Love',3.97,NULL,20,1),
(192,'Baby Boy',3.77,NULL,20,2),
(193,'Naughty Girl',3.29,NULL,20,3),
(194,'Baby Boy',4.04,NULL,20,4),
(195,'Hip Hop Star',3.42,NULL,20,5),
(196,'Be with You',4.18,NULL,20,6),
(197,'Me, Myself and I',5.01,NULL,20,7),
(198,'Yes',4.19,NULL,20,8),
(199,'Signs',4.58,NULL,20,9),
(200,'Speechless',6.00,NULL,20,10),
(201,'The Closer I Get to You',4.58,NULL,20,11),
(202,'Dangerously in Love 2',4.54,NULL,20,12),
(203,'Gift from Virgo',2.18,NULL,20,13),

(204,'FNG',3.45,NULL,21,1),
(205,'Fashion Designa',4.02,NULL,21,2),
(206,'243 km/h',3.33,NULL,21,3),
(207,'Kongolese sous BBL',3.57,NULL,21,4),
(208,'PAY!',4.10,NULL,21,5),
(209,'Bad Boy Lovestory',4.25,NULL,21,6),
(210,'Sorry Sorry So',3.50,NULL,21,7),
(211,'Big Boss Lady',4.05,NULL,21,8),
(212,'Do You Wanna',3.58,NULL,21,9),

(213,'SMS',3.12,NULL,22,1),
(214,'Baby',3.28,NULL,22,2),
(215,'Daddy',2.58,NULL,22,3),
(216,'Tous les jours',3.45,NULL,22,4),
(217,'Cadeau',3.20,NULL,22,5),
(218,'Haut niveau',3.55,NULL,22,6),
(219,'Chérie',3.33,NULL,22,7),
(220,'Come Back',3.41,NULL,22,8),
(221,'Bisous',3.15,NULL,22,9),
(222,'Beleck',3.50,NULL,22,10),

-- Michael Jackson – album 25
(223,'Don''t Stop ''Til You Get Enough',6.05,NULL,24,1),
(224,'Rock With You',3.40,NULL,24,2),
(225,'Workin'' Day and Night',5.14,NULL,24,3),

-- Adele – album 28
(226,'Hello',4.55,NULL,25,1),
(227,'When We Were Young',4.50,NULL,25,2),
(228,'Send My Love',3.43,NULL,25,3),

-- Justin Bieber – album 31
(229,'Baby',3.36,NULL,26,1),
(230,'Somebody to Love',3.40,NULL,26,2),

-- Beyoncé – album 33
(231,'Déjà Vu',3.45,NULL,27,1),
(232,'Irreplaceable',3.48,NULL,27,2),

-- David Bowie – album 36
(233,'Let''s Dance',4.08,NULL,29,1),
(234,'China Girl',4.45,NULL,29,2),

-- Tina Turner – album 37
(235,'Private Dancer',4.03,NULL,30,1),
(236,'Better Be Good to Me',3.58,NULL,30,2),

-- Jim Morrison – album 38
(237,'Riders on the Storm',7.09,NULL,31,1),
(238,'L.A. Woman',7.55,NULL,31,2),

-- Marc Anthony – album 39
(239,'I Need to Know',4.09,NULL,32,1),
(240,'You Sang to Me',4.45,NULL,32,2),

-- Stevie Wonder – album 40
(241,'Sir Duke',3.55,NULL,33,1),
(242,'I Wish',4.12,NULL,33,2),

-- Bob Dylan – album 41
(243,'Like a Rolling Stone',6.13,NULL,34,1),
(244,'Desolation Row',11.21,NULL,34,2),

-- Lorde – album 42
(245,'Green Light',3.54,NULL,35,1),
(246,'Liability',2.52,NULL,35,2),

-- Taylor Swift – album 43
(247,'Blank Space',3.51,NULL,36,1),
(248,'Style',3.51,NULL,36,2);


-- INSERTS : PARTICIPE (associations artiste -> piste) - variés
INSERT INTO participe (id_artiste, id_piste) VALUES
(39,158),(39,159),(39,160),(39,161),(39,162),(39,163),(39,164),(39,165),(39,166),(39,167),
-- The Beatles (albums 1, 12)
(1,1),(2,1),(3,1),(4,1),
(1,2),(2,2),(3,2),(4,2),
(1,3),(2,3),(3,3),(4,3),
(1,4),(2,4),(3,4),(4,4),
(1,5),(2,5),(3,5),(4,5),
(1,6),(2,6),(3,6),(4,6),
(1,7),(2,7),(3,7),(4,7),
(1,8),(2,8),(3,8),(4,8),
(1,9),(2,9),(3,9),(4,9),
(1,10),(2,10),(3,10),(4,10),
(1,11),(2,11),(3,11),(4,11),
(1,12),(2,12),(3,12),(4,12),
(1,13),(2,13),(3,13),(4,13),
(1,14),(2,14),(3,14),(4,14),
(1,15),(2,15),(3,15),(4,15),
(1,16),(2,16),(3,16),(4,16),
(1,17),(2,17),(3,17),(4,17),

(1,101),(2,101),(3,101),(4,101),
(1,102),(2,102),(3,102),(4,102),
(1,103),(2,103),(3,103),(4,103),
(1,104),(2,104),(3,104),(4,104),
(1,105),(2,105),(3,105),(4,105),
(1,106),(2,106),(3,106),(4,106),
(1,107),(2,107),(3,107),(4,107),
(1,108),(2,108),(3,108),(4,108),
(1,109),(2,109),(3,109),(4,109),
(1,110),(2,110),(3,110),(4,110),
(1,111),(2,111),(3,111),(4,111),
(1,112),(2,112),(3,112),(4,112),

-- Queen (albums 2, 15)
(5,18),(6,18),(7,18),(8,18),
(5,19),(6,19),(7,19),(8,19),
(5,20),(6,20),(7,20),(8,20),
(5,21),(6,21),(7,21),(8,21),
(5,22),(6,22),(7,22),(8,22),
(5,23),(6,23),(7,23),(8,23),

(5,134),(6,134),(7,134),(8,134),
(5,135),(6,135),(7,135),(8,135),
(5,136),(6,136),(7,136),(8,136),
(5,137),(6,137),(7,137),(8,137),
(5,143),(6,143),(7,143),(8,143),
(5,144),(6,144),(7,144),(8,144),
(5,145),(6,145),(7,145),(8,145),

-- Nirvana (albums 3, 13)
(9,33),(10,33),(11,33),
(9,34),(10,34),(11,34),
(9,35),(10,35),(11,35),
(9,36),(10,36),(11,36),
(9,113),(10,113),(11,113),
(9,114),(10,114),(11,114),

-- Metallica (album 4)
(12,48),(13,48),(14,48),
(12,49),(13,49),(14,49),
(12,50),(13,50),(14,50),
(12,51),(13,51),(14,51),
(12,52),(13,52),(14,52),

-- Rolling Stones (album 5)
(16,56),(17,56),
(16,57),(17,57),
(16,58),(17,58),

-- Led Zeppelin (album 6)
(18,65),(19,65),
(18,66),(19,66),

-- Artistes solo
(24,67),(24,68),(24,69),(24,70),(24,71),(24,72),(24,73),(24,74),(24,75),(24,76),(24,77),
(29,78),(29,79),(29,80),(29,81),(29,82),(29,83),(29,84),(29,85),(29,86),(29,87),(29,88),
(30,89),(30,90),(30,91),(30,92),(30,93),(30,94),(30,95),(30,96),(30,97),(30,98),(30,99),(30,100),

(26,125),(26,126),(26,127),(26,128),(26,129),(26,130),(26,131),(26,132),(26,133),

(36,191),(36,192),(36,193),(36,194),(36,195),(36,196),(36,197),(36,198),(36,199),(36,200),
(36,201),(36,202),(36,203),

(37,204),(37,205),(37,206),(37,207),(37,208),(37,209),(37,210),(37,211),(37,212),

(38,213),(38,214),(38,215),(38,216),(38,217),(38,218),(38,219),(38,220),(38,221),(38,222),

(35,189),(35,190),(35,177),(35,178),(35,179),(35,180),(35,181),(35,182),(35,183),(35,184),(35,185),(35,186),(35,187),(35,188),

(21,235),(21,236),
(22,237),(22,238),
(23,239),(23,240),
(28,241),(28,242),
(33,243),(33,244),
(34,245),(34,246),
(20,247),(20,248);

-- INSERTS : PUBLIE (groupe -> album)
INSERT INTO publie (id_groupe, id_album) VALUES

-- Groupes historiques
(1,1),(1,12),                 -- The Beatles
(2,2),(2,15),                 -- Queen
(3,3),(3,13),                 -- Nirvana
(4,4),                        -- Metallica
(5,5),                        -- Rolling Stones
(6,6),                        -- Led Zeppelin

-- Artistes solo / groupes dédiés
(11,7),(11,9),(11,23),(11,24), -- Michael Jackson
(12,8),(12,14),                -- Bob Marley
(13,10),(13,25),               -- Adele
(14,11),                       -- Billie Eilish
(16,16),                       -- Fleetwood Mac
(17,17),                       -- The Weeknd
(18,18),                       -- Coldplay
(19,19),(19,26),               -- Justin Bieber
(20,20),(20,27),               -- Beyoncé
(21,21),(30,28),               -- Theodora
(22,22),                       -- Aya Nakamura
(23,29),                       -- David Bowie
(24,30),                       -- Tina Turner
(25,31),                       -- Jim Morrison / The Doors
(26,32),                       -- Marc Anthony
(27,33),                       -- Stevie Wonder
(28,34),                       -- Bob Dylan
(29,35),                       -- Ella Lorde
(30,36);                       -- Taylor Swift         

INSERT INTO interprete (id_groupe, id_piste) VALUES

-- The Beatles (albums 1,12)
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),
(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),
(1,101),(1,102),(1,103),(1,104),(1,105),(1,106),(1,107),
(1,108),(1,109),(1,110),(1,111),(1,112),

-- Queen (albums 2,15)
(2,18),(2,19),(2,20),(2,21),(2,22),(2,23),(2,24),(2,25),
(2,26),(2,27),(2,28),(2,29),(2,30),(2,31),(2,32),
(2,134),(2,135),(2,136),(2,137),(2,138),(2,139),(2,140),
(2,141),(2,142),(2,143),(2,144),(2,145),(2,146),(2,147),(2,148),

-- Nirvana (albums 3,13)
(3,33),(3,34),(3,35),(3,36),(3,37),(3,38),(3,39),(3,40),
(3,41),(3,42),(3,43),(3,44),(3,45),(3,46),(3,47),
(3,113),(3,114),(3,115),(3,116),(3,117),(3,118),
(3,119),(3,120),(3,121),(3,122),(3,123),(3,124),

-- Metallica (album 4)
(4,48),(4,49),(4,50),(4,51),(4,52),(4,53),(4,54),(4,55),

-- Rolling Stones (album 5)
(5,56),(5,57),(5,58),(5,59),(5,60),(5,61),(5,62),(5,63),(5,64),

-- Led Zeppelin (album 6)
(6,65),(6,66),

-- Michael Jackson (albums 7,9,23,24)
(11,67),(11,68),(11,69),(11,70),(11,71),(11,72),(11,73),
(11,74),(11,75),(11,76),(11,77),
(11,223),(11,224),(11,225),

-- Bob Marley (albums 8,14)
(12,125),(12,126),(12,127),(12,128),(12,129),(12,130),
(12,131),(12,132),(12,133),

-- Adele (albums 10,25)
(13,78),(13,79),(13,80),(13,81),(13,82),(13,83),
(13,84),(13,85),(13,86),(13,87),(13,88),
(13,226),(13,227),(13,228),

-- Billie Eilish (album 11)
(14,89),(14,90),(14,91),(14,92),(14,93),(14,94),
(14,95),(14,96),(14,97),(14,98),(14,99),(14,100),

-- Fleetwood Mac (album 16)
(16,149),(16,150),(16,151),(16,152),(16,153),(16,154),
(16,155),(16,156),(16,157),

-- The Weeknd (album 17)
(17,158),(17,159),(17,160),(17,161),(17,162),
(17,163),(17,164),(17,165),(17,166),(17,167),

-- Coldplay (album 18)
(18,175),(18,176),(18,168),(18,169),(18,170),(18,171),
(18,172),(18,173),(18,174),

-- Justin Bieber (albums 19,26)
(19,189),(19,190),(19,177),(19,178),(19,179),(19,180),
(19,181),(19,182),(19,183),(19,184),(19,185),(19,186),
(19,187),(19,188),(19,229),(19,230),

-- Beyoncé (albums 20,27)
(20,191),(20,192),(20,193),(20,194),(20,195),(20,196),
(20,197),(20,198),(20,199),(20,200),(20,201),(20,202),(20,203),
(20,231),(20,232),

-- Theodora (albums 21,28)
(21,204),(21,205),(21,206),(21,207),(21,208),(21,209),
(21,210),(21,211),(21,212),

-- Aya Nakamura (album 22)
(22,213),(22,214),(22,215),(22,216),(22,217),
(22,218),(22,219),(22,220),(22,221),(22,222),

-- David Bowie (album 29)
(23,233),(23,234),

-- Tina Turner (album 30)
(24,235),(24,236),

-- Jim Morrison / The Doors (album 31)
(25,237),(25,238),

-- Marc Anthony (album 32)
(26,239),(26,240),

-- Stevie Wonder (album 33)
(27,241),(27,242),

-- Bob Dylan (album 34)
(28,243),(28,244),

-- Lorde (album 35)
(29,245),(29,246),

-- Taylor Swift (album 36)
(30,247),(30,248);

-- INSERTS : UTILISATEURS (16)
INSERT INTO utilisateur (pseudonyme, email, inscription, mot_de_passe) VALUES
('fan1','fan1@mail.com','2023-01-10','motdepasse123'),
('fan2','fan2@mail.com','2024-02-15','password456'),
('beatleslover','beatles@mail.com','2022-05-22','lovebeatles'),
('newuser','newuser@mail.com','2024-10-01','nouveau123'),
('rockfan','rock@mail.com','2021-05-22','rock123'),
('johnny','johnny@mail.com','2024-01-08','jo987'),
('metalhead','metal@mail.com','2023-11-10','mdp1998'),
('swiftie','swift@mail.com','2024-02-14','taylor00'),
('nirvana1990','n90@mail.com','2024-07-01','passw90'),
('queenfan','queen@mail.com','2022-11-11','azerty123'),
('visitor','visitor@mail.com','2025-01-01','visit9876'),
('elvisfan','elvis@mail.com','2023-03-08','pwd11'),
('michaelfan','mj@mail.com','2021-10-10','pwd12'),
('bobfan','bob@mail.com','2022-06-06','pwd13'),
('doorsfan','doors@mail.com','2023-07-07','pwd14'),
('adelefan','adele@mail.com','2022-08-08','pwd15'),
('musicfan11','fan11@example.com',NULL,'mdp11'),
('rocklover','rock@example.com',NULL,'mdp12'),
('popqueen','pop@example.com',NULL,'mdp13');

-- INSERTS : PLAYLISTS (explicit ids)
INSERT INTO playlist (titre, description, visibilite, pseudonyme) VALUES
('Best of Beatles', 'Les meilleures chansons des Beatles', TRUE, 'fan1'),
('Mes chansons chill', 'Playlist privée pour relaxer', FALSE, 'fan2'),
('Classiques du rock', 'Sélection de classiques', TRUE, 'beatleslover'),
('Aucune piste', 'Playlist encore vide', TRUE, 'fan2'),
('Rock Legends', 'Rock intemporel', TRUE, 'rockfan'),
('Metal Fury', '100% Metal', TRUE, 'metalhead'),
('Chill Mix', 'Ambiance cool', FALSE, 'fan2'),
('Great Songs', 'Mix généraliste', TRUE, 'visitor'),
('Top MJ', 'Michael Jackson Only', TRUE, 'michaelfan'),
('Reggae Vibes', 'Bob Marley', TRUE, 'bobfan'),
('Grunge Classics', NULL, FALSE, 'musicfan11'),
('Rock Legends', NULL, TRUE, 'rocklover'),
('Pop Hits', NULL, TRUE, 'popqueen'),
('Rock Classics', 'Les meilleurs classiques du rock', TRUE, 'rockfan'),
('Chill Evening', 'Ambiance détente pour le soir', FALSE, 'visitor'),
('Pop Hits 2024', 'Top chansons pop actuelles', TRUE, 'swiftie'),
('Metal Madness', 'Les morceaux les plus puissants', TRUE, 'metalhead'),
('Indie Vibes', 'Sélection indie et alternative', TRUE, 'musicfan11'),
('Retro Party', 'Musique rétro pour danser', TRUE, 'adelefan');

-- INSERTS : COMPREND (id_playlist,id_piste,position) - positions uniques par playlist
INSERT INTO comprend (id_playlist, id_piste, position) VALUES
(1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,39,5),
(2,24,1),(2,25,2),
(3,16,1),(3,17,2),(3,18,3),
(5,5,1),(5,33,3),
(6,13,1),(6,14,2),(6,15,3),
(7,22,1),(7,31,2),
(8,26,1),(8,27,2),(8,38,3),
(9,20,1),(9,21,2),
(10,30,1),(10,40,2),
(11,41,1),(11,42,2),(11,9,3),(11,10,4),
(12,43,1),(12,44,2),(12,1,3),(12,2,4),
(13,45,1),(13,46,2),(13,49,3),(13,50,4),
(14,16,1),(14,18,2),(14,33,3),(14,48,4),
(15,78,1),(15,79,2),(15,80,3),(15,81,4),
(16,247,1),(16,248,2),(16,226,3),(16,227,4),
(17,48,1),(17,49,2),(17,50,3),(17,51,4),
(18,245,1),(18,246,2),(18,35,3),(18,36,4),
(19,23,1),(19,24,2),(19,25,3),(19,26,4);





-- INSERTS : SUIT_GROUPE
INSERT INTO suit_groupe (id_groupe, pseudonyme) VALUES
(1,'fan1'),
(1,'fan2'),
(1,'beatleslover'),
(2,'queenfan'),
(3,'nirvana1990'),
(30,'elvisfan'),
(23,'elvisfan'),
(9,'elvisfan'),
(30,'johnny'),
(22,'johnny'),
(21,'johnny'),
(4,'metalhead'),
(10,'bobfan'),
(23,'doorsfan'),
(30,'doorsfan'),
(1,'doorsfan'),
(3,'musicfan11'),
(1,'rocklover'),
(2,'rocklover'),
(17,'popqueen'),  -- The Weeknd
(19,'popqueen'),
(5,'fan1'),
(6,'swiftie'),
(7,'swiftie'),
(8,'visitor'),
(9,'visitor'),
(10,'rockfan'),
(11,'nirvana1990'),
(12,'beatleslover'),
(13,'metalhead'),
(14,'rocklover'),
(15,'adelefan');

-- INSERTS : SUIT_UTILISATEUR
INSERT INTO suit_utilisateur (id_suiveur, id_suivi) VALUES
('fan1','fan2'),
('fan1','rockfan'),
('fan2','beatleslover'),
('rockfan','metalhead'),
('visitor','fan1'),
('johnny','adelefan'),
('doorsfan','visitor'),
('fan1','johnny'),
('johnny','fan2'),
('fan2','fan1'),
('popqueen','johnny'),
('fan1','popqueen'),
('visitor','fan2'),
('visitor','rockfan'),
('fan2','visitor'),
('nirvana1990','doorsfan'),
('metalhead','rockfan'),
('swiftie','fan1'),
('adelefan','fan2'),
('beatleslover','fan1'),
('popqueen','swiftie'),
('johnny','rocklover');

-- INSERTS : ECOUTES (40) - id_ecoute explicite
INSERT INTO ecoute (date_ecoute, id_piste, pseudonyme) VALUES
('2024-11-01 18:00',1,'fan1'),
('2024-11-01 18:10',1,'fan2'),
('2024-11-01 18:15',2,'fan1'),
('2024-11-02 09:00',5,'queenfan'),
('2024-11-02 10:00',5,'fan1'),
('2024-11-02 10:30',9,'nirvana1990'),
('2024-11-02 10:45',9,'rockfan'),
('2024-11-03 11:00',16,'rockfan'),
('2024-11-03 11:10',16,'fan2'),
('2024-11-03 12:00',13,'metalhead'),
('2024-11-04 09:00',13,'rockfan'),
('2024-11-04 09:30',13,'visitor'),
('2024-11-05 14:00',7,'queenfan'),
('2024-11-05 14:10',7,'fan1'),
('2024-11-05 20:00',11,'nirvana1990'),
('2024-11-05 20:10',11,'doorsfan'),
('2024-11-06 21:00',19,'rockfan'),
('2024-11-06 21:30',19,'visitor'),
('2024-12-01 17:00',3,'beatleslover'),
('2024-12-02 19:00',6,'fan2'),
('2024-12-03 21:00',10,'nirvana1990'),
('2024-12-04 22:00',18,'visitor'),
('2024-12-06 12:30',15,'bobfan'),
('2024-12-06 12:45',17,'bobfan'),
('2024-12-06 13:00',31,'bobfan'),
('2024-12-07 16:00',22,'adelefan'),
('2024-12-07 17:30',26,'michaelfan'),
('2024-12-08 09:50',30,'elvisfan'),
('2024-12-09 10:50',28,'metalhead'),
('2024-12-09 11:10',29,'rockfan'),
('2024-12-09 12:20',6,'swiftie'),
('2024-12-10 15:30',7,'swiftie'),
('2024-12-10 18:40',4,'fan1'),
('2024-12-11 10:10',1,'visitor'),
('2024-12-11 11:15',2,'visitor'),
('2024-12-11 12:00',3,'visitor'),
('2024-12-11 13:20',9,'doorsfan'),
('2024-12-11 14:30',11,'johnny'),
('2024-12-11 15:45',12,'johnny'),
('2024-12-11 17:00',14,'johnny'),
('2025-01-01 10:00',1,'fan1'),
('2025-01-01 10:15',2,'fan1'),
('2025-01-01 11:00',3,'fan2'),
('2025-01-01 11:30',4,'beatleslover'),
('2025-01-01 12:00',5,'fan1'),
('2025-01-02 09:00',6,'rockfan'),
('2025-01-02 09:15',7,'rockfan'),
('2025-01-02 09:30',8,'visitor'),
('2025-01-02 10:00',9,'visitor'),
('2025-01-02 10:30',10,'visitor'),
('2025-01-02 11:00',11,'metalhead'),
('2025-01-02 11:15',12,'metalhead'),
('2025-01-02 11:30',13,'swiftie'),
('2025-01-02 12:00',14,'swiftie'),
('2025-01-03 14:00',15,'adelefan'),
('2025-01-03 14:30',16,'adelefan'),
('2025-01-03 15:00',17,'musicfan11'),
('2025-01-03 15:30',18,'musicfan11'),
('2025-01-03 16:00',19,'fan2'),
('2025-01-03 16:30',20,'fan2'),
('2025-01-03 17:00',21,'visitor'),
('2025-01-03 17:30',22,'visitor'),
('2025-01-04 09:00',23,'rocklover'),
('2025-01-04 09:30',24,'rocklover'),
('2025-01-04 10:00',25,'swiftie'),
('2025-01-04 10:30',26,'swiftie'),
('2025-01-04 11:00',27,'beatleslover'),
('2025-01-04 11:30',28,'beatleslover'),
('2025-01-04 12:00',29,'fan1'),
('2025-01-04 12:30',30,'fan1'),
('2025-01-05 10:00',31,'nirvana1990'),
('2025-01-05 10:30',32,'nirvana1990'),
('2025-01-05 11:00',33,'rockfan'),
('2025-01-05 11:30',34,'rockfan'),
('2025-01-05 12:00',35,'metalhead'),
('2025-01-05 12:30',36,'metalhead'),
('2025-01-05 13:00',37,'visitor'),
('2025-01-05 13:30',38,'visitor'),
('2025-01-05 14:00',39,'swiftie'),
('2025-01-05 14:30',40,'swiftie'),
('2025-01-06 09:00',41,'fan2'),
('2025-01-06 09:30',42,'fan2'),
('2025-01-06 10:00',43,'beatleslover'),
('2025-01-06 10:30',44,'beatleslover'),
('2025-01-06 11:00',45,'rocklover'),
('2025-01-06 11:30',46,'rocklover'),
('2025-01-06 12:00',47,'musicfan11'),
('2025-01-06 12:30',48,'musicfan11'),
('2025-01-06 13:00',49,'metalhead'),
('2025-01-06 13:30',50,'metalhead'),
('2025-01-06 14:00',51,'swiftie'),
('2025-01-06 14:30',52,'swiftie');
                                                               
                                                                                                                                
CREATE VIEW vw_ecoutes AS
SELECT
    id_piste,
    COUNT(id_ecoute) AS total_ecoutes,
    COUNT(DISTINCT pseudonyme) AS utilisateurs_uniques
FROM ecoute
GROUP BY id_piste;

CREATE VIEW vw_partages AS
SELECT
    c.id_piste,
    COUNT(DISTINCT c.id_playlist) AS nb_partages
FROM comprend c
JOIN playlist p ON c.id_playlist = p.id_playlist AND p.visibilite = TRUE
GROUP BY c.id_piste;

CREATE VIEW vw_remuneration AS
SELECT
    e.id_piste,
    e.utilisateurs_uniques,
    e.total_ecoutes,
    e.utilisateurs_uniques * 0.10 + (e.total_ecoutes - e.utilisateurs_uniques) * 0.01 AS remuneration
FROM vw_ecoutes e;


