# Chargement des packages
library(dplyr)
library(ggplot2)
library(readr)

# 1. Chargement des données
# Remplace le chemin si nécessaire
rm(data, data_clean, lookup)
data <- read.csv("Enquete_marketing_sport_et_sante_Submissions_2025-05-07.csv", encoding = "UTF-8")

# 2. Suppression des 4 premières colonnes
data_clean <- data %>% select(-c(1:4))

# 3. Charger le fichier de correspondance (lookup)
lookup <- read_csv("lookup - table_lookup.csv")

# Uniformiser les noms dans lookup
lookup$old_name_clean <- make.names(lookup$old_name)

# Ensuite on fait le mapping
new_colnames <- lookup$new_name[match(colnames(data_clean), lookup$old_name_clean)]
                               
# Appliquer le renommage sans perdre les noms non mappés
colnames(data_clean) <- ifelse(is.na(new_colnames) | new_colnames == "", 
                               colnames(data_clean), 
                               new_colnames)

# remplace les - par des _ 
colnames(data_clean) <- gsub("-", "_", colnames(data_clean))

# 6. Vérifier les noms de colonnes renommés
glimpse(data_clean)

# sauvegarde
write_csv(data_clean, "data_clean.csv")

print("Script terminé avec succès !")

