##############################################################
# SCRIPT D'ANALYSE MULTIVARIÉE
#
# Objectif :
# Ce script réalise les régressions logistiques binaires pour tester
# les hypothèses H1, H2 et H3
#
# Pour chaque hypothèse :
# - Recodage de la variable dépendante (binaire)
# - Sélection des variables explicatives pertinentes (VI et VM)
# - Modélisation par régression logistique binaire
# - Export des résultats (coefficients, erreurs standard, z, p) dans un fichier Excel
#
# Format de sortie :
# Fichier Excel unique contenant 3 feuilles (H1, H2, H3)
# Chaque feuille présente le résumé du modèle correspondant.
#
# Pré-requis :
# - Le fichier "data_clean.csv" doit être dans le répertoire de travail
# - Les packages `openxlsx` doivent être installés
##############################################################

library(openxlsx)

# 🧠 Charger les données
df <- read.csv("data_clean.csv")

# ============================
# 🔹 H1 — Intention de pratiquer
# ============================

# Recode de la VD en binaire
df$intention_binaire <- NA
df$intention_binaire[df$intention_pratique %in% c(1, 2)] <- 0
df$intention_binaire[df$intention_pratique %in% c(4, 5)] <- 1

# Sous-échantillon H1
df_h1 <- df[df$intention_binaire %in% c(0, 1), ]

# Modèle logistique H1
model_h1 <- glm(intention_binaire ~ engagement_emotionnel + receptivite + engagement_cognitif,
                data = df_h1, family = binomial)

# Résumé H1
summary_h1 <- data.frame(
  Variable = rownames(summary(model_h1)$coefficients),
  Coefficient = coef(model_h1),
  Std_Error = summary(model_h1)$coefficients[, "Std. Error"],
  z_value = summary(model_h1)$coefficients[, "z value"],
  p_value = summary(model_h1)$coefficients[, "Pr(>|z|)"]
)

# ============================
# 🔹 H2 — Perception de manipulation
# ============================

# Recode de la VD en binaire
df$manipulation_binaire <- NA
df$manipulation_binaire[df$perception_manipulation %in% c(1, 2)] <- 0
df$manipulation_binaire[df$perception_manipulation %in% c(4, 5)] <- 1

# Sous-échantillon H2
df_h2 <- df[df$manipulation_binaire %in% c(0, 1), ]

# Modèle logistique H2
model_h2 <- glm(manipulation_binaire ~ authenticite_percue + alignement_valeur + relation_marques_num,
                data = df_h2, family = binomial)

# Résumé H2
summary_h2 <- data.frame(
  Variable = rownames(summary(model_h2)$coefficients),
  Coefficient = coef(model_h2),
  Std_Error = summary(model_h2)$coefficients[, "Std. Error"],
  z_value = summary(model_h2)$coefficients[, "z value"],
  p_value = summary(model_h2)$coefficients[, "Pr(>|z|)"]
)

# ===============================
# 🔹 H3 — Préférence narration
# ===============================
df$h3_binaire <- NA
df$h3_binaire[df$adhesion_appartenance_h3 > df$adhesion_choc_h3] <- 1
df$h3_binaire[df$adhesion_appartenance_h3 < df$adhesion_choc_h3] <- 0
df_h3 <- df[df$h3_binaire %in% c(0, 1), ]

model_h3 <- glm(h3_binaire ~ receptivite + engagement_emotionnel + engagement_cognitif,
                data = df_h3, family = binomial)

summary_h3 <- data.frame(
  Variable = rownames(summary(model_h3)$coefficients),
  Coefficient = coef(model_h3),
  Std_Error = summary(model_h3)$coefficients[, "Std. Error"],
  z_value = summary(model_h3)$coefficients[, "z value"],
  p_value = summary(model_h3)$coefficients[, "Pr(>|z|)"]
)


# ============================
# Export Excel commun
# ============================

# Création du fichier Excel avec openxlsx
wb <- createWorkbook()
addWorksheet(wb, "H1_Logit_Summary")
writeData(wb, "H1_Logit_Summary", summary_h1)

addWorksheet(wb, "H2_Logit_Summary")
writeData(wb, "H2_Logit_Summary", summary_h2)

addWorksheet(wb, "H3_Logit_Summary")
writeData(wb, "H3_Logit_Summary", summary_h3)

saveWorkbook(wb, file = "output/regression_logistique.xlsx", overwrite = TRUE)
