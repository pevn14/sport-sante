# -------------------------------------------------------------------
# TESTS KRUSKAL-WALLIS SPÉCIFIQUES POUR LES LIENS NON TESTÉS DE H3
# + CALCUL DES DEGRÉS DE LIBERTÉ (ddl = k - 1)
# -------------------------------------------------------------------

library(tidyverse)
library(openxlsx)

# Charger les données
df <- read.csv("data_clean.csv")

# Définir les paires à tester
kruskal_pairs <- list(
  c("resonance_emotionnelle_h3", "receptivite_h3"),
  c("alignement_valeurs_h3", "receptivite_h3"),
  c("alignement_valeurs_h3", "adhesion_choc_h3"),
  c("alignement_valeurs_h3", "adhesion_appartenance_h3"),
  c("estime_de_soi_h3", "adhesion_choc_h3"),
  c("estime_de_soi_h3", "adhesion_appartenance_h3")
)

# Initialiser tableau résultats
kruskal_results <- data.frame()

# Boucle de test
for (pair in kruskal_pairs) {
  vi <- pair[1]
  vd <- pair[2]
  
  # Nettoyage des NA
  sub_data <- df[, c(vi, vd)] %>% drop_na()
  
  # Nombre de groupes (modalités de la variable indépendante)
  k <- length(unique(sub_data[[vi]]))
  
  if (k >= 2) {
    test <- kruskal.test(sub_data[[vd]] ~ as.factor(sub_data[[vi]]))
    kruskal_results <- rbind(kruskal_results, data.frame(
      Variable_1 = vi,
      Variable_2 = vd,
      ddl = k - 1,
      Statistique = as.numeric(test$statistic),
      p_value = test$p.value,
      Significatif = ifelse(test$p.value < 0.05, "Oui", "Non")
    ))
  }
}

# Trier par p-value
kruskal_results <- kruskal_results %>% arrange(p_value)

# Export Excel
wb <- createWorkbook()
addWorksheet(wb, "H3_complement")
writeData(wb, "H3_complement", kruskal_results)
saveWorkbook(wb, "output/kruskal_H3_complement_with_ddl.xlsx", overwrite = TRUE)

# Aperçu console
print(kruskal_results)
