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
    name = donnees, # Cible
    command = read_data(),
  ), 
  tar_target(
    #Je sais tu dont pas pourquoi cette ligne là
    name = file_paths, #Cible
    command = list.files(donnees, full.names = TRUE) # Liste les fichers dans le dossier
  ),
  # Toujours pas sure, mais j'ai ajouté les requetes sql ici
  tar_target(
    name = req_sql, #Cible pour le modèle
    command = creation_tab() #Exécuter
  ),   
  tar_target(
    name = rapport_rmd,
    command = render("rapport.Rmd")
  )
)


