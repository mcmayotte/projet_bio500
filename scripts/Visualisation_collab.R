reseau<-function(req_sql) {
  #Télécharger les library nécessaires

library(igraph)
library(fields)
# Créer la matrice
r<-nrow(etudiant)
matrice_interact <- matrix(0, nr = r, nc = r)
noms<-etudiant[, 1]

# Attribuer les noms de colonnes et de lignes à la matrice
colnames(matrice_interact)<-noms
rownames(matrice_interact)<-noms

# Créer une boucle pour insérer des 1 quand les deux étudiants ont eu une interaction
n<-nrow(nb_paire_colla)
for (i in 1:n){
  if (nb_paire_colla[i,3]>0) {
  matrice_interact[nb_paire_colla[i,1],nb_paire_colla[i,2]]<-1 }
}  
# Créer un objet igraph
g <- graph.adjacency(matrice_interact)
deg <- apply(matrice_interact, 2, sum) + apply(matrice_interact, 1, sum)
# Le rang pour chaque noeud
rk <- rank(deg)
# Faire un code de couleur
col.vec <- heat.colors(r)
# Attribuer aux noeuds la couleur
V(g)$color = col.vec[rk]
#Taille
col.vec <- seq(1, 5, length.out = r)
# Attribuer aux noeuds la couleur
V(g)$size = col.vec[rk]

#Réalisation de la figure                     ##NE PAS RUN LA LIGNE 36 ET LA LIGNE 52 SI L'ON SOUHAITE VISUALISER LA FIGURE
png("figures/visualisation.png",600,600)
plot(g,vertex.label = NA, edge.arrow.mode = 0,
     vertex.frame.color = NA,
     layout = layout.kamada.kawai(g))

# Définir le gradient de couleur pour la légende
color_gradient <- colorRampPalette(heat.colors(r))(100)

# Définir le range de couleur
color_range <- range(1:r)

# Ajouter la légende et un titre de figure
par(mar=c(5,4,4,8))
image.plot(legend.only = TRUE, horizontal=TRUE, zlim=color_range,col=color_gradient)
title("Réseau d'interactions entre les étudiants", line = 1, cex.main = 1.2)
mtext("Rang des étudiants", side = 1, line = 1, cex = 1)
dev.off()

#Calcul de propriétés
# Évalue la présence communautés dans le graphe
wtc = walktrap.community(g)
# Calcule la modularité à partir des communautés
modularity(wtc)
#distance entre les noeuds
distances(g)
#centralité des noeuds
eigen_centrality(g)$vector
}
