######################################################
# Script targets pour définir le pipeline
# Marie-Claude Mayotte, Ariane Barrette, Laurie-Anne Cournoyer & Mia Carrière
# 15 mars 2023
######################################################

# set le working directory à "projet_bio500" (project directory)

# Dépendances
library("targets")
library("tarchetypes")
library("rmarkdown")

tar_option_set(packages = c("rmarkdown", "knitr", "RSQLite", "leaflet", "leaflegend", "gplots"))

# Localisation des scripts R
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
    name = data, # Cible pour le modèle 
    command = clean_data(file_paths) # Jointure des jeux de données
  ),
  tar_target(
    # Scripts requetes_SQL, dont devraient sortir les donnees necessaires a la creation de figures
    name = con, #Cible pour le modèle
    command = creation_tab(data) #Exécuter
  ),
  tar_target(
    name = req_sql,
    command = donnees_sql(con)
  ),
  tar_render(
    name = rapport, # Cible du rapport
    path = "./rapport/rapport.Rmd" # Le path du rapport à renderiser
  )
)

