# Importer la bibliothèque
library(leaflet)
library(leaflegend)
#Avoir fait les requêtes SQL
# Charger les données du réseau de connexion étudiant
nb_collab_region
etudiants_coordo

# Charger la carte
map <- leaflet() %>%
  setView(lng = -72.4946, lat = 47.34687, zoom = 5.7) %>%
  addTiles()
# Ajouter les marqueurs pour les étudiants
map <- map %>%
  addCircleMarkers(data = etudiants_coordo, 
             lng = ~longitude, 
             lat = ~latitude,
             popup = ~prenom_nom,
             radius=1)

# Calculer la plage des nombres d'interactions dans le tableau
interaction_range <- range(nb_collab_region$nb_collab)

# Définir une fonction pour convertir les nombres d'interactions en épaisseurs de ligne
get_weight <- function(x) {
  x / 10  # Diviser par 10 pour normaliser l'épaisseur}
}

# Ajouter des lignes reliant les régions
for (i in seq_along(nb_collab_region$region_administrative_et1)) {
  region_administrative_et1 <- nb_collab_region$region_administrative_et1[i]
  region_administrative_et2 <- nb_collab_region$region_administrative_et2[i]
  longitude_et1 <-nb_collab_region$longitude_et1[i]
  latitude_et1 <- nb_collab_region$latitude_et1[i]
  longitude_et2 <-nb_collab_region$longitude_et2[i]
  latitude_et2 <- nb_collab_region$latitude_et2[i]
  # Obtenir le nombre d'interactions pour la paire de régions actuelle
  interactions <- nb_collab_region$nb_collab[i]
  # Calculer l'épaisseur de la ligne en fonction du nombre d'interactions
  weight <- get_weight(interactions) 
  map <- map %>%
    addPolylines(lng = c(longitude_et1, longitude_et2),
                 lat = c(latitude_et1, latitude_et2),
                 col = "blue",
                 weight =weight,
                 data=nb_collab_region)
    
}
map



#Télécharger et ouvrir les librairies nécessaires
library(htmlwidgets)
library(webshot)
library(ggplot2)

saveWidget(map, file = "figures/carte_liens.html", selfcontained = FALSE)
webshot("figures/carte_liens.html", file = "figures/carte_liens.png", vwidth = 800, vheight = 600)
