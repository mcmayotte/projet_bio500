# set le working directory à "projet_bio500" (project directory)

# Dépendances
library("targets")
library("rmarkdown")

## fichier doit obligatoirement s'appeller "_targets.R"
# Scripts R
source("scripts/nettoyage_donnees.R")
source("scripts/requetes_SQL.R")

# Pipeline
list(
  tar_target(
    name = path, # Cible
    command = "./data", # Dossier contenant les fichiers de données
    format = "file" # Format de la cible
  ),
  tar_target(
    name = file_paths, # Cible
    command = list.files(path, full.names = TRUE) # Liste les fichiers dans le dossier
  ),
  tar_target(
    name = donnees, # Cible
    command = read_data(),
  ), 
  tar_target(
    name = file_paths, #Cible
    command = list.files(donnees, full.names = TRUE) # Liste les fichers dans le dossier
  ),
  # Ajouter nettoyage de données

  # Toujours pas sure, mais j'ai ajouté les requetes sql ici
  tar_target(
    name = req_sql, #Cible pour le modèle
    command = creation_tab(file_paths) #Exécuter
  ),   
  tar_target(
    name = rapport_rmd,
    command = render("rmd.Rmd")
  )
)


