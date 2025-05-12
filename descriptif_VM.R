# lancer le script par source("descriptif_VM.R", echo = FALSE)
# pour eviter la presence des lignes de code dans le fichier d'output

library(dplyr)
library(ggplot2)
library(readr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# Charger les données nettoyées
data <- read_csv("data_clean.csv")

# Rediriger la sortie vers un fichier txt
sink("output/descriptif-VM.txt", type = "output")

cat("---------------------------------------\n")
cat("Rapport généré le :", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("---------------------------------------\n\n")

cat("---------------------------------------\n")
cat("---- Variables mediatrices         ----\n")
cat("---- I-Variables liées à H1        ----\n")
cat("---------------------------------------\n")
cat("\n==== Reception et perception du message ====")
afficher_likert(data$receptivite, "Receptivité au message")

cat("\n==== Réaction émotionnelle ====")
afficher_likert(data$engagement_emotionnel, "Engagement émotionnel")

cat("---------------------------------------\n")
cat("---- Variables mediatrices         ----\n")
cat("---- II-Variables liées à H2       ----\n")
cat("---------------------------------------\n")
cat("\n==== Reception et perception du message ====")
afficher_likert(data$authenticite_percue, "Authenticité perçue du message")

cat("\n==== Identification au message ====")
afficher_likert(data$alignement_valeur, "Alignement valeurs marque / message")

cat("---------------------------------------\n")
cat("---- Variables mediatrices         ----\n")
cat("---- III-Variables liées à H3      ----\n")
cat("---------------------------------------\n")
cat("\n==== Réaction émotionnelle ====")
afficher_categorielle(data$engagement_emotionnel_h3, "Engagement émotionnel")
afficher_categorielle(data$estime_de_soi_h3, "Estime de soi activée par le message")

sink()  # fin de redirection

