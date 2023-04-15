# set le working directory à "projet_bio500" (project directory)

# Dépendances
library("targets")
library("tarchetypes")
library("rmarkdown")

## fichier doit obligatoirement s'appeller "_targets.R"
# Scripts R
source("scripts/nettoyage_donnees.R")
source("scripts/requetes_SQL.R")


# Pipeline
list(
  tar_target(
    # Script nettoyage_donnees, dont sort les 3 tables_clean dans donnees_nettoyees
    name = donnees, # Cible
    command = read_data(),
  ),
  tar_target(
    # Pour que les tables_cleans soient luent et dispo
    name = path, # Cible
    command = "data/donnees_nettoyees", # Dossier contenant les fichiers de données
    format = "file" # Format de la cible
  ),
  tar_target(
    # Aucune maudite idée
    name = file_paths, # Cible
    command = list.files(path, full.names = TRUE) # Liste les fichiers dans le dossier
  ),
  tar_target(
    # Scripts requetes_SQL, dont devraient sortir les donnees necessaires a la creation de figures
    name = req_sql, #Cible pour le modèle
    command = creation_tab(file_paths) #Exécuter
  ),   
  tar_target(
    # Scripts pour faire le rapport.Rmd
    name = rapport_rmd,
    command = render("rapport.Rmd")
  )
)


