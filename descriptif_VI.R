# descriptif_echantillon.R
library(dplyr)
library(ggplot2)
library(readr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# Charger les données nettoyées
data <- read_csv("data_clean.csv")

# Rediriger la sortie vers un fichier txt
sink("output/variables-independantes.txt", type = "output")

# I-Description de l’échantillon
cat("----------------------------------------\n")
cat("---- Variables indépendantes        ----\n")
cat("---- I-Description de l’échantillon ----\n")
cat("----------------------------------------\n")
# 1. Caractéristiques sociodémographiques
cat("==== Caractéristiques sociodémographiques ====\n")
afficher_categorielle(data$age, "Age")
afficher_categorielle(data$genre, "Genre")
afficher_categorielle(data$situation, "Situation familiale")
afficher_categorielle(data$csp, "Catégorie socio-professionnelle")
afficher_categorielle(data$diplome, "Diplôme")

# 2. Profil sportif
cat("\n==== Profil sportif ====\n")
afficher_categorielle(data$pratique_sportive, "Pratique sportive")
afficher_likert(data$etat_percu, "Etat perçu")

# 3. Sensibilité au bien-être et perception du sport
cat("\n==== Sensibilité au bien-être et perception du sport ====\n")
afficher_likert(data$sensibilite_sante, "Sensibilité sante")
afficher_categorielle(data$perception_sport, "Perception du sport")

sink()  # fin de redirection

