reseau<-function(req_sql) {
  #Télécharger les library nécessaires

library(igraph)
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

#notre préféré
png("figures/visualisation.png",600,600)
plot(g,vertex.label = NA, edge.arrow.mode = 0,
     vertex.frame.color = NA,
     layout = layout.kamada.kawai(g))
dev.off()
ggsave("figures/visualisation.png", plot=w,device = "png", dpi=300) #ça l'enregistre un fond blanc

#Différentes options de graphiques
plot(g, vertex.label=NA, edge.arrow.mode = 0,
     vertex.frame.color = NA)


#graph cercle

plot(g, vertex.label=NA, edge.arrow.mode = 0,
     vertex.frame.color = NA,
     layout = layout.circle(g))

plot(g, vertex.label=NA,edge.arrow.mode = 0,
     vertex.frame.color = NA)
#Enregistrer la figure

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
