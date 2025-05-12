# -------------------------------------------------------------------
# TEST EXACT DE FISHER + EXPORT EN FICHIER EXCEL
# -------------------------------------------------------------------

library(tidyverse)
library(openxlsx)

# Charger les données (à adapter si tu as déjà le DataFrame 'df' et 'check_results' en mémoire)
df <- read.csv("data_clean.csv")

# check_results doit contenir : Variable_1, Variable_2, Test_applicable
# Exemple : check_results <- read.csv("output/chi2_fisher_applicability.csv")

# Filtrer les paires nécessitant le test de Fisher
fisher_pairs <- check_results %>%
  filter(Test_applicable == "Fisher")

# Initialiser le tableau de résultats
fisher_results <- data.frame()

# Appliquer le test de Fisher à chaque paire
for (i in 1:nrow(fisher_pairs)) {
  var1 <- fisher_pairs$Variable_1[i]
  var2 <- fisher_pairs$Variable_2[i]
  
  tab <- table(df[[var1]], df[[var2]])
  
  test <- fisher.test(tab, simulate.p.value = (nrow(tab) > 2 || ncol(tab) > 2), B = 10000)
  
  fisher_results <- rbind(fisher_results, data.frame(
    Variable_1 = var1,
    Variable_2 = var2,
    Effectif_total = sum(tab),
    p_value = round(test$p.value, 5),
    Test = "Fisher",
    Significatif = ifelse(test$p.value < 0.05, "Oui", "Non")
  ))
}

# Trier par p-value
fisher_results <- fisher_results %>% arrange(p_value)

# Exporter dans un fichier Excel
wb <- createWorkbook()
addWorksheet(wb, "Fisher_results")
writeData(wb, "Fisher_results", fisher_results)
saveWorkbook(wb, "output/fisher_test_results.xlsx", overwrite = TRUE)

# Aperçu dans la console
print(fisher_results)
