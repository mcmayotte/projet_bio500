read_data <- function() {
######################################################
# Script pour nettoyer et assembler les données
# Marie-Claude Mayotte, Ariane Barrette, Laurie-Anne Cournoyer & Mia Carrière
# 15 mars 2023
######################################################

#-----------------------------------------------------
# 1. Charger les données
#
# Assumant que les données sont sauvées dans le sous-répertoire data/raw
#-----------------------------------------------------
# Extraire le nom des fichers de chaque groupe

# Set le working directory au fichier "projet_bio500/data"
# setwd("/Users/marie-claudemayotte/Desktop/BIO500/projet_bio500")
allFiles <- dir('data/donnees_BIO500')


# Tables à fusioner
tabNames <- c('collaboration', 'cours','etudiant')

# Nombre de groupes
nbGroupe <- length(grep(tabNames[1], allFiles))

# Charger les donnees
for(tab in tabNames) {
  # prendre seulement les fichers de la table specifique `tab`
  tabFiles <- allFiles[grep(tab, allFiles)]
  
  for(groupe in 1:nbGroupe) {
    # Definir le nom de l'obj dans lequel sauver les donnees de la table `tab` du groupe `groupe`
    tabName <- paste0(tab, "_", groupe)
    
    # Avant  de charger les données, il faut savoir c'est quoi le séparateur utilisé car
    # il y a eu des données separées par "," et des autres separes par ";"
    ficher <- paste0('data/donnees_BIO500/', tabFiles[groupe])
    L <- readLines(ficher, n = 1) # charger première ligne du donnée
    separateur <- ifelse(grepl(';', L), ';', ',') # S'il y a un ";", separateur est donc ";"
    
    # charger le donnée avec le bon séparateur et donner le nom `tabName`
    assign(tabName, read.csv(ficher, sep = separateur, stringsAsFactors = FALSE, na.strings=c("", " ", "NA")))
    
  }
}

# nettoyer des objets temporaires utilisé dans la boucle
rm(list = c('allFiles', 'tab', 'tabFiles', 'tabName', 'ficher', 'groupe'))

#-----------------------------------------------------
# 2.1 Vérifier si les noms de colonnes sont standardisées
#-----------------------------------------------------

# Changer mauvais noms de colonnes
## Je comprend pas trop ce que la ligne 2 change parce que ça fonctionne même si je la roule pas
colnames(etudiant_4) <- c("prenom_nom", "prenom", "nom", "region_administrative", "regime_coop", "formation_prealable", "annee_debut", "programme")
colnames(cours_4)[which(colnames(cours_4)=="?..sigle")]<-"sigle"

# Supprimer les colones vides ou inutiles
collaboration_7 <- collaboration_7[,-c(5:9)]

cours_5 <- cours_5[,-4]
cours_7 <- cours_7[,-c(4:9)]

etudiant_3 <- etudiant_3[,-9]
etudiant_4 <- etudiant_4[,-9]
etudiant_7 <- etudiant_7[,-9]
etudiant_9 <- etudiant_9[,-9]

#-----------------------------------------------------
# 2.5 Fusionner les donnees de chaque groupe en un seul data.frame
#-----------------------------------------------------

collaboration <- rbind(collaboration_1,collaboration_10,collaboration_2,collaboration_3,collaboration_4,collaboration_5,collaboration_6,collaboration_7,collaboration_8,collaboration_9)
etudiant <- rbind(etudiant_1,etudiant_10,etudiant_2,etudiant_3,etudiant_4,etudiant_5,etudiant_6,etudiant_7,etudiant_8,etudiant_9)
cours <- rbind(cours_1,cours_10,cours_2,cours_3,cours_4,cours_5,cours_6,cours_7,cours_8,cours_9)

# Pour moins me perdre dans les 10 000 tableaux
rm(cours_1, cours_2, cours_3, cours_4, cours_5, cours_6, cours_7, cours_8, cours_9, cours_10, collaboration_1, collaboration_2, collaboration_3, collaboration_4, collaboration_5, collaboration_6, collaboration_7, collaboration_8, collaboration_9, collaboration_10, etudiant_1, etudiant_2, etudiant_3, etudiant_4, etudiant_5, etudiant_6, etudiant_7, etudiant_8, etudiant_9, etudiant_10)

# Supprimer les lignes vides
collaboration <- subset(collaboration, etudiant1 !="")
etudiant <- subset(etudiant, prenom_nom !="")
cours <- subset(cours, sigle !="")

# changer les VRAI et FAUX en TRUE et FALSE dans les tables cours et etudiants
cours$optionnel<- ifelse(cours$optionnel== "VRAI", "TRUE", cours$optionnel)
cours$optionnel<- ifelse(cours$optionnel== "FAUX", "FALSE", cours$optionnel)

etudiant$regime_coop <- ifelse(etudiant$regime_coop== "FAUX", "FALSE", etudiant$regime_coop)
etudiant$regime_coop <- ifelse(etudiant$regime_coop== "VRAI", "TRUE", etudiant$regime_coop)

#-----------------------------------------------------
# Vérifier si chacune des valeurs pour chaque colonne respecte le formatage
#-----------------------------------------------------
# Supprimer les lignes vides
collaboration <- subset(collaboration, etudiant1 !="")
etudiant <- subset(etudiant, prenom_nom !="")
cours <- subset(cours, sigle !="")

# changer les VRAI et FAUX en TRUE et FALSE dans les tables cours et etudiants
cours$optionnel<- ifelse(cours$optionnel== "VRAI", "TRUE", cours$optionnel)
cours$optionnel<- ifelse(cours$optionnel== "FAUX", "FALSE", cours$optionnel)

etudiant$regime_coop <- ifelse(etudiant$regime_coop== "FAUX", "FALSE", etudiant$regime_coop)
etudiant$regime_coop <- ifelse(etudiant$regime_coop== "VRAI", "TRUE", etudiant$regime_coop)

# Enlever lignes avec infos manquantes (Ya 6 colonnes qui ont pas de truc pour session donc on dit bye bye)
unique(collaboration$session)
collaboration <- subset(collaboration, session !="")

#-----------------------------------------------------
# Corriger erreurs de francais dans les noms
#-----------------------------------------------------
# enlever traits d'unions

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("-", "_", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("-", "_", x) }))

