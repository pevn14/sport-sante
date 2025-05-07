# utils_descriptif.R

# Fonction pour les variables categorielles
afficher_categorielle <- function(vec, nom_variable) {
  n_total <- length(vec)
  n_na <- sum(is.na(vec))
  n_valid <- n_total - n_na
  
  cat(paste0(
    "\n--- ", nom_variable, " (Variable catégorielle) ---\n",
    "N = ", n_valid, " (valeurs valides), ", n_na, " manquantes\n\n"
  ))
  
  tab <- sort(table(vec), decreasing = TRUE)
  pourcents <- round(prop.table(tab) * 100, 1)
  df <- data.frame(
    Modalité = names(tab),
    Effectif = as.integer(tab),
    Pourcentage = paste0(pourcents, " %")
  )
  print(df, row.names = FALSE)
}


# Fonction pour les échelles de Likert (ex. : 1 à 5)
afficher_likert <- function(vec, nom_variable, niveaux = 1:5) {
  n_total <- length(vec)
  n_na <- sum(is.na(vec))
  n_valid <- n_total - n_na
  
  cat(paste0(
    "\n--- ", nom_variable, " (Échelle de Likert) ---\n",
    "N = ", n_valid, " (valeurs valides), ", n_na, " manquantes\n\n"
  ))
  
  print(summary(vec))
  
  # Calcul du mode
  mode_val <- names(which.max(table(vec)))
  cat("\nMode : ", mode_val, "\n\n")
  
  # Comptage des niveaux (y compris ceux à 0)
  tab <- table(factor(vec, levels = niveaux))
  pct <- round(prop.table(tab) * 100, 1)
  
  df <- data.frame(
    Niveau = names(tab),
    Effectif = as.integer(tab),
    Pourcentage = paste0(pct, " %")
  )
  
  print(df, row.names = FALSE)
}


afficher_categorielle_md <- function(vec, nom_variable) {
  tab <- sort(table(vec), decreasing = TRUE)
  pct <- round(prop.table(tab) * 100, 1)
  
  df <- data.frame(
    Modalité = names(tab),
    Effectif = as.integer(tab),
    Pourcentage = paste0(pct, " %")
  )
  
  cat(paste0("\n--- ", nom_variable, " (Variable catégorielle) ---\n\n"))
  cat("| Modalité | Effectif | Pourcentage |\n")
  cat("|----------|----------|-------------|\n")
  apply(df, 1, function(row) {
    cat(paste0("| ", paste(row, collapse = " | "), " |\n"))
  })
  cat("\n")
}

afficher_likert_md <- function(vec, nom_variable, niveaux = 1:5) {
  cat(paste0("\n--- ", nom_variable, " (Échelle de Likert) ---\n\n"))
  
  cat("Résumé statistique :\n\n")
  stats <- summary(vec)
  cat("```\n")
  print(stats)
  cat("```\n\n")
  
  tab <- table(factor(vec, levels = niveaux))
  pct <- round(prop.table(tab) * 100, 1)
  
  df <- data.frame(
    Niveau = names(tab),
    Effectif = as.integer(tab),
    Pourcentage = paste0(pct, " %")
  )
  
  cat("| Niveau | Effectif | Pourcentage |\n")
  cat("|--------|----------|-------------|\n")
  apply(df, 1, function(row) {
    cat(paste0("| ", paste(row, collapse = " | "), " |\n"))
  })
  cat("\n")
}

# Fonction pour créer un graph des variables catégorielles (barplot vertical en %)
plot_categorielle <- function(data, varname, label = NULL, levels = NULL, save = FALSE, dir = "plots") {
  label <- label %||% varname
  
  # Convertir la variable en facteur avec niveaux complets
  df <- data.frame(valeur = data[[varname]])
  
  if (!is.null(levels)) {
    df$valeur <- factor(as.character(df$valeur), levels = levels)
  }
  
  # Calcul des effectifs et des pourcentages
  tab <- table(df$valeur)
  df_plot <- as.data.frame(tab)
  names(df_plot) <- c("valeur", "effectif")
  df_plot$pourcentage <- df_plot$effectif / sum(df_plot$effectif)
  
  # Création du graphique
  p <- ggplot(df_plot, aes(x = valeur, y = pourcentage)) +
    geom_col(fill = "steelblue") +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    labs(title = label, x = NULL, y = "Pourcentage") +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
  
  if (save) {
    if (!dir.exists(dir)) dir.create(dir)
    ggsave(filename = file.path(dir, paste0(varname, "_barplot.png")),
           plot = p, width = 6, height = 4)
  } else {
    print(p)
  }
}



# Fonction pour creer un graph des échelles de Likert (barplot en %)
plot_likert <- function(data, varname, label = NULL, levels = 1:5, save = FALSE, dir = "plots") {
  label <- label %||% varname
  
  # Forcer la variable à être un facteur avec tous les niveaux
  data[[varname]] <- factor(data[[varname]], levels = levels)
  df <- data.frame(niveau = data[[varname]])
  
  # Compter les effectifs et calculer les pourcentages (même si 0)
  tab <- table(df$niveau)
  df_plot <- as.data.frame(tab)
  names(df_plot) <- c("niveau", "effectif")
  df_plot$pourcentage <- df_plot$effectif / sum(df_plot$effectif)
  
  # Créer le barplot
  p <- ggplot(df_plot, aes(x = niveau, y = pourcentage)) +
    geom_col(fill = "steelblue") +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    labs(title = label, x = "Niveau", y = "Pourcentage") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  
  # Affichage ou sauvegarde
  if (save) {
    if (!dir.exists(dir)) dir.create(dir)
    ggsave(filename = file.path(dir, paste0(varname, "_likert.png")),
           plot = p, width = 6, height = 4)
  } else {
    print(p)
  }
}
