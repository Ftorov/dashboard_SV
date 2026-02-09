library(dplyr)
library(lubridate)
library(htmltools)
library(tibble)
library(purrr)


# HELPERS DE PRESENTACIÓN 


# Porcentaje en formato CL (devuelve TEXTO: "2,13")
fmt_pct_cl <- function(x, digits = 2) {
  if (is.na(x)) return(NA_character_)
  out <- sprintf(paste0("%.", digits, "f"), x)
  gsub("\\.", ",", out)
}

# Estado semántico a partir de porcentaje en TEXTO CL
# Umbrales explícitos y auditables
estado_pct <- function(x) {
  pct <- suppressWarnings(as.numeric(gsub(",", ".", x)))
  if (is.na(pct) || pct == 0) {
    "ok"
  } else if (pct <= 2) {
    "warn"
  } else {
    "bad"
  }
}


# FUNCIÓN GENÉRICA DE REPORTE 


reporte_generico <- function(data, ...) {
  
  pct_safe <- function(x, digits = 2) {
    if (all(is.na(x))) NA_real_
    else round(100 * mean(x, na.rm = TRUE), digits)
  }
  
  min_to_hms <- function(x) {
    if (is.na(x)) return(NA_character_)
    total_sec <- round(x * 60)
    h <- total_sec %/% 3600
    m <- (total_sec %% 3600) %/% 60
    s <- total_sec %% 60
    sprintf("%02d:%02d:%02d", h, m, s)
  }
  
  data %>%
    group_by(...) %>%
    summarise(
      n_total = n(),
      
      n_error_fecha = sum(flag_error_fecha, na.rm = TRUE),
      pct_error_fecha = fmt_pct_cl(pct_safe(flag_error_fecha)),
      
      n_regla_operativa = sum(flag_regla_operativa, na.rm = TRUE),
      pct_regla_operativa = fmt_pct_cl(pct_safe(flag_regla_operativa)),
      
      n_validos = sum(!is.na(duracion_min_limpia)),
      
      n_outliers = sum(
        flag_outlier_estadistico & !is.na(duracion_min_limpia),
        na.rm = TRUE
      ),
      pct_outliers = fmt_pct_cl(
        pct_safe(flag_outlier_estadistico & !is.na(duracion_min_limpia))
      ),
      
      n_validos_sin_outliers = sum(
        !is.na(duracion_min_limpia) & !flag_outlier_estadistico
      ),
      
      valores_validos = list(
        duracion_min_limpia[
          !is.na(duracion_min_limpia) & !flag_outlier_estadistico
        ]
      ),
      
      media = {
        v <- valores_validos[[1]]
        if (length(v) == 0) NA_character_ else min_to_hms(mean(v))
      },
      mediana = {
        v <- valores_validos[[1]]
        if (length(v) == 0) NA_character_ else min_to_hms(median(v))
      },
      p25 = {
        v <- valores_validos[[1]]
        if (length(v) == 0) NA_character_ else min_to_hms(quantile(v, 0.25))
      },
      p75 = {
        v <- valores_validos[[1]]
        if (length(v) == 0) NA_character_ else min_to_hms(quantile(v, 0.75))
      },
      minimo = {
        v <- valores_validos[[1]]
        if (length(v) == 0) NA_character_ else min_to_hms(min(v))
      },
      maximo = {
        v <- valores_validos[[1]]
        if (length(v) == 0) NA_character_ else min_to_hms(max(v))
      },
      
      .groups = "drop"
    ) %>%
    select(-valores_validos)
}


# GRUPOS DE KPI


kpi_grupos <- list(
  Calidad = c(
    "Error en registro de fecha",
    "Regla operativa",
    "Outliers"
  ),
  Cobertura = c(
    "Registros evaluados",
    "Registros válidos",
    "Válidos sin outliers"
  ),
  Duraciones = c(
    "Duración media",
    "Duración mínima",
    "Duración máxima"
  )
)


# DEFINICIONES METODOLÓGICAS


