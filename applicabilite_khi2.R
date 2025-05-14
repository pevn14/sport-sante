# -------------------------------------------------------------------
# VÉRIFICATION DE L’APPLICABILITÉ DU KHI² OU FISHER
# AVEC COMPARAISON EFFECTIFS OBSERVÉS / ATTENDUS
# -------------------------------------------------------------------

library(tidyverse)
library(openxlsx)

# Charger les données
df <- read.csv("data_clean.csv")

# Liste des paires nominales H3 à tester (exemples, à adapter selon ton fichier)
nominal_pairs <- list(
  c("genre", "resonance_emotionnelle_h3"),
  c("genre", "engagement_emotionnel_h3"),
  c("genre", "alignement_valeurs_h3"),
  c("genre", "estime_de_soi_h3"),
  c("genre", "intention_pratique_h3"),
  
  c("situation", "resonance_emotionnelle_h3"),
  c("situation", "engagement_emotionnel_h3"),
  c("situation", "alignement_valeurs_h3"),
  c("situation", "estime_de_soi_h3"),
  c("situation", "intention_pratique_h3"),
  
  c("csp", "resonance_emotionnelle_h3"),
  c("csp", "engagement_emotionnel_h3"),
  c("csp", "alignement_valeurs_h3"),
  c("csp", "estime_de_soi_h3"),
  c("csp", "intention_pratique_h3"),
  
  c("diplome", "resonance_emotionnelle_h3"),
  c("diplome", "engagement_emotionnel_h3"),
  c("diplome", "alignement_valeurs_h3"),
  c("diplome", "estime_de_soi_h3"),
  c("diplome", "intention_pratique_h3"),
  
  c("resonance_emotionnelle_h3", "alignement_valeurs_h3"),
  c("resonance_emotionnelle_h3", "estime_de_soi_h3"),
  c("resonance_emotionnelle_h3", "intention_pratique_h3"),
  c("engagement_emotionnel_h3", "alignement_valeurs_h3"),
  c("engagement_emotionnel_h3", "estime_de_soi_h3"),
  c("engagement_emotionnel_h3", "intention_pratique_h3")
)

# Initialisation du tableau de résultats
check_results <- data.frame()

# Boucle sur les paires
for (pair in nominal_pairs) {
  var1 <- pair[1]
  var2 <- pair[2]
  
  tab <- table(df[[var1]], df[[var2]])
  n_total <- sum(tab)
  min_observe <- min(tab)
  
  # Effectifs attendus
  expected <- suppressWarnings(chisq.test(tab)$expected)
  min_expected <- ifelse(length(expected) > 0, min(expected), NA)
  
  # Conditions
  khi2_ok <- !any(is.na(expected)) && all(expected >= 5) && n_total >= 30
  test_suggere <- if (khi2_ok) "khi²" else "Fisher"
  
  # Enregistrement des résultats
  check_results <- rbind(check_results, data.frame(
    Variable_1 = var1,
    Variable_2 = var2,
    #Effectif_total = n_total,
    Min_effectif_observe = min_observe,
    Min_effectif_attendu = round(min_expected, 2),
    Test_applicable = test_suggere
  ))
}

# Affichage
#print(check_results)

write.xlsx(check_results, file = "output/khi2_fisher_applicabilite.xlsx", rowNames = FALSE)

