# Importer la bibliothèque
library(leaflet)

# Charger les données du réseau de connexion étudiant
nb_paire_colla

# Charger la carte
map <- leaflet() %>%
  setView(lng = -74.010742, lat = 46.763033, zoom = 5.1) %>%
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
# Ajouter les lignes pour les connexions À MODIFIER
map <- map %>%
  addPolylines(data = nb_paire_colla,
               lng = ~c(longitude_start, longitude_end),
               lat = ~c(latitude_start, latitude_end),
               color = "red",
               weight = 2)