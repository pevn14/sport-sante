# lancer le script par source("descriptif_VI.R", echo = FALSE)
# pour eviter la presence des lignes de code dans le fichier d'output
# descriptif_echantillon.R
library(dplyr)
library(ggplot2)
library(readr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# Charger les données nettoyées
data <- read_csv("data_clean.csv")

# Rediriger la sortie vers un fichier txt
sink("output/descriptif-VI.txt", type = "output")

cat("---------------------------------------\n")
cat("Rapport généré le :", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("---------------------------------------\n\n")

# I-Descriptif de l’échantillon
cat("---------------------------------------\n")
cat("---- Variables indépendantes       ----\n")
cat("---- I-Descriptif de l’échantillon ----\n")
cat("---------------------------------------\n")
# 1. Caractéristiques sociodémographiques
cat("==== Caractéristiques sociodémographiques ====\n")
afficher_categorielle(data$age, "Age")
afficher_categorielle(data$genre, "Genre")
afficher_categorielle(data$situation, "Situation familiale")
afficher_categorielle(data$csp, "Catégorie socio-professionnelle")
afficher_categorielle(data$diplome, "Diplôme")

# 2. Profil sportif et santé
cat("\n==== Profil sportif et santé ====\n")
afficher_categorielle(data$pratique_sportive, "Pratique sportive")
afficher_likert(data$etat_percu, "Etat perçu")

# II-Variable indépendante propres à l'étude 
cat("\n")
cat("----------------------------------------\n")
cat("---- Variables indépendantes        ----\n")
cat("---- II- VI propres à l'étude       ----\n")
cat("----------------------------------------\n")

# 1. Attitudes vis à vis du sport et du bien-être
cat("\n==== Attitudes vis à vis du sport et du bien-être ====\n")
afficher_likert(data$sensibilite_sante, "Sensibilité sante")
afficher_categorielle(data$perception_sport, "Perception du sport")

# 2. Attitudes vis à vis des annonceurs
cat("\n==== Attitudes vis à vis des annonceurs ====\n")
afficher_likert(data$importance_attachement, "Niveau d’attachement à une communauté")
afficher_categorielle(data$preferences_narative, "Préférences narratives en communication")
afficher_categorielle(data$relation_marques, "Relation aux marques et à leur communication")


sink()  # fin de redirection

