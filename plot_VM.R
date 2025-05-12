# descriptif_echantillon.R
library(dplyr)
library(ggplot2)
library(readr)
library(purrr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# TRUE = sauvegarde des plots, FALSE = affichage seulement
SAVE <- TRUE
DIR = "output/plots_VM"

# Charger les données nettoyées
data <- read_csv("data_clean.csv")

# creation des graphs des data de type Likert
vars_likert <- list(
  list(nom = "authenticite_percue", label = "Authenticite percue"),
  list(nom = "receptivite", label = "Receptivité au message"),
  list(nom = "receptivite_h3", label = "Receptivité aux messages"),
  list(nom = "engagement_emotionnel", label = "Engagement émotionnel"),
  list(nom = "alignement_valeur", label = "Alignement valeurs marque / message")
)

walk(vars_likert, ~plot_likert(data, .$nom, label = .$label, save = SAVE, dir= DIR))

# Liste de configuration des variables catégorielles
vars_categorielle <- list(
  list(nom = "estime_de_soi_h3", label = "Estime de soi (Vidéo préférée)", levels = c("Aucune des deux", "Narration de type choc", "Narration de type appartenance", "Les deux")),
  list(nom = "engagement_emotionnel_h3", label = "Engagement émotionnel (Vidéo préféré)", levels = c("Aucune des deux", "Narration de type choc", "Narration de type appartenance", "Les deux"))
)

# Itération sur la liste pour générer tous les graphes
walk(vars_categorielle, function(x) {
  plot_categorielle(data, x$nom, label = x$label, levels = x$levels, save = SAVE, dir= DIR)
})

# Liste des variables VI catégorielles à explorer
vars_to_inspect <- c(
  "estime_de_soi_h3",
  "engagement_emotionnel_h3"
)

