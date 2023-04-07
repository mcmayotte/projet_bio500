creation_tab <- function (collaboration, etudiant, cours) {
####Connection au fichier la BD####
library (RSQLite)
con <- dbConnect(SQLite(), dbname = "db.biologie")
#astuce getwd() ou stewd()


#####Cle 2 - etudiant####
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

#######Cle 3 - cours#####
tbl_cours <-"
CREATE TABLE cours (
  sigle VARCHAR(6),
  optionnel BOOLEAN,
  credits INTEGER,
  PRIMARY KEY(sigle)
);"
dbSendQuery(con,tbl_cours)

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

##Avoir fait le script nettoyage_donnees.R AVANT

#Mettre les données dans la bd
dbWriteTable(con, append = TRUE, name= "cours", value = cours, row.names = FALSE)
dbWriteTable(con, append = TRUE, name= "etudiants", value = etudiant, row.names = FALSE)
dbWriteTable(con, append = TRUE, name= "collaborations", value = collaboration, row.names = FALSE)

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
write.csv(nb_collab_etudiant, 'data/tableaux_SQL/nb_collab_etudiant.csv', row.names = FALSE)
write.csv(nb_paire_colla,  'data/tableaux_SQL/nb_paire_colla.csv', row.names = FALSE)


#PAS OUBLIER!!!
dbDisconnect(con)
}
