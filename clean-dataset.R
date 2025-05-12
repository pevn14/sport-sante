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

# Remplacer les libellés longs des vidéos par des versions plus courtes
data_clean <- data_clean %>%
  mutate(across(
    everything(),
    ~ if (is.character(.x) || is.factor(.x)) {
      str_replace_all(.x, c(
        "La première vidéo \\(narration de type choc\\)" = "Narration de type choc",
        "La deuxième vidéo \\(narration de type appartenance\\)" = "Narration de type appartenance"
      ))
    } else {
      .x
    }
  ))

# Appliquer le renommage sans perdre les noms non mappés
colnames(data_clean) <- ifelse(is.na(new_colnames) | new_colnames == "", 
                               colnames(data_clean), 
                               new_colnames)

# remplace les - par des _ 
colnames(data_clean) <- gsub("-", "_", colnames(data_clean))

# 6. Vérifier les noms de colonnes renommés
#glimpse(data_clean)

# 7 recodage des variables categorielles ordinales
# Variables concernées :
# - age
# - pratique_sportive
# - perception_sport
# - relation_marques
# - preferences_narative
#
data_clean <- data_clean %>%
  mutate(
    age_num = as.integer(factor(age,
                                levels = c("Moins de 25 ans", "25 à 34 ans", "35 à 44 ans", "45 à 54 ans", "55 ans et plus"),
                                ordered = TRUE)),
    
    pratique_sportive_num = as.integer(factor(pratique_sportive,
                                              levels = c("Jamais", "Moins d’une fois par semaine", "1 à 2 fois par semaine",
                                                         "3 à 4 fois par semaine", "5 fois ou plus par semaine"),
                                              ordered = TRUE)),
    
    perception_sport_num = as.integer(factor(perception_sport,
                                             levels = c("une contrainte", "plutôt une contrainte", "ni l’un ni l’autre",
                                                        "plutôt un plaisir", "un plaisir"),
                                             ordered = TRUE)),
    
    relation_marques_num = as.integer(factor(relation_marques,
                                             levels = c("Une relation de méfiance", "Plutôt méfiante", "Neutre",
                                                        "Plutôt confiante", "Une relation de confiance"),
                                             ordered = TRUE)),
    
    preferences_narative_num = as.integer(factor(preferences_narative,
                                                 levels = c("Choquant et culpabilisant", "Un peu choquant", "Neutre",
                                                            "Valorisant un peu le lien social", "Valorisant le lien social"),
                                                 ordered = TRUE))
  )
# sauvegarde
write_csv(data_clean, "data_clean.csv")

print("Script terminé avec succès !")

