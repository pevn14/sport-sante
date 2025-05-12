# -------------------------------------------------------------------
# TESTS DE CORRÉLATION DE SPEARMAN (ρ) ENTRE VARIABLES DE TYPE LIKERT
#
# Objectif :
# Mesurer la force et la direction de l'association monotone entre
# deux variables ordinales (typiquement issues d'échelles de Likert).
#
# Pourquoi Spearman ?
# Les variables issues d'échelles de Likert ne suivent généralement
# pas une distribution normale (test de Shapiro-Wilk => p < 0.05).
# Le test de Pearson n’est donc pas adapté.
# Le test de Spearman est non paramétrique et mesure la corrélation
# sur les rangs, ce qui le rend robuste aux distributions non normales.
#
# Interprétation du coefficient rho (ρ) :
# - ρ ≈ +1 : forte corrélation monotone positive
# - ρ ≈ -1 : forte corrélation monotone négative
# - ρ ≈  0 : absence d'association monotone
#
# Interprétation de la p-value :
# - p ≤ 0.05 : corrélation statistiquement significative au seuil de 5 %
# - p > 0.05 : pas de corrélation détectée de manière significative
#
# ⚠ Attention :
# - p > 0.05 ne signifie pas qu’il n’y a aucun lien.
#   Cela signifie simplement qu’avec les données disponibles,
#   on ne peut pas rejeter l’hypothèse d’absence de corrélation.
# - Toujours interpréter les résultats dans le contexte de l’étude.
#
# Application ici :
# On applique le test de Spearman entre les variables VM (réceptivité,
# émotion...) et VD (intention, engagement...) liées à H1, et éventuellement
# avec certaines VI ordinales comme "etat_percu".
# -------------------------------------------------------------------

# Charger les packages
library(tidyverse)
library(openxlsx)

# Charger les données
df <- read.csv("data_clean.csv")

# Variables liées à H1 (VI, VM et VD)
vi_h1 <- c("age_num", "pratique_sportive_num", "perception_sport_num", "etat_percu", "sensibilite_sante")
vm_h1 <- c("receptivite", "engagement_emotionnel")
vd_h1 <- c("intention_pratique", "engagement_cognitif", "intention_recommandation")

# === Variables liées à H2 ===
vi_h2 <- c("age_num", "pratique_sportive_num", "perception_sport_num", "relation_marques_num", "etat_percu", "sensibilite_sante")
vm_h2 <- c("authenticite_percue", "alignement_valeur")
vd_h2 <- c("perception_ethique", "perception_manipulation", "mefiance_marketing", "saturation_publicitaire")

# === Variables liées à H3 ===
vi_h3 <- c("age_num", "pratique_sportive_num", "perception_sport_num", "preferences_narative_num", "etat_percu", "importance_attachement")
vm_h3 <- c("receptivite_h3")
vd_h3 <- c("adhesion_appartenance_h3", "adhesion_choc_h3")


# === Fonction qui retourne un dataframe de résultats
run_spearman_model_df <- function(vi, vm, vd) {
  results <- data.frame()
  
  # VI → VM
  for (v1 in vi) {
    for (v2 in vm) {
      test <- cor.test(df[[v1]], df[[v2]], method = "spearman", exact = FALSE)
      results <- rbind(results, data.frame(
        Variable_1 = v1,
        Variable_2 = v2,
        Spearman_rho = test$estimate,
        p_value = test$p.value,
        Significatif = ifelse(test$p.value < 0.05, "Oui", "Non"),
        Lien = "VI → VM"
      ))
    }
  }
  
  # VI → VD
  for (v1 in vi) {
    for (v2 in vd) {
      test <- cor.test(df[[v1]], df[[v2]], method = "spearman", exact = FALSE)
      results <- rbind(results, data.frame(
        Variable_1 = v1,
        Variable_2 = v2,
        Spearman_rho = test$estimate,
        p_value = test$p.value,
        Significatif = ifelse(test$p.value < 0.05, "Oui", "Non"),
        Lien = "VI → VD"
      ))
    }
  }
  
  # VM → VD
  for (v1 in vm) {
    for (v2 in vd) {
      test <- cor.test(df[[v1]], df[[v2]], method = "spearman", exact = FALSE)
      results <- rbind(results, data.frame(
        Variable_1 = v1,
        Variable_2 = v2,
        Spearman_rho = test$estimate,
        p_value = test$p.value,
        Significatif = ifelse(test$p.value < 0.05, "Oui", "Non"),
        Lien = "VM → VD"
      ))
    }
  }
  
  return(results %>% arrange(p_value))
}

# Générer les trois jeux de résultats
res_h1 <- run_spearman_model_df(vi_h1, vm_h1, vd_h1)
res_h2 <- run_spearman_model_df(vi_h2, vm_h2, vd_h2)
res_h3 <- run_spearman_model_df(vi_h3, vm_h3, vd_h3)

# Écriture dans un fichier Excel avec onglets séparés
wb <- createWorkbook()
addWorksheet(wb, "H1")
addWorksheet(wb, "H2")
addWorksheet(wb, "H3")

writeData(wb, sheet = "H1", res_h1)
writeData(wb, sheet = "H2", res_h2)
writeData(wb, sheet = "H3", res_h3)

saveWorkbook(wb, "output/spearman_correlations_H1_H2_H3.xlsx", overwrite = TRUE)