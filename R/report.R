

# LIBRERÍAS ---------------------------------------------------------------

if(!require(dplyr)) install.packages("dplyr") else require(dplyr)
if(!require(lubridate)) install.packages("lubridate") else require(lubridate)
if(!require(data.table)) install.packages("data.table") else require(data.table)
if(!require(writexl)) install.packages("writexl") else require(writexl)
if(!require(fs)) install.packages("fs") else require(fs)
if(!require(openxlsx)) install.packages("openxlsx") else require(openxlsx)

options(scipen=999)

# -------------------------------------------------------------------------
# FUNCIONES DE FORMATO (ES-CL)
# -------------------------------------------------------------------------

fmt_pct_cl <- function(x, digits = 2) {
  ifelse(
    is.na(x),
    NA_character_,
    formatC(
      x,
      format = "f",
      digits = digits,
      decimal.mark = ",",
      big.mark = "."
    )
  )
}

fmt_num_cl <- function(x) {
  ifelse(
    is.na(x),
    NA_character_,
    formatC(
      as.integer(x),
      format = "d",
      big.mark = ".",
      decimal.mark = ""
    )
  )
}




# RUTA BASE Y MAPE0 DE ARCHIVOS -------------------------------------------


base_path <- "datasets/260121"
tmp_dir <- tempdir()

archivos <- list(
  ENI_SV_Verif_2025_1_Tabular_All.zip = list(
    tab  = "ENI_SV_Verif_2025.tab",
    diag = "interview__diagnostics.tab",
    df   = "ENI_SV_Verif_2025"
  ),
  EOC_SV_Verif_2025_1_Tabular_All.zip = list(
    tab  = "EOC_SV_Verif_2025.tab",
    diag = "interview__diagnostics.tab",
    df   = "EOC_SV_Verif_2025"
  ),
  Superv_2025_Analis_ENIA_1_Tabular_All.zip = list(
    tab  = "Superv_2025_Analis_ENIA.tab",
    diag = "interview__diagnostics.tab",
    df   = "Superv_2025_Analis_ENIA"
  ),
  Superv_2025_Analis_ENI_1_Tabular_All.zip = list(
    tab  = "Superv_2025_Analis_ENI.tab",
    diag = "interview__diagnostics.tab",
    df   = "Superv_2025_Analis_ENI"
  ),
  Superv_2025_Rec_ENIA_1_Tabular_All.zip = list(
    tab  = "Superv_2025_Rec_ENIA.tab",
    diag = "interview__diagnostics.tab",
    df   = "Superv_2025_Rec_ENIA"
  ),
  Superv_2025_Rec_ENI_2_Tabular_All.zip = list(
    tab  = "Superv_2025_Rec_ENI.tab",
    diag = "interview__diagnostics.tab",
    df   = "Superv_2025_Rec_ENI"
  ),
  Superv_2025_Ver_ELE8_1_Tabular_All.zip = list(
    tab  = "Superv_2025_Ver_ELE8.tab",
    diag = "interview__diagnostics.tab",
    df   = "Superv_2025_Ver_ELE8"
  )
)


# CARGA + JOIN CON DIAGNOSTICS ------------------------------------------


for (zip_name in names(archivos)) {
  
  zip_path <- file.path(base_path, zip_name)
  tab_name  <- archivos[[zip_name]]$tab
  diag_name <- archivos[[zip_name]]$diag
  df_name   <- archivos[[zip_name]]$df
  
  unzip(zip_path, files = c(tab_name, diag_name),
        exdir = tmp_dir, overwrite = TRUE)
  
  df_main <- fread(file.path(tmp_dir, tab_name))
  df_diag <- fread(file.path(tmp_dir, diag_name))[
    , .(interview__id, responsible)
  ]
  
  df_final <- merge(
    df_main,
    df_diag,
    by = "interview__id",
    all.x = TRUE
  )
  
  assign(df_name, df_final, envir = .GlobalEnv)
  
  message("Cargado con diagnostics: ", df_name)
}


# CONSOLIDADO DE SUPERVISIÓN ----------------------------------------------

cols <- c(
  "interview__id",
  "responsible",
  "P_2_1",
  "P_3_1__1",
  "P_3_1__2",
  "P_3_1__3",
  "P_3_1__4",
  "P_9_1"
)

