# Script R : descriptif vers Markdown

library(dplyr)
library(readr)

# Charger les données
data <- read_csv("data_clean.csv")

# Charger les fonctions utilitaires
source("utils_descriptif.R")


# Rediriger la sortie vers un fichier .md
sink("descriptif_echantillon.md", type = "output")

cat("# Descriptif de l’échantillon\n\n")

cat("## 1. Caractéristiques sociodémographiques\n")
afficher_categorielle_md(data$genre, "Genre")
afficher_categorielle_md(data$situation, "Situation familiale")
afficher_categorielle_md(data$csp, "Catégorie socio-professionnelle")
afficher_categorielle_md(data$diplome, "Diplôme")

cat("## 2. Profil sportif\n")
afficher_categorielle_md(data$pratique_sportive, "Pratique sportive")
afficher_likert_md(data$etat_percu, "État perçu")

cat("## 3. Sensibilité au bien-être et perception du sport\n")
afficher_likert_md(data$sensibilite_sante, "Sensibilité à la santé")
afficher_categorielle_md(data$perception_sport, "Perception du sport")

sink()  # fin de redirection
