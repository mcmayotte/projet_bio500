barplot_fig <- function (con) {
######################################################
# Script pour créer les barplots de nombre moyens de collaboration
# Marie-Claude Mayotte, Ariane Barrette, Laurie-Anne Cournoyer & Mia Carrière
# 18 avril 2023
######################################################

moy_collab_form <- req_sql[[2]]
moy_collab_annee <- req_sql [[1]]

# Packages
library(gplots)

#-----------------------------------------------------
# nb moyen de collaboration ~ formation préalable

# Enlever la ligne des étudiants qui ne sont pas dans le cours 
moy_collab_form <- subset(moy_collab_form, moy_collab_form$formation_prealable != "NA")

# Barplot avec écarts-types
barplot2(moy_collab_form$moy_collab, beside =T, ci.u = moy_collab_form$moy_collab + moy_collab_form$ecart_type, ci.l = moy_collab_form$moy_collab - moy_collab_form$ecart_type, plot.ci = T, 
         col = c("lightblue", "mistyrose", "lightcyan"), 
         names.arg = moy_collab_form$formation_prealable, 
         xlab = "Formation préalable", ylab = "Nombre moyen de collaborations",
         ylim = c(0,80))

# Ajouter une légende
# legend("topright", legend = moy_collab_form$formation_prealable, fill = col, border = NA, cex = 0.8)

#Enregistrer la figure
png("figures/barplot_formation.png")

#-----------------------------------------------------
# nb moyen de collaboration ~ annee de début
#-----------------------------------------------------

# Enlever la ligne des étudiants qui ne sont pas dans le cours 
moy_collab_annee <- subset(moy_collab_annee, moy_collab_annee$annee_debut != "NA")

# Barplot avec écart-tpes
barplot2(moy_collab_annee$moy_collab, beside =T, ci.u = moy_collab_annee$moy_collab + moy_collab_annee$ecart_type, ci.l = moy_collab_annee$moy_collab - moy_collab_annee$ecart_type, plot.ci = T, 
         col = c("lightblue", "mistyrose", "lightcyan"), 
         names.arg = moy_collab_annee$annee_debut, 
         xlab = "Année de début", ylab = "Nombre moyen de collaborations",
         ylim = c(0,70))

#Enregistrer la figure
png("figures/barplot_annee.png")
}
