
# set le working directory à "projet_bio500"
# setwd("/Users/marie-claudemayotte/Desktop/BIO500/projet_bio500/scripts/targets_projet/")

# Dépendances
library("targets")
library("rmarkdown")

## fichier doit obligatoirement s'appeller "_targets.R"
# Scripts R
source("data/donnees_nettoyees/nettoyage_donnees.R")
source("scripts/requetes_SQL.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = data, # Cible
    command = read_data(), # Emplacement du fichier
  ), 
  # Toujours pas sure, mais j'ai ajouté les requetes sql ici
  tar_target(
    req_sql, #Cible pour le modèle
    creation_tabl(collaboration, etudiant, cours) #Exécuter
  ),   
  tar_target(
    name = rmd,
    command = render("rmd.Rmd")
  )
)