dfs <- sapply(archivos, `[[`, "df")

lista <- list()

for (df_name in dfs) {
  
  df <- as.data.table(get(df_name, envir = .GlobalEnv))
  
  cols_ok <- intersect(cols, names(df))
  tmp <- df[, ..cols_ok][, lapply(.SD, as.character)]
  tmp[, origen_df := df_name]
  
  faltantes <- setdiff(cols, names(tmp))
  for (f in faltantes) tmp[, (f) := NA_character_]
  
  setcolorder(tmp, c(cols, "origen_df"))
  lista[[df_name]] <- tmp
}

consolidado <- rbindlist(lista, fill = TRUE)

# -------------------------------------------------------------------------
# NORMALIZACIÓN GLOBAL DE TEXTO (encoding + espacios)
# -------------------------------------------------------------------------
# Esto previene problemas de UTF-8 / Latin1 provenientes de Excel, ZIP, etc.
# Se aplica a TODAS las columnas de texto del consolidado

consolidado <- consolidado %>%
  mutate(
    across(
      where(is.character),
      ~ trimws(iconv(.x, from = "", to = "UTF-8"))
    )
  )




# DEFINICIÓN DE ETAPA -----------------------------------------------------

consolidado <- consolidado %>%
  mutate(
    etapa = case_when(
      P_3_1__1 == "1" ~ "Verificación",
      P_3_1__2 == "1" ~ "Recolección",
      P_3_1__3 == "1" ~ "Consistencia",
      P_3_1__4 == "1" ~ "Procesamiento",
      TRUE ~ NA_character_
    )
  )


# DEFINICIÓN DE ENCUESTA --------------------------------------------------

consolidado <- consolidado %>%
  mutate(
    encuesta = case_when(
      origen_df == "ENI_SV_Verif_2025" ~ "ENI", 
      origen_df == "Superv_2025_Analis_ENI" ~ "ENI",
      origen_df == "EOC_SV_Verif_2025" ~ "EOC",
      origen_df == "Superv_2025_Analis_ENIA" ~ "ENIA",
      origen_df == "Superv_2025_Rec_ENI" ~ "ENI",
      origen_df == "Superv_2025_Rec_ENIA" ~ "ENIA", 
      origen_df == "Superv_2025_Ver_ELE8" ~ "ELE",
      TRUE ~ NA_character_)
  )



# -------------------------------------------------------------------------
# 1) TABLA DE REGLAS OPERATIVAS (EDITABLE)
# -------------------------------------------------------------------------

reglas_duracion <- tribble(
  ~encuesta, ~etapa,           ~min_min, ~max_min,
  "ELE",     "Verificación",     0.3,      25,
  "ENI",     "Consistencia",     0.3,      20,
  "ENI",     "Recolección",      0.3,      25,
  "ENI",     "Verificación",     0.3,      25,
  "ENIA",    "Consistencia",     0.3,      20,
  "ENIA",    "Recolección",      0.3,      20,
  "EOC",     "Verificación",     0.3,      25
)

# -------------------------------------------------------------------------
# 2) PROCESAMIENTO DE FECHAS Y DURACIONES
# -------------------------------------------------------------------------

consolidado <- consolidado %>%
  mutate(
    # Parseo de fechas y horas
    datetime_i = suppressWarnings(ymd_hms(P_2_1)),  # inicio
    datetime_t = suppressWarnings(ymd_hms(P_9_1)),  # término
    
    # Flags de error temporal
    flag_na_datetime = is.na(datetime_i) | is.na(datetime_t),
    
    # Duración en segundos
    duracion_seg = as.numeric(difftime(datetime_t, datetime_i, units = "secs")),
    flag_duracion_negativa = duracion_seg < 0,
    
    # Limpieza básica
    duracion_seg = ifelse(flag_na_datetime | flag_duracion_negativa, NA, duracion_seg),
    duracion_min = duracion_seg / 60
  )

# -------------------------------------------------------------------------
# 3) APLICAR REGLAS POR ENCUESTA Y ETAPA
# -------------------------------------------------------------------------