kpi_definiciones <- list(
  "Error en registro de fecha" =
    "Porcentaje de registros con inconsistencias temporales, definidas como fechas u horas faltantes o duraciones negativas entre inicio y término.",
  
  "Regla operativa" =
    "Porcentaje de registros cuya duración incumple los umbrales mínimos o máximos definidos por encuesta y etapa.",
  
  "Outliers" =
    "Porcentaje de registros con duraciones atípicas identificadas mediante criterios estadísticos (IQR de Tukey y Z-MAD).",
  
  "Registros evaluados" =
    "Total de registros procesados en la etapa considerada.",
  
  "Registros válidos" =
    "Número de registros cuya duración cumple las reglas operativas definidas.",
  
  "Válidos sin outliers" =
    "Registros válidos que no presentan valores atípicos y que conforman la base final para el análisis.",
  
  "Duración media" =
    "Promedio del tiempo de respuesta calculado sobre registros válidos sin outliers.",
  
  "Duración mínima" =
    "Menor tiempo de respuesta observado entre los registros válidos sin outliers.",
  
  "Duración máxima" =
    "Mayor tiempo de respuesta observado entre los registros válidos sin outliers."
)


# DASHBOARD KPI


kpi_dashboard_completo <- function(df, encuesta_sel, etapa_sel, kpi_sel) {
  
  if (missing(kpi_sel)) {
    stop("Debe indicar kpi_sel: Calidad, Cobertura o Duraciones")
  }
  
  if (!kpi_sel %in% names(kpi_grupos)) {
    stop(
      "kpi_sel inválido. Opciones: ",
      paste(names(kpi_grupos), collapse = ", ")
    )
  }
  
  fila <- df %>%
    mutate(
      encuesta = trimws(as.character(encuesta)),
      etapa    = trimws(as.character(etapa))
    ) %>%
    filter(encuesta == encuesta_sel, etapa == etapa_sel)
  
  if (nrow(fila) == 0) {
    return(
      knitr::asis_output(
        "<div class='kpi-empty'>
           <strong>No hay información para mostrar</strong><br>
           La combinación seleccionada no registra datos.
         </div>"
      )
    )
  }
  
  if (nrow(fila) > 1) {
    stop("Existen múltiples filas para la selección. Revise la fuente de datos.")
  }
  
  cards_def <- tibble(
    label = c(
      "Error en registro de fecha",
      "Regla operativa",
      "Outliers",
      "Registros evaluados",
      "Registros válidos",
      "Válidos sin outliers",
      "Duración media",
      "Duración mínima",
      "Duración máxima"
    ),
    n_var = c(
      "n_error_fecha",
      "n_regla_operativa",
      "n_outliers",
      "n_total",
      "n_validos",
      "n_validos_sin_outliers",
      "media",
      "minimo",
      "maximo"
    ),
    pct_var = c(
      "pct_error_fecha",
      "pct_regla_operativa",
      "pct_outliers",
      NA, NA, NA, NA, NA, NA
    ),
    icon = c(
      "bi-calendar-x",
      "bi-shield-x",
      "bi-exclamation-circle",
      "bi-clipboard-data",
      "bi-check-lg",
      "bi-check-circle",
      "bi-clock",
      "bi-arrow-down",
      "bi-arrow-up"
    ),
    tipo = c(
      "risk", "risk", "risk",
      "neutral", "neutral", "neutral",
      "time", "time", "time"
    )
  ) %>%
    filter(label %in% kpi_grupos[[kpi_sel]])
  
  render_card <- function(label, n_var, pct_var, icon, tipo) {
    
    n_txt  <- fila[[n_var]]
    estado <- "neutral"
    subtxt <- NULL
    pct_txt <- NULL
    
    if (!is.na(pct_var)) {
      pct_txt <- paste0(fila[[pct_var]], "%")
      estado  <- estado_pct(fila[[pct_var]])
    }
    
    definicion <- kpi_definiciones[[label]]
    
    tags$div(
      class = paste("kpi-card", tipo, estado),
      
      tags$div(
        class = "kpi-head",
        tags$i(class = paste("bi", icon)),
        tags$span(label),
        if (!is.null(definicion)) {
          tags$details(
            class = "kpi-help",
            tags$summary(
              title = "Ver definición metodológica",
              tags$i(class = "bi bi-info-circle")
            ),
            tags$div(class = "kpi-help-text", definicion)
          )
        }
      ),
      
      tags$div(
        class = "kpi-main",
        
        # VALOR PRINCIPAL
        if (!is.na(pct_var)) {
          tags$span(class = "kpi-value", pct_txt)
        } else {
          tags$span(class = "kpi-value", n_txt)
        }
      ),
      
      # CONTEXTO (solo si aplica)
      if (!is.na(pct_var)) {
        tags$div(
          class = "kpi-sub",
          paste0(n_txt, " registros")
        )
      },
      
      if (!is.null(subtxt))
        tags$div(class = "kpi-sub", subtxt)
    )
  }
  
  cards <- purrr::pmap(cards_def, render_card)
  
  browsable(
    tags$div(class = "kpi-grid", cards)
  )
  
}

