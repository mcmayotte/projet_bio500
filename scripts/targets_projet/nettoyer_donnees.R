read_data <- function() {

setwd("/Users/marie-claudemayotte/Desktop/BIO500/projet_bio500/data/donnees_BIO500")
allFiles <- dir()

tabNames <- c('collaboration', 'cours','etudiant')

nbGroupe <- length(grep(tabNames[1], allFiles))

for(tab in tabNames) {

  tabFiles <- allFiles[grep(tab, allFiles)]
  
  for(groupe in 1:nbGroupe) {
  
    tabName <- paste0(tab, "_", groupe)

    ficher <- paste0(tabFiles[groupe])
    L <- readLines(ficher, n = 1)
    separateur <- ifelse(grepl(';', L), ';', ',')
  
    assign(tabName, read.csv(ficher, sep = separateur, stringsAsFactors = FALSE, na.strings=c("", " ", "NA")))
    
  }
}

rm(list = c('allFiles', 'tab', 'tabFiles', 'tabName', 'ficher', 'groupe'))

colnames(etudiant_4) <- c("prenom_nom", "prenom", "nom", "region_administrative", "regime_coop", "formation_prealable", "annee_debut", "programme")
colnames(cours_4)[which(colnames(cours_4)=="?..sigle")]<-"sigle"

collaboration_7 <- collaboration_7[,-c(5:9)]

cours_5 <- cours_5[,-4]
cours_7 <- cours_7[,-c(4:9)]

etudiant_3 <- etudiant_3[,-9]
etudiant_4 <- etudiant_4[,-9]
etudiant_7 <- etudiant_7[,-9]
etudiant_9 <- etudiant_9[,-9]

collaboration <- rbind(collaboration_1,collaboration_10,collaboration_2,collaboration_3,collaboration_4,collaboration_5,collaboration_6,collaboration_7,collaboration_8,collaboration_9)
etudiant <- rbind(etudiant_1,etudiant_10,etudiant_2,etudiant_3,etudiant_4,etudiant_5,etudiant_6,etudiant_7,etudiant_8,etudiant_9)
cours <- rbind(cours_1,cours_10,cours_2,cours_3,cours_4,cours_5,cours_6,cours_7,cours_8,cours_9)

rm(cours_1, cours_2, cours_3, cours_4, cours_5, cours_6, cours_7, cours_8, cours_9, cours_10, collaboration_1, collaboration_2, collaboration_3, collaboration_4, collaboration_5, collaboration_6, collaboration_7, collaboration_8, collaboration_9, collaboration_10, etudiant_1, etudiant_2, etudiant_3, etudiant_4, etudiant_5, etudiant_6, etudiant_7, etudiant_8, etudiant_9, etudiant_10)

collaboration <- subset(collaboration, etudiant1 !="")
etudiant <- subset(etudiant, prenom_nom !="")
cours <- subset(cours, sigle !="")

cours$optionnel<- ifelse(cours$optionnel== "VRAI", "TRUE", cours$optionnel)
cours$optionnel<- ifelse(cours$optionnel== "FAUX", "FALSE", cours$optionnel)

etudiant$regime_coop <- ifelse(etudiant$regime_coop== "FAUX", "FALSE", etudiant$regime_coop)
etudiant$regime_coop <- ifelse(etudiant$regime_coop== "VRAI", "TRUE", etudiant$regime_coop)

collaboration <- subset(collaboration, etudiant1 !="")
etudiant <- subset(etudiant, prenom_nom !="")
cours <- subset(cours, sigle !="")

unique(collaboration$session)
collaboration <- subset(collaboration, session !="")

collaboration <- data.frame(lapply(collaboration, function(x){
  gsub("-", "_", x) }))

etudiant <- data.frame(lapply(etudiant, function(x){
  gsub("-", "_", x) }))

cours <- data.frame(lapply(cours, function(x){
  gsub("-", "_", x) }))

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

unique(sort(etudiant$prenom_nom))

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

etudiant_info <- subset(etudiant, complete.cases(etudiant$region_administrative))

etudiant_vide <- subset(etudiant, !complete.cases(etudiant$region_administrative))

etudiant_vide$doublon <- is.element(etudiant_vide$prenom_nom, etudiant_info$prenom_nom)

etudiant_vide <- subset(etudiant_vide, etudiant_vide$doublon != TRUE)
etudiant_vide <- etudiant_vide[,-9]

etudiant <- rbind(etudiant_info, etudiant_vide) 

rm(etudiant_info, etudiant_vide)

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

collaboration <- unique(collaboration[!duplicated(collaboration),])
cours <- unique(cours[!duplicated(cours),])
etudiant <- unique(etudiant[!duplicated(etudiant$prenom_nom),])
}