consolidado <- consolidado %>%
  left_join(
    reglas_duracion,
    by = c("encuesta", "etapa")
  ) %>%
  mutate(
    flag_mayor_min = !is.na(duracion_min) &
      !is.na(max_min) &
      duracion_min > max_min,
    
    flag_menor_min = !is.na(duracion_min) &
      !is.na(min_min) &
      duracion_min < min_min
  )

# -------------------------------------------------------------------------
# 4) DURACIÓN LIMPIA Y DETECCIÓN DE OUTLIERS
# -------------------------------------------------------------------------

consolidado <- consolidado %>%
  mutate(
    # Duración válida según reglas operativas
    duracion_min_limpia = ifelse(flag_mayor_min | flag_menor_min, NA, duracion_min)
  ) %>%
  group_by(etapa) %>%
  mutate(
    # Conteo de válidos
    n_validos_etapa = sum(!is.na(duracion_min_limpia)),
    
    # Cuartiles
    q1 = ifelse(
      n_validos_etapa > 0,
      quantile(duracion_min_limpia, 0.25, na.rm = TRUE),
      NA_real_
    ),
    
    q3 = ifelse(
      n_validos_etapa > 0,
      quantile(duracion_min_limpia, 0.75, na.rm = TRUE),
      NA_real_
    ),
    
    # IQR
    iqr = q3 - q1,
    
    # Límites Tukey
    lim_inf = ifelse(n_validos_etapa > 0, q1 - 1.5 * iqr, NA_real_),
    lim_sup = ifelse(n_validos_etapa > 0, q3 + 1.5 * iqr, NA_real_),
    
    # Outlier IQR
    flag_outlier_iqr = ifelse(
      !is.na(duracion_min_limpia),
      duracion_min_limpia < lim_inf | duracion_min_limpia > lim_sup,
      NA
    ),
    
    # MAD
    mediana = ifelse(
      n_validos_etapa > 0,
      median(duracion_min_limpia, na.rm = TRUE),
      NA_real_
    ),
    
    mad_val = ifelse(
      n_validos_etapa > 0,
      mad(duracion_min_limpia, na.rm = TRUE),
      NA_real_
    ),
    
    # Z-MAD robusto
    z_mad = ifelse(
      !is.na(duracion_min_limpia) & !is.na(mad_val) & mad_val > 0,
      (duracion_min_limpia - mediana) / mad_val,
      NA_real_
    ),
    
    flag_outlier_mad = ifelse(!is.na(z_mad), abs(z_mad) > 3.5, NA)
  ) %>%
  ungroup() %>%
  mutate(
    # Flags finales
    flag_outlier_estadistico = flag_outlier_iqr | flag_outlier_mad,
    flag_regla_operativa    = flag_mayor_min | flag_menor_min,
    flag_error_fecha        = flag_duracion_negativa | flag_na_datetime
  )





