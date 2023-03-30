
# set le working directory à "projet_bio500"
setwd("/Users/marie-claudemayotte/Desktop/BIO500/projet_bio500/scripts/targets_projet/")

# Dépendances
library("targets")
library("rmarkdown")

## fichier doit obligatoirement s'appeller "_targets.R"
# Scripts R
source("nettoyer_donnees.R")
source("visualisation.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = data, # Cible
    command = read_data(), # Emplacement du fichier
  ), 
  # La target suivante a "path" pour dépendance et importe les données. Sans
  # la séparation de ces deux étapes, la dépendance serait brisée et une
  # modification des données n'entrainerait pas l'exécution du pipeline
  tar_target(
    tete, #Cible pour le modèle
    visualisation(data) #Exécuter
  ),   
  tar_target(
    name = rmd,
    command = render("rmd.Rmd")
  )
)

