# descriptif_echantillon.R
library(dplyr)
library(ggplot2)
library(readr)
library(purrr)

# Charger les fonctions utilitaires
source("utils_descriptif.R")

# TRUE = sauvegarde des plots, FALSE = affichage seulement
SAVE <- TRUE
DIR = "plots_VI"

# creation des graphs des data de type Likert
vars_likert <- list(
  list(nom = "etat_percu", label = "État perçu"),
  list(nom = "sensibilite_sante", label = "Sensibilité santé"),
  list(nom = "importance_attachement", label = "Importance attachement"),
  list(nom = "authenticite_percue", label = "Authenticite percue")
)

walk(vars_likert, ~plot_likert(data, .$nom, label = .$label, save = SAVE, dir= DIR))

# Liste de configuration des variables catégorielles
vars_categorielle <- list(
  list(nom = "genre", label = "Genre", 
       levels = c("Femme", "Homme")),
  list(nom = "age", label = "Tranches d’âge", 
       levels = c("Moins de 25 ans", "25 à 34 ans", "35 à 44 ans", "45 à 54 ans", "55 ans et plus")),
  list(nom = "situation", label = "Situation familiale", 
       levels = c("Célibataire", "En couple sans enfant", "En couple avec enfant(s)", "Parent seul avec enfant(s)", "Autre / Ne souhaite pas répondre")),
  list(nom = "perception_sport", label = "Perception du sport", 
       levels = c("une contrainte", "plutôt une contrainte", "ni l’un ni l’autre", "plutôt un plaisir", "un plaisir")),
  list(nom = "csp", label = "Catégorie socio-professionnelle", 
       levels = c("Étudiant", "Agriculteur, ouvrier, employé", "Profession intermédiaire", "Cadre, profession libérale, chef d’entreprise", "Retraité, sans emploi, autre")),
  list(nom = "diplome", label = "Niveau de diplôme", 
       levels = c("Aucun diplôme / Niveau collège", "CAP / BEP / Niveau lycée (sans le bac)", "Baccalauréat ou équivalent", "Bac +2 ou plus (BTS, DUT, Licence, Master, Doctorat)", "Ne souhaite pas répondre")),
  list(nom = "pratique_sportive", label = "Fréquence de pratique sportive", 
       levels = c("Jamais", "Moins d’une fois par semaine", "1 à 2 fois par semaine", "3 à 4 fois par semaine", "5 fois ou plus par semaine")),
  list(nom = "relation_marques", label = "Relation aux marques",
       levels = c( "Une relation de méfiance", "Plutôt méfiante", "Neutre", "Plutôt confiante", "Une relation de confiance")),
  list(nom = "preferences_narative", label = "Préférence narrative",
       levels = c("Choquant et culpabilisant", "Un peu choquant",  "Neutre", "Valorisant un peu le lien social", "Valorisant le lien social"))
)


# Itération sur la liste pour générer tous les graphes
walk(vars_categorielle, function(x) {
  plot_categorielle(data, x$nom, label = x$label, levels = x$levels, save = SAVE, dir= DIR)
})

# Liste des variables VI catégorielles à explorer
vars_to_inspect <- c(
  "relation_marques",
  "preferences_narative",
  "importance_attachement",
  "authenticite_percue"
)

# Afficher les modalités triées pour chacune
#for (var in vars_to_inspect) {
#  cat(paste0("\n>>> ", var, " <<<\n"))
#  print(sort(unique(data[[var]])))
#}