# FUNCIONES ----------------------------------------------------------------------
reporte_generico <- function(data, ...) {
  
  # -----------------------------
  # Helpers locales
  # -----------------------------
  
  min_to_hms <- function(x) {
    if (is.na(x)) return(NA_character_)
    total_sec <- round(x * 60)
    h <- total_sec %/% 3600
    m <- (total_sec %% 3600) %/% 60
    s <- total_sec %% 60
    sprintf("%02d:%02d:%02d", h, m, s)
  }
  
  # -----------------------------
  # Resumen
  # -----------------------------
  
  data %>%
    group_by(...) %>%
    summarise(
      
      # -------------------------------------------------
      # BASE
      # -------------------------------------------------
      n_total = n(),
      
      # -------------------------------------------------
      # ERRORES DE FECHA
      # % sobre TOTAL (denominador explícito)
      # -------------------------------------------------
      n_error_fecha = sum(flag_error_fecha, na.rm = TRUE),
      pct_error_fecha = ifelse(
        n_total > 0,
        100 * n_error_fecha / n_total,
        NA_real_
      ),
      
      # -------------------------------------------------
      # REGLAS OPERATIVAS
      # % sobre TOTAL (denominador explícito)
      # -------------------------------------------------
      n_regla_operativa = sum(flag_regla_operativa, na.rm = TRUE),
      pct_regla_operativa = ifelse(
        n_total > 0,
        100 * n_regla_operativa / n_total,
        NA_real_
      ),
      
      # -------------------------------------------------
      # DURACIONES VÁLIDAS
      # -------------------------------------------------
      n_validos = sum(!is.na(duracion_min_limpia)),
      
      # -------------------------------------------------
      # OUTLIERS
      # DEFINICIÓN CLAVE:
      # % sobre TOTAL (NO sobre válidos)
      # -------------------------------------------------
      n_outliers = sum(
        flag_outlier_estadistico & !is.na(duracion_min_limpia),
        na.rm = TRUE
      ),
      
      pct_outliers = ifelse(
        n_total > 0,
        100 * n_outliers / n_total,
        NA_real_
      ),
      
      # -------------------------------------------------
      # VÁLIDOS SIN OUTLIERS
      # -------------------------------------------------
      n_validos_sin_outliers = sum(
        !is.na(duracion_min_limpia) & !flag_outlier_estadistico
      ),
      
      # -------------------------------------------------
      # DISTRIBUCIÓN (solo válidos sin outliers)
      # -------------------------------------------------
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
    select(-valores_validos) %>%
    mutate(
      across(starts_with("n_"), fmt_num_cl),
      across(starts_with("pct_"), fmt_pct_cl)
    )
}




# REPORTES ---------------------------------------------------------------------

# 1. reporte etapa -------------------------------------------------------------
reporte_etapa <- consolidado %>%
  filter(!is.na(etapa)) %>%
  reporte_generico(etapa)

# 2. reporte usuario -----------------------------------------------------------
reporte_por_responsible <- consolidado %>%
  filter(!is.na(responsible)) %>%
  reporte_generico(responsible)

# 3. reporte usuario etapa -----------------------------------------------------
reporte_por_responsible_etapa <- consolidado %>%
  filter(!is.na(responsible), !is.na(etapa)) %>%
  reporte_generico(responsible, etapa)

# 4. reporte encuesta etapa ----------------------------------------------------
reporte_origen_etapa <- consolidado %>%
  filter(!is.na(origen_df), !is.na(etapa)) %>%
  reporte_generico(encuesta, etapa)

# 5. reporte encuesta, etapa, usuario ------------------------------------------
reporte_origen_etapa_responsible <- consolidado %>%
  filter(!is.na(origen_df), !is.na(etapa), !is.na(responsible)) %>%
  reporte_generico(encuesta, etapa, responsible)


# 6. reporte de alerta  --------------------------------------------------
reporte_alerta <- consolidado %>%
  filter(
    flag_error_fecha |
      flag_regla_operativa |
      flag_outlier_estadistico
  ) %>%
  select(
    interview__id,
    origen_df,
    etapa,
    responsible,
    datetime_i,
    datetime_t,
    duracion_min,
    duracion_min_limpia,
    flag_na_datetime,
    flag_duracion_negativa,
    flag_mayor_min,
    flag_menor_min,
    flag_outlier_iqr,
    flag_outlier_mad,
    flag_outlier_estadistico
  ) %>%
  arrange(origen_df, etapa, responsible)


# 7. auditoria global -----------------------------------------------------

reporte_auditoria_global <- consolidado %>%
  summarise(
    total_registros = n(),
    
    errores_fecha = sum(flag_error_fecha, na.rm = TRUE),
    pct_errores_fecha = 100 * mean(flag_error_fecha, na.rm = TRUE),
    
    reglas_operativa = sum(flag_regla_operativa, na.rm = TRUE),
    pct_reglas_operativa = 100 * mean(flag_regla_operativa, na.rm = TRUE),
    
    outliers = sum(flag_outlier_estadistico, na.rm = TRUE),
    pct_outliers = 100 * mean(flag_outlier_estadistico, na.rm = TRUE)
  ) %>%
  mutate(
    across(c(total_registros, errores_fecha, reglas_operativa, outliers), fmt_num_cl),
    across(starts_with("pct_"), fmt_pct_cl)
  )



# 8. auditoria general -------------------------------------------------------



reporte_auditoria_fina <- consolidado %>%
  filter(!is.na(etapa), !is.na(origen_df), !is.na(responsible)) %>%
  group_by(encuesta, etapa, responsible) %>%
  summarise(
    n_total = n(),
    
    errores_fecha = sum(flag_error_fecha, na.rm = TRUE),
    pct_errores_fecha = 100 * mean(flag_error_fecha, na.rm = TRUE),
    
    reglas_operativa = sum(flag_regla_operativa, na.rm = TRUE),
    pct_reglas_operativa = 100 * mean(flag_regla_operativa, na.rm = TRUE),
    
    outliers = sum(flag_outlier_estadistico & !is.na(duracion_min_limpia), na.rm = TRUE),
    pct_outliers = 100 * mean(
      flag_outlier_estadistico & !is.na(duracion_min_limpia),
      na.rm = TRUE
    ),
    
    .groups = "drop"
  ) %>%
  mutate(
    across(starts_with("n_"), fmt_num_cl),
    across(starts_with("pct_"), fmt_pct_cl)
  )




#SALIDA ------------------------------------------------------------------


# ---- Ruta de salida -----------------------------------------------------

dir_salida <- "tabulados"
dir_create(dir_salida)



dir_publicable <- "assets/tabulados"
dir_create(dir_publicable)


timestamp <- format(Sys.time(), "%Y%m%d_%H%M")
ruta_salida <- file.path(
  dir_salida,
  paste0("reporte_sv_", timestamp, ".xlsx")
)


# -------------------------------------------------------------------------
# EXPORTACIÓN DE TABULADOS PUBLICABLES (DESCARGAS QMD)
# -------------------------------------------------------------------------

write.xlsx(
  reporte_origen_etapa_responsible,
  file.path(dir_publicable, "R1_encuesta_etapa_usuario.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_origen_etapa,
  file.path(dir_publicable, "R2_encuesta_etapa.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_por_responsible_etapa,
  file.path(dir_publicable, "R3_usuario_etapa.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_etapa,
  file.path(dir_publicable, "R4_etapa.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_por_responsible,
  file.path(dir_publicable, "R5_usuario.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_auditoria_global,
  file.path(dir_publicable, "Resumen_global.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_auditoria_fina,
  file.path(dir_publicable, "Auditoria_fina.xlsx"),
  overwrite = TRUE
)

message("Tabulados publicables exportados en assets/tabulados/")




# ---- Workbook ----------------------------------------------------------

wb <- createWorkbook()

# ---- Estilos -----------------------------------------------------------

style_header <- createStyle(
  fgFill = "#2F5597",
  fontColour = "white",
  textDecoration = "bold",
  halign = "center",
  valign = "center",
  border = "Bottom"
)

style_table <- createStyle(
  border = "TopBottomLeftRight",
  valign = "center"
)

# ---- Función helper para hojas -----------------------------------------

add_sheet <- function(wb, nombre, data) {
  addWorksheet(wb, nombre)

  writeData(wb, nombre, data, withFilter = TRUE)
  freezePane(wb, nombre, firstRow = TRUE)

  addStyle(
    wb, nombre, style_header,
    rows = 1,
    cols = 1:ncol(data),
    gridExpand = TRUE
  )

  addStyle(
    wb, nombre, style_table,
    rows = 2:(nrow(data) + 1),
    cols = 1:ncol(data),
    gridExpand = TRUE
  )

  setColWidths(wb, nombre, cols = 1:ncol(data), widths = "auto")
}

# ---- Hojas -------------------------------------------------------------

add_sheet(wb, "R1 encuesta, etapa y usuario", reporte_origen_etapa_responsible)
add_sheet(wb, "R2 encuesta y etapa",         reporte_origen_etapa)
add_sheet(wb, "R3 usuario y etapa",          reporte_por_responsible_etapa)
add_sheet(wb, "R4 etapa",                    reporte_etapa)
add_sheet(wb, "R5 usuario",                  reporte_por_responsible)
add_sheet(wb, "R6 alerta",                   reporte_alerta)
add_sheet(wb, "Resumen global",              reporte_auditoria_global)
add_sheet(wb, "Auditoría fina",              reporte_auditoria_fina)

# ---- Guardado ----------------------------------------------------------

tryCatch(
  {
    saveWorkbook(wb, ruta_salida, overwrite = TRUE)

    message("Excel generado correctamente")
    message("Ruta: ", normalizePath(ruta_salida))
    message("Hojas: 8")
  },
  error = function(e) {
    message("Error al generar el Excel:")
    message(e$message)
  }
)
