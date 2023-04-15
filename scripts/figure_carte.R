# Importer la bibliothèque
library(leaflet)

# Charger les données du réseau de connexion étudiant
nb_collab_region
nb_collab_region_full<-subset(nb_collab_region,region_administrative_et1 !="NA")
nb_collab_region_full<-subset(nb_collab_region_full,region_administrative_et2 !="NA")
etudiants_coordo

# Charger la carte
map <- leaflet() %>%
  setView(lng = -74.010742, lat = 46.763033, zoom = 5.7) %>%
  addTiles()
map
# Ajouter les marqueurs pour les étudiants
map <- map %>%
  addCircleMarkers(data = etudiants_coordo, 
             lng = ~longitude, 
             lat = ~latitude,
             popup = ~prenom_nom,
             radius=1)
map

# Ajouter des lignes reliant les régions
for (i in seq_along(nb_collab_region_full$region_administrative_et1)) {
  region_administrative_et1 <- nb_collab_region_full$region_administrative_et1[i]
  region_administrative_et2 <- nb_collab_region_full$region_administrative_et2[i]
  longitude_et1 <-nb_collab_region_full$longitude_et1[i]
  latitude_et1 <- nb_collab_region_full$latitude_et1[i]
  longitude_et2 <-nb_collab_region_full$longitude_et2[i]
  latitude_et2 <- nb_collab_region_full$latitude_et2[i]
  
  map <- map %>%
    addPolylines(lng = c(longitude_et1, longitude_et2),
                 lat = c(latitude_et1, latitude_et2),
                 color="blue",
                 weight=1)
}
map

#Télécharger et ouvrir les librairies nécessaires
library(htmlwidgets)
library(webshot)

saveWidget(map, file = "figures/carte_liens.html", selfcontained = FALSE)
webshot("figures/carte_liens.html", file = "figures/carte_liens.png", vwidth = 800, vheight = 600)
