# lancer le script par source("descriptif_VD.R", echo = FALSE)
# pour eviter la presence des lignes de code dans le fichier d'output

library(dplyr)
library(ggplot2)
library(readr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# Charger les données nettoyées
data <- read_csv("data_clean.csv")

# Rediriger la sortie vers un fichier txt
sink("output/descriptif-VD.txt", type = "output")

cat("---------------------------------------\n")
cat("Rapport généré le :", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("---------------------------------------\n\n")

cat("---------------------------------------\n")
cat("---- Variables dépendantes         ----\n")
cat("---- I-Variables liées à H1        ----\n")
cat("---------------------------------------\n")
cat("\n==== Attitudes et intention ====")
afficher_likert(data$intention_pratique, "Intention de pratiquer une activité sportive")
afficher_likert(data$engagement_cognitif, "Engagement cognitif")
afficher_likert(data$intention_recommandation, "Intention de recommandation")

cat("---------------------------------------\n")
cat("---- Variables dépendantes         ----\n")
cat("---- II-Variables liées à H2       ----\n")
cat("---------------------------------------\n")
cat("\n==== Perception et réaction ====")
afficher_likert(data$perception_ethique, "Perception de l’éthique du message")
afficher_likert(data$perception_manipulation, "Perception de manipulation")
afficher_likert(data$mefiance_marketing, "Scepticisme vis-à-vis du marketing")
afficher_likert(data$saturation_publicitaire, "Saturation publicitaire ressentie")

cat("---------------------------------------\n")
cat("---- Variables dépendantes         ----\n")
cat("---- III-Variables liées à H3      ----\n")
cat("---------------------------------------\n")
cat("\n==== Réaction émotionnelle ====")
afficher_categorielle(data$resonance_emotionnelle_h3, "Résonance émotionnelle")
afficher_categorielle(data$alignement_valeurs_h3, "Alignement personnel avec les valeurs")
afficher_categorielle(data$intention_pratique_h3, "Intention de pratiquer une activité sportive")
afficher_likert(data$adhesion_appartenance_h3, "Adhesion à une narration de type appartenance")
afficher_likert(data$adhesion_choc_h3, "Adhesion à une narration de type choc")

sink()  # fin de redirection