cours <- data.frame(lapply(cours, function(x){
  gsub("-", "_", x) }))

# Voir erreurs dans collaboration
unique(sort(collaboration$etudiant1))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("ariane_barette", "ariane_barrette", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("arianne_barette", "ariane_barrette", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("cassandra_gobin", "cassandra_godin", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("edouard_nadon_baumier", "edouard_nadon_beaumier", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("eve\xa0_dandonneau", "eve_dandonneau", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("francis_bolly", "francis_boily", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("francis_bourrassa", "francis_bourassa", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("frederick_laberge", "frederic_laberge", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("juliette_meilleur\xa0", "juliette_meilleur", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("justine_lebelle", "justine_labelle", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("laurianne_plante ", "laurianne_plante", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("louis_phillippe_theriault", "louis_philippe_theriault", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("mael_guerin", "mael_gerin", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("marie_burghin", "marie_bughin", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("mia_carriere\xa0", "mia_carriere", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("noemie_perrier_mallette", "noemie_perrier_malette", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("peneloppe_robert", "penelope_robert", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("philippe_barette", "philippe_barrette", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("phillippe_bourassa", "philippe_bourassa", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("philippe_bourrassa", "philippe_bourassa", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("raphael_charlesbois", "raphael_charlebois", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("sabrica_leclercq", "sabrina_leclercq", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("savier_samson", "xavier_samson", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("yanick_sagneau", "yannick_sageau", x) }))

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("yanick_sageau", "yannick_sageau", x) }))

# Voir erreurs dans etudiant
unique(sort(etudiant$prenom_nom))

#Corriger erreurs dans prenom_nom etudiant
etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("arianne_barette", "ariane_barrette", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("amelie_harbeck bastien", "amelie_harbeck_bastien", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("cassandra_gobin", "cassandra_godin", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("edouard_nadon_baumier", "edouard_nadon_beaumier", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("eve\xa0_dandonneau", "eve_dandonneau", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("francis_bolly", "francis_boily", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("juliette_meilleur\xa0", "juliette_meilleur", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("laurianne_plante ", "laurianne_plante", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("louis_phillippe_theriault", "louis_philippe_theriault", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("mael_guerin", "mael_gerin", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("marie_burghin", "marie_bughin", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("mia_carriere\xa0", "mia_carriere", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("peneloppe_robert", "penelope_robert", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("philippe_barette", "philippe_barrette", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("phillippe_bourassa", "philippe_bourassa", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("raphael_charlesbois", "raphael_charlebois", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("roxanne_bernier\t\t\t\t\t\t\t", "roxanne_bernier", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("sabrina_leclerc", "sabrina_leclercq", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("sabrina_leclercqq", "sabrina_leclercq", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("samule_fortin", "samuel_fortin", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("yanick_sagneau", "yannick_sageau", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("yanick_sageau", "yannick_sageau", x) }))

#-----------------------------------------------------
# Supprimer les lignes qui se répètent dans étudiant
#-----------------------------------------------------

# Faire un tableau avec les étudiant qui ont les infos supp
etudiant_info <- subset(etudiant, complete.cases(etudiant$region_administrative))

# Faire un tableau avec les étudiant qui n'ont pas les infos supp
etudiant_vide <- subset(etudiant, !complete.cases(etudiant$region_administrative))

# Voir si etudiant vide se trouve dans etudiant info et l'ajouter dans 9e col de etudiant vide
etudiant_vide$doublon <- is.element(etudiant_vide$prenom_nom, etudiant_info$prenom_nom)

#Enlever les TRUE puis enlever la colonne ajoutée
etudiant_vide <- subset(etudiant_vide, etudiant_vide$doublon != TRUE)
etudiant_vide <- etudiant_vide[,-9]

# Remettre les deux tableau ensemble
etudiant <- rbind(etudiant_info, etudiant_vide) 

rm(etudiant_info, etudiant_vide)

#-----------------------------------------------------
# Corriger erreurs dans cours (J'ai gardé les cours oblig a eco slm)
#-----------------------------------------------------

cours <- cours[!(cours$sigle=="BCM112" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="BCM113" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="BIO109" & cours$credits=="2"),]
cours <- cours[!(cours$sigle=="BIO401" & cours$optionnel=="FALSE"),]
cours <- cours[!(cours$sigle=="ECL215" & cours$optionnel=="FALSE"),]
cours <- cours[!(cours$sigle=="ECL315" & cours$optionnel=="FALSE"),]
cours <- cours[!(cours$sigle=="ECL406" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="ECL515" & cours$credits=="1"),]
cours <- cours[!(cours$sigle=="ECL522" & cours$optionnel=="FALSE"),]
cours <- cours[!(cours$sigle=="ECL527" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="ECL544" & cours$optionnel=="FALSE"),]
cours <- cours[!(cours$sigle=="ECL610" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="ECL611" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="INS154 "),]
cours <- cours[!(cours$sigle=="TSB303" & cours$optionnel=="TRUE"),]
cours <- cours[!(cours$sigle=="TSB303" & cours$credits=="1"),]
cours <- cours[!(cours$sigle=="ZOO304" & cours$optionnel=="FALSE"),]


#-----------------------------------------------------
# Supprimer lignes identiques dans collaboration et cours et etudiant
#-----------------------------------------------------

collaboration <- unique(collaboration[!duplicated(collaboration),])
cours <- unique(cours[!duplicated(cours),])
etudiant <- unique(etudiant[!duplicated(etudiant$prenom_nom),])
}
