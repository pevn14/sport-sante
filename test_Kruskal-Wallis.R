# -------------------------------------------------------------------
# TESTS DE KRUSKAL-WALLIS POUR H1, H2, H3 (AVEC DEGRÉS DE LIBERTÉ)
#
# Objectif :
# Tester l'effet des variables VI nominales sur les VD ou VM ordinales.
# Ajouter les ddl (k - 1) pour chaque test afin d'interpréter la statistique.
# -------------------------------------------------------------------

library(tidyverse)
library(openxlsx)

# Charger les données
df <- read.csv("data_clean.csv")

# === Définir les variables ===

# Variables VI nominales (non recodées)
vi_nominales_h1 <- c("genre", "situation", "csp", "diplome")
vi_nominales_h2 <- c("genre", "situation", "csp", "diplome")
vi_nominales_h3 <- c("genre", "situation", "csp", "diplome")

# Variables VM et VD ordinales
vm_h1 <- c("receptivite", "engagement_emotionnel")
vd_h1 <- c("intention_pratique", "engagement_cognitif", "intention_recommandation")

vm_h2 <- c("authenticite_percue", "alignement_valeur")
vd_h2 <- c("perception_ethique", "perception_manipulation", "mefiance_marketing", "saturation_publicitaire")

vm_h3 <- c("receptivite_h3")
vd_h3 <- c("adhesion_appartenance_h3", "adhesion_choc_h3")

# === Fonction modifiée avec DDL ===
run_kruskal_model_df <- function(vi, vm, vd) {
  results <- data.frame()
  
  # VI → VM
  for (v1 in vi) {
    for (v2 in vm) {
      sub_data <- df[, c(v1, v2)] %>% drop_na()
      k <- length(unique(sub_data[[v1]]))
      if (k >= 2) {
        test <- kruskal.test(sub_data[[v2]] ~ as.factor(sub_data[[v1]]))
        results <- rbind(results, data.frame(
          Variable_1 = v1,
          Variable_2 = v2,
          ddl = k - 1,
          Statistique = as.numeric(test$statistic),
          p_value = test$p.value,
          Significatif = ifelse(test$p.value < 0.05, "Oui", "Non"),
          Lien = "VI → VM"
        ))
      }
    }
  }
  
  # VI → VD
  for (v1 in vi) {
    for (v2 in vd) {
      sub_data <- df[, c(v1, v2)] %>% drop_na()
      k <- length(unique(sub_data[[v1]]))
      if (k >= 2) {
        test <- kruskal.test(sub_data[[v2]] ~ as.factor(sub_data[[v1]]))
        results <- rbind(results, data.frame(
          Variable_1 = v1,
          Variable_2 = v2,
          ddl = k - 1,
          Statistique = as.numeric(test$statistic),
          p_value = test$p.value,
          Significatif = ifelse(test$p.value < 0.05, "Oui", "Non"),
          Lien = "VI → VD"
        ))
      }
    }
  }
  
  return(results %>% arrange(p_value))
}

# === Générer les résultats pour H1, H2, H3
res_h1 <- run_kruskal_model_df(vi_nominales_h1, vm_h1, vd_h1)
res_h2 <- run_kruskal_model_df(vi_nominales_h2, vm_h2, vd_h2)
res_h3 <- run_kruskal_model_df(vi_nominales_h3, vm_h3, vd_h3)

# === Export Excel
wb <- createWorkbook()
addWorksheet(wb, "H1")
addWorksheet(wb, "H2")
addWorksheet(wb, "H3")

writeData(wb, sheet = "H1", res_h1)
writeData(wb, sheet = "H2", res_h2)
writeData(wb, sheet = "H3", res_h3)

saveWorkbook(wb, "output/kruskal_H1_H2_H3_with_ddl.xlsx", overwrite = TRUE)
