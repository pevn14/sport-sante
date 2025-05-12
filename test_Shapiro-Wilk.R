# ---------------------------------------------------------------
# Test de normalité de Shapiro-Wilk
#
# H0 : la variable suit une distribution normale
# H1 : la variable ne suit pas une distribution normale
#
# Interprétation de la p-value :
# - Si p > 0.05 : on ne rejette pas H0 → distribution considérée comme normale
# - Si p ≤ 0.05 : on rejette H0 → distribution considérée comme non normale
#
# Remarques :
# - Le test est sensible à la taille de l’échantillon : 
#   avec un grand n, même de légères déviations de la normalité peuvent donner p < 0.05
# - Il est utile de compléter par des visualisations : histogrammes, Q-Q plots
#
# La statistique W (W-statistic) du test de Shapiro-Wilk :
# - Va de 0 à 1
# - Plus W est proche de 1, plus la distribution est proche de la normale
# - Mais c’est la p-value associée qui permet de trancher sur la normalité :
#     p > 0.05 → distribution considérée comme normale
#     p ≤ 0.05 → distribution considérée comme non normale
# ---------------------------------------------------------------

# Charger les packages nécessaires
library(tidyverse)

# Charger les données
df <- read.csv("data_clean.csv")

# Fonction pour détecter les colonnes Likert (valeurs entières entre 1 et 5)
is_likert <- function(col) {
  is.numeric(col) && all(na.omit(col) %in% 1:5)
}

# Sélection des colonnes Likert
likert_vars <- df %>% select(where(is_likert))

# Appliquer le test de Shapiro-Wilk à chaque variable
shapiro_results <- lapply(likert_vars, function(x) shapiro.test(x))

# Construire un tableau avec les résultats
shapiro_df <- tibble(
  variable = names(shapiro_results),
  W_statistic = sapply(shapiro_results, function(res) res$statistic),
  p_value = sapply(shapiro_results, function(res) res$p.value),
  normality = ifelse(sapply(shapiro_results, function(res) res$p.value) > 0.05, 
                     "Normale", "Non normale")
)

# Afficher les résultats
print(shapiro_df)

# Exporter les résultats du test Shapiro-Wilk dans un fichier texte
write.csv(shapiro_df,
            file = "output/shapiro_wilk_results.csv",
            row.names = FALSE)
