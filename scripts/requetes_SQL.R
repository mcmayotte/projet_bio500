creation_tab <- function (data) {
####Connection au fichier la BD####
library (RSQLite)
con <- dbConnect(SQLite(), dbname = "db.biocoordo10")
#astuce getwd() ou stewd()

#######Cle 1 - cours#####
tbl_cours <-"
CREATE TABLE cours (
  sigle VARCHAR(6),
  optionnel BOOLEAN,
  credits INTEGER,
  PRIMARY KEY(sigle)
);"
dbSendQuery(con,tbl_cours)

#######Cle 2 - coordonnees#####
tbl_coordo<-"
CREATE TABLE coordonnees (
  region_administrative VARCHAR(30),
  longitude REAL(10),
  latitude REAL(10),
  PRIMARY KEY (longitude,latitude)
);"
dbSendQuery(con,tbl_coordo)

#####Cle 3 - etudiant####
tbl_etud<-"
CREATE TABLE etudiants (
  prenom_nom VARCHAR(30),
  prenom VARCHAR(20),
  nom VARCHAR(20),
  region_administrative VARCHAR(30),
  regime_coop BOOLEAN,
  formation_prealable VARCHAR(16),
  annee_debut VARCHAR(5),
  programme VARCHAR(6),
  PRIMARY KEY (prenom_nom)
);"
dbSendQuery(con,tbl_etud)


#####Clé primaire - collaboration#####
tbl_colla <- "
CREATE TABLE collaborations (
  etudiant1 VARCHAR(30),
  etudiant2 VARCHAR(30),
  sigle VARCHAR(6),
  session VARCHAR(5),
  PRIMARY KEY (etudiant1, session, etudiant2, sigle),
  FOREIGN KEY (etudiant1) REFERENCES etudiants(prenom_nom),
  FOREIGN KEY (etudiant2) REFERENCES etudiants(prenom_nom),
  FOREIGN KEY (sigle) REFERENCES cours(sigle)
);"

dbSendQuery(con, tbl_colla)

#####Avoir fait le script nettoyage_donnees.R AVANT
coordonnees<-read.csv("data/coordonnees.csv",header=TRUE, sep=";")

#Mettre les données dans la bd
dbWriteTable(con, append = TRUE, name= "cours", value = cours, row.names = FALSE)
dbWriteTable(con, append = TRUE, name= "etudiants", value = etudiant, row.names = FALSE)
dbWriteTable(con, append = TRUE, name= "coordonnees", value = coordonnees, row.names = FALSE)
dbWriteTable(con, append = TRUE, name= "collaborations", value = collaboration, row.names = FALSE)

# Ajouter la colonne longitude dans la table etudiants
dbSendQuery(con, "ALTER TABLE etudiants ADD COLUMN longitude REAL(10)")

# Ajouter la colonne latitude column dans la table etudiants
dbSendQuery(con, "ALTER TABLE etudiants ADD COLUMN latitude REAL(10)")

# Mettre à jour les valeurs de longitude et de latitude dans la table etudiants à partir de la table coordonnees
dbSendQuery(con, "
  UPDATE etudiants
  SET longitude = coordonnees.longitude, 
      latitude = coordonnees.latitude 
  FROM coordonnees 
  WHERE etudiants.region_administrative = coordonnees.region_administrative
")

sql_requete <- "
SELECT prenom_nom,region_administrative,longitude, latitude
FROM etudiants;"

etudiants_coordo<-dbGetQuery(con,sql_requete)
head(etudiants_coordo)

#requete nb lien par étudiants
sql_requete <- "
SELECT count(etudiant1) AS nb_collab, etudiant1
FROM collaborations
GROUP BY etudiant1
ORDER BY nb_collab DESC
;"

nb_collab_etudiant <- dbGetQuery(con, sql_requete)
head(nb_collab_etudiant)

#requete nb collab par PAIRES d'étudiants
sql_requete <- "
SELECT etudiant1, etudiant2, COUNT(*) AS nb_collab
FROM collaborations
GROUP BY etudiant1, etudiant2
ORDER BY nb_collab DESC
;"

nb_paire_colla<- dbGetQuery(con, sql_requete)
head(nb_paire_colla)

#Enregistrer les tableaux créer
#write.csv(nb_collab_etudiant, 'data/tableaux_SQL/nb_collab_etudiant.csv', row.names = FALSE)
#write.csv(nb_paire_colla,  'data/tableaux_SQL/nb_paire_colla.csv', row.names = FALSE)
#write.csv(etudiants_coordo, 'data/tableaux_SQL/etudiants_coordo',row.names = FALSE)

#Requetes nb collaboration par r.a.
#sql_requete <- "
#SELECT collaborations.etudiant1, collaborations.etudiant2, collaborations.sigle, collaborations.session, etudiants.region_administrative AS region_administrative_et1
#FROM collaborations
#JOIN etudiants ON collaborations.etudiant1 = etudiants.prenom_nom
#;"

#rae1 <- dbGetQuery(con, sql_requete)
#head(rae1)

sql_requete <- "
SELECT region_administrative_et1, region_administrative_et2, COUNT(*) AS nb_collab, longitude_et1, longitude_et2, latitude_et1, latitude_et2
FROM (
SELECT collaborations.etudiant1, collaborations.etudiant2, collaborations.sigle, collaborations.session, 
       et1.region_administrative AS region_administrative_et1, et2.region_administrative AS region_administrative_et2, et1.longitude AS longitude_et1, et2.longitude AS longitude_et2, et1.latitude AS latitude_et1, et2.latitude AS latitude_et2
FROM collaborations
JOIN etudiants AS et1 ON collaborations.etudiant1 = et1.prenom_nom
JOIN etudiants AS et2 ON collaborations.etudiant2 = et2.prenom_nom
WHERE et1.region_administrative IS NOT NULL AND et2.region_administrative IS NOT NULL
)
GROUP BY region_administrative_et1, region_administrative_et2
ORDER BY region_administrative_et1 DESC
;"

nb_collab_region <- dbGetQuery(con, sql_requete)
head(nb_collab_region)

# write.csv(nb_collab_region, 'data/nb_collab_region.csv', row.names = FALSE)

#requete nb lien par region_administrative
sql_requete <- "
SELECT count(region_administrative_et1) AS nb_collab, region_administrative_et1 
FROM (
SELECT collaborations.etudiant1, collaborations.etudiant2, collaborations.sigle, collaborations.session, 
       et1.region_administrative AS region_administrative_et1, et2.region_administrative AS region_administrative_et2
FROM collaborations
JOIN etudiants AS et1 ON collaborations.etudiant1 = et1.prenom_nom
JOIN etudiants AS et2 ON collaborations.etudiant2 = et2.prenom_nom
)
GROUP BY region_administrative_et1
ORDER BY nb_collab DESC
;"

nb_collab_chq_region <- dbGetQuery(con, sql_requete)
head(nb_collab_chq_region)

#write.csv(nb_collab_region, 'data/nb_collab_chq_region.csv', row.names = FALSE)

# Requete moyenne de collaboration pour chaque programme universitaire
sql_requete <- "
SELECT AVG(nb_collab) AS moy_collab, SQRT(VARIANCE(nb_collab)) AS ecart_type, formation_prealable
FROM
(
SELECT count(etudiant1) AS nb_collab, etudiant1, formation_prealable
FROM collaborations
JOIN etudiants ON collaborations.etudiant1 = etudiants.prenom_nom
GROUP BY etudiant1, formation_prealable
)
GROUP BY formation_prealable
ORDER BY moy_collab DESC
;"

moy_collab_form <- dbGetQuery(con, sql_requete)
head(moy_collab_form)

# Requete moyenne collaboration pour chaque annee de début
sql_requete <- "
SELECT AVG(nb_collab) AS moy_collab, SQRT(VARIANCE(nb_collab)) AS ecart_type, annee_debut
FROM
(
SELECT count(etudiant1) AS nb_collab, etudiant1, annee_debut
FROM collaborations
JOIN etudiants ON collaborations.etudiant1 = etudiants.prenom_nom
GROUP BY etudiant1, annee_debut
)
GROUP BY annee_debut
ORDER BY moy_collab DESC
;"

moy_collab_annee <- dbGetQuery(con, sql_requete)
head(moy_collab_annee)

#-----------------------------------------------------
# Création d'une liste pour le targets
#-----------------------------------------------------
return(list(moy_collab_annee, moy_collab_form, nb_collab_region, nb_paire_colla, etudiants_coordo, nb_collab_etudiant))

#PAS OUBLIER!!!
dbDisconnect(con)


}
