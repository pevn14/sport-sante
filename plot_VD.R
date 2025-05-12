# descriptif_echantillon.R
library(dplyr)
library(ggplot2)
library(readr)
library(purrr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# TRUE = sauvegarde des plots, FALSE = affichage seulement
SAVE <- TRUE
DIR = "output/plots_VD"

# Charger les données nettoyées
data <- read_csv("data_clean.csv")

# creation des graphs des data de type Likert
vars_likert <- list(
  list(nom = "intention_pratique", label = "Intention de pratiquer une activité sportive"),
  list(nom = "engagement_cognitif", label = "Engagement cognitif"),
  list(nom = "intention_recommandation", label = "Intention de recommandation"),
  list(nom = "perception_ethique", label = "Perception de l’éthique du message"),
  list(nom = "perception_manipulation", label = "Perception de manipulation"),
  list(nom = "mefiance_marketing", label = "Scepticisme vis-à-vis du marketing"),
  list(nom = "saturation_publicitaire", label = "Saturation publicitaire ressentie"),
  list(nom = "adhesion_appartenance_h3", label = "Adhesion à une narration de type appartenance"),
  list(nom = "adhesion_choc_h3", label = "Adhesion à une narration de type choc")
  
)

walk(vars_likert, ~plot_likert(data, .$nom, label = .$label, save = SAVE, dir= DIR))

# Liste de configuration des variables catégorielles
vars_categorielle <- list(
  list(nom = "resonance_emotionnelle_h3", label = "Résonnance emotionelle (préférée)", levels = c("Aucune des deux", "Narration de type choc", "Narration de type appartenance", "Les deux")),
  list(nom = "alignement_valeurs_h3", label = "Alignement valeurs (préférée)", levels = c("Aucune des deux", "Narration de type choc", "Narration de type appartenance", "Les deux")),
  list(nom = "intention_pratique_h3", label = "Intention de pratique (préféré)", levels = c("Aucune des deux", "Narration de type choc", "Narration de type appartenance", "Les deux"))
)

# Itération sur la liste pour générer tous les graphes
walk(vars_categorielle, function(x) {
  plot_categorielle(data, x$nom, label = x$label, levels = x$levels, save = SAVE, dir= DIR)
})

# Liste des variables VI catégorielles à explorer
vars_to_inspect <- c(
  "resonance_emotionnelle_h3",
  "alignement_valeurs_h3",
  "intention_pratique_h3"
)

