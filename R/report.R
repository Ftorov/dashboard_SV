

# 0. MEDICIÓN DE TIEMPO DE EJECUCIÓN --------------------------------------

t_inicio <- Sys.time()


# 1. LIBRERÍAS ------------------------------------------------------------
pkgs <- c(
  "dplyr", "lubridate", "data.table", "writexl",
  "fs", "openxlsx", "tibble", "purrr", "reactable", "htmltools"
)

for (p in pkgs) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

options(scipen = 999)


# 2. METADATOS DEL REPORTE ------------------------------------------------

metadata_reporte <- list(
  proyecto         = "Dashboard de prueba",
  responsable      = "Francisco Toro",
  fecha_descarga   = as.Date("2026-01-26"),
  fecha_generacion = Sys.Date(),
  version          = "v1.1"
)

metadata_bases <- tibble(
  encuesta = c("ENI","ENI","ENIA","ENIA","EOC","ELE"),
  archivo_zip = c(
    "ENI_SV_Verif_2025_1_Tabular_All.zip",
    "Superv_2025_Rec_ENI_2_Tabular_All.zip",
    "Superv_2025_Rec_ENIA_1_Tabular_All.zip",
    "Superv_2025_Analis_ENIA_1_Tabular_All.zip",
    "EOC_SV_Verif_2025_1_Tabular_All.zip",
    "Superv_2025_Ver_ELE8_1_Tabular_All.zip"
  ),
  fecha_descarga = metadata_reporte$fecha_descarga,
  fuente = "Survey Solutions"
)


# 3. FUNCIONES DE FORMATO (ES-CL) -----------------------------------------

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


# 4.  RUTA BASE Y ARCHIVOS ------------------------------------------------

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


# 5. CARGA + JOIN CON DIAGNOSTICS ------------------------------------------

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


# 6. CONSOLIDADO ----------------------------------------------

cols <- c("interview__id","responsible","P_2_1","P_3_1__1",
          "P_3_1__2","P_3_1__3","P_3_1__4","P_9_1")

lista <- lapply(sapply(archivos, `[[`, "df"), function(df_name) {
  df <- as.data.table(get(df_name))
  tmp <- df[, intersect(cols, names(df)), with = FALSE][, lapply(.SD, as.character)]
  tmp[, origen_df := df_name]
  for (f in setdiff(cols, names(tmp))) tmp[, (f) := NA_character_]
  setcolorder(tmp, c(cols, "origen_df"))
  tmp
})

consolidado <- rbindlist(lista, fill = TRUE) %>%
  mutate(across(where(is.character), ~trimws(iconv(.x, "", "UTF-8"))),
         responsible = sub("_.*$", "", responsible))

#7. ETAPA Y ENCUESTA ---------------------------------------------

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


vars_clave <- c(
  "P_2_1","P_3_1__1","P_3_1__2",
  "P_3_1__3","P_3_1__4","P_9_1"
)

consolidado <- consolidado %>%
  filter(
    if_any(
      all_of(vars_clave),
      ~ !is.na(.) & . != "" & . != "##N/A##"
    )
  )




# 8. REGLAS OPERATIVAS (EDITABLE)--------------------------------

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


# 9. FECHAS Y DURACIONES -----------------------------------------------------

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


consolidado <- consolidado %>%
  mutate(


    dia_semana = ifelse(
      !is.na(datetime_i),
      weekdays(as.Date(datetime_i)),
      NA_character_
    ),
    
    dia_semana = recode(
      dia_semana,
      "Monday"    = "lunes",
      "Tuesday"   = "martes",
      "Wednesday" = "miércoles",
      "Thursday"  = "jueves",
      "Friday"    = "viernes",
      "Saturday"  = "sábado",
      "Sunday"    = "domingo"
    ),
    
    horario = ifelse(
      !is.na(datetime_i),
      ifelse(hour(datetime_i) < 12, "AM", "PM"),
      NA_character_
    ),
    

    # Flags de error temporal

    flag_na_datetime = is.na(datetime_i) | is.na(datetime_t),
    

    # Duración

    duracion_seg = as.numeric(difftime(datetime_t, datetime_i, units = "secs")),
    flag_duracion_negativa = duracion_seg < 0,
    
    duracion_seg = ifelse(flag_na_datetime | flag_duracion_negativa, NA, duracion_seg),
    duracion_min = duracion_seg / 60
  )


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


reporte_generico <- function(data, ...) {
  

  
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
      pct_error_fecha = ifelse(
        n_total > 0,
        100 * n_error_fecha / n_total,
        NA_real_
      ),

      n_regla_operativa = sum(flag_regla_operativa, na.rm = TRUE),
      pct_regla_operativa = ifelse(
        n_total > 0,
        100 * n_regla_operativa / n_total,
        NA_real_
      ),

      n_validos = sum(!is.na(duracion_min_limpia)),
      

      # OUTLIERS

      n_outliers = sum(
        flag_outlier_estadistico & !is.na(duracion_min_limpia),
        na.rm = TRUE
      ),
      
      pct_outliers = ifelse(
        n_total > 0,
        100 * n_outliers / n_total,
        NA_real_
      ),
      

      # VÁLIDOS SIN OUTLIERS

      n_validos_sin_outliers = sum(
        !is.na(duracion_min_limpia) & !flag_outlier_estadistico
      ),
      

      # DISTRIBUCIÓN (solo válidos sin outliers)

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




# 10. REPORTES ---------------------------------------------------------------------

# 10.1. reporte etapa -------------------------------------------------------------
reporte_etapa <- consolidado %>%
  filter(!is.na(etapa)) %>%
  reporte_generico(etapa)

# 10.2. reporte usuario -----------------------------------------------------------
reporte_por_responsible <- consolidado %>%
  filter(!is.na(responsible)) %>%
  reporte_generico(responsible)

# 10.3. reporte usuario etapa -----------------------------------------------------
reporte_por_responsible_etapa <- consolidado %>%
  filter(!is.na(responsible), !is.na(etapa)) %>%
  reporte_generico(responsible, etapa)

# 10.4. reporte encuesta etapa ----------------------------------------------------
reporte_origen_etapa <- consolidado %>%
  filter(!is.na(origen_df), !is.na(etapa)) %>%
  reporte_generico(encuesta, etapa)

# 10.5. reporte encuesta, etapa, usuario ------------------------------------------
reporte_origen_etapa_responsible <- consolidado %>%
  filter(!is.na(origen_df), !is.na(etapa), !is.na(responsible)) %>%
  reporte_generico(encuesta, etapa, responsible)


# 10.6. reporte de alerta  --------------------------------------------------
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


# 10.7. auditoria global -----------------------------------------------------

reporte_auditoria_global <- consolidado %>%
  summarise(
    total_registros = n(),
    
    errores_fecha = sum(flag_error_fecha, na.rm = TRUE),
    pct_errores_fecha = ifelse(
      total_registros > 0,
      100 * errores_fecha / total_registros,
      NA_real_
    ),
    
    reglas_operativa = sum(flag_regla_operativa, na.rm = TRUE),
    pct_reglas_operativa = ifelse(
      total_registros > 0,
      100 * reglas_operativa / total_registros,
      NA_real_
    ),
    
    outliers = sum(flag_outlier_estadistico, na.rm = TRUE),
    pct_outliers = ifelse(
      total_registros > 0,
      100 * outliers / total_registros,
      NA_real_
    )
  ) %>%
  mutate(
    across(c(total_registros, errores_fecha, reglas_operativa, outliers), fmt_num_cl),
    across(starts_with("pct_"), fmt_pct_cl)
  )



# 10.8. auditoria general -------------------------------------------------------

reporte_auditoria_fina <- consolidado %>%
  filter(!is.na(etapa), !is.na(origen_df), !is.na(responsible)) %>%
  group_by(encuesta, etapa, responsible) %>%
  summarise(
    n_total = n(),
    
    errores_fecha = sum(flag_error_fecha, na.rm = TRUE),
    pct_errores_fecha = ifelse(
      n_total > 0,
      100 * errores_fecha / n_total,
      NA_real_
    ),
    
    reglas_operativa = sum(flag_regla_operativa, na.rm = TRUE),
    pct_reglas_operativa = ifelse(
      n_total > 0,
      100 * reglas_operativa / n_total,
      NA_real_
    ),
    
    outliers = sum(flag_outlier_estadistico, na.rm = TRUE),
    pct_outliers = ifelse(
      n_total > 0,
      100 * outliers / n_total,
      NA_real_
    ),
    
    .groups = "drop"
  ) %>%
  mutate(
    across(starts_with("n_"), fmt_num_cl),
    across(starts_with("pct_"), fmt_pct_cl)
  )


# 10.9. reporte por horario --------------------------------------------------
reporte_por_horario <- consolidado %>%
  filter(!is.na(horario)) %>%
  reporte_generico(horario)



# 10.10. reporte por día de la semana ----------------------------------------
reporte_por_dia <- consolidado %>%
  filter(!is.na(dia_semana)) %>%
  reporte_generico(dia_semana)


# 10.11. reporte por día y horario -------------------------------------------
reporte_dia_horario <- consolidado %>%
  filter(!is.na(dia_semana), !is.na(horario)) %>%
  reporte_generico(dia_semana, horario)


# 10.12. reporte responsable por día ----------------------------------------
reporte_responsable_dia <- consolidado %>%
  filter(!is.na(responsible), !is.na(dia_semana)) %>%
  reporte_generico(responsible, dia_semana)

# 10.13. reporte responsable por horario ------------------------------------
reporte_responsable_horario <- consolidado %>%
  filter(!is.na(responsible), !is.na(horario)) %>%
  reporte_generico(responsible, horario)


# 11. EXPORTAR ------------------------------------------------------------------

# ========================================================================
# TABLAS REACTABLE – ESTÁNDAR ÚNICO (AUDITORÍA COMO NORMA)
# ========================================================================

library(reactable)
library(htmltools)

# ------------------------------------------------------------------------
# TEMA BASE (ÚNICO, SOBRIO, INSTITUCIONAL)
# ------------------------------------------------------------------------

tema_base <- reactableTheme(
  style = list(
    fontFamily = "system-ui",
    fontSize   = "0.95rem",
    color      = "#0f172a"
  ),
  headerStyle = list(
    backgroundColor = "#f8fafc",
    borderBottom    = "2px solid #e5e7eb",
    fontWeight      = "600",
    color           = "#334155"
  ),
  cellStyle = list(
    padding = "14px"
  ),
  highlightColor = "#f1f5f9"
)

# ------------------------------------------------------------------------
# HELPERS DE COLUMNAS (MISMO LENGUAJE AUDITORÍA)
# ------------------------------------------------------------------------

col_texto <- function(nombre) {
  colDef(name = nombre, align = "left")
}

col_numerica <- function(nombre) {
  colDef(
    name  = nombre,
    align = "center",
    style = list(fontWeight = "600")
  )
}

col_pct <- function(nombre) {
  colDef(
    name  = nombre,
    align = "center",
    style = list(fontWeight = "600")
  )
}

col_numerica_color <- function(nombre, color) {
  colDef(
    name  = nombre,
    align = "center",
    style = list(fontWeight = "600", color = color)
  )
}

col_numerica_condicional <- function(nombre) {
  colDef(
    name  = nombre,
    align = "center",
    style = function(value) {
      list(
        fontWeight = "600",
        color = if (as.numeric(gsub("\\.", "", value)) > 0)
          "#dc2626" else "#16a34a"
      )
    }
  )
}

# ------------------------------------------------------------------------
# DEFINICIÓN CANÓNICA DE COLUMNAS 
# ------------------------------------------------------------------------

columnas_estandar <- list(
  encuesta = col_texto("Encuesta"),
  etapa    = col_texto("Etapa"),
  responsible = col_texto("Responsable"),
  horario  = col_texto("Horario"),
  dia_semana = col_texto("Día"),
  
  n_total = col_numerica("Total registros"),
  
  n_error_fecha = col_numerica_condicional("Errores de fecha"),
  pct_error_fecha = col_pct("% errores de fecha"),
  
  n_regla_operativa = col_numerica_color("Errores operativos", "#b45309"),
  pct_regla_operativa = col_pct("% reglas operativas"),
  
  n_outliers = col_numerica_color("Outliers", "#7c2d12"),
  pct_outliers = col_pct("% outliers"),
  
  n_validos = col_numerica("Registros válidos"),
  n_validos_sin_outliers = col_numerica("Válidos sin outliers"),
  
  media   = col_texto("Duración media"),
  mediana = col_texto("Mediana"),
  minimo  = col_texto("Mínimo"),
  maximo  = col_texto("Máximo")
)

# ------------------------------------------------------------------------
# FILTRO SEGURO DE COLUMNAS 
# ------------------------------------------------------------------------

columnas_validas <- function(columnas, data) {
  columnas[names(columnas) %in% names(data)]
}

# ------------------------------------------------------------------------
# TABLA ESTÁNDAR 
# ------------------------------------------------------------------------

tabla_estandar <- function(data, paginar = TRUE) {
  
  reactable(
    data,
    searchable = TRUE,
    pagination = paginar,
    defaultPageSize = 8,
    bordered   = FALSE,
    highlight  = TRUE,
    striped    = FALSE,
    compact    = TRUE,
    
    columns = columnas_validas(columnas_estandar, data),
    theme   = tema_base
  )
}

# ------------------------------------------------------------------------
# DISPATCHER PRINCIPAL (AUDITORÍA ES UNA MÁS DEL SISTEMA)
# ------------------------------------------------------------------------

tabla_reporte <- function(tipo) {
  
  switch(
    tipo,
    
    # Auditoría
    "auditoria_global" = tabla_estandar(reporte_auditoria_global, paginar = FALSE),
    "auditoria_fina"   = tabla_estandar(reporte_auditoria_fina),
    
    # Alertas
    "alertas" = tabla_estandar(reporte_alerta),
    
    # Reportes operativos
    "etapa"                    = tabla_estandar(reporte_etapa),
    "responsable"              = tabla_estandar(reporte_por_responsible),
    "responsable_etapa"        = tabla_estandar(reporte_por_responsible_etapa),
    "origen_etapa"             = tabla_estandar(reporte_origen_etapa),
    "origen_etapa_responsable" = tabla_estandar(reporte_origen_etapa_responsible),
    "horario"                  = tabla_estandar(reporte_por_horario),
    "dia"                      = tabla_estandar(reporte_por_dia),
    "dia_horario"              = tabla_estandar(reporte_dia_horario),
    "responsable_dia"          = tabla_estandar(reporte_responsable_dia),
    "responsable_horario"      = tabla_estandar(reporte_responsable_horario),
    
    stop("Tipo de reporte no reconocido: ", tipo)
  )
}



dir_salida <- "tabulados"
dir_create(dir_salida)



dir_publicable <- "assets/tabulados"
dir_create(dir_publicable)


timestamp <- format(Sys.time(), "%Y%m%d_%H%M")
ruta_salida <- file.path(
  dir_salida,
  paste0("reporte_sv_", timestamp, ".xlsx")
)



# EXPORTACIÓN DE TABULADOS PUBLICABLES (DESCARGAS QMD)


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

write.xlsx(
  reporte_por_horario,
  file.path(dir_publicable, "R6_horario.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_por_dia,
  file.path(dir_publicable, "R7_dia_semana.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_dia_horario,
  file.path(dir_publicable, "R8_dia_horario.xlsx"),
  overwrite = TRUE
)


write.xlsx(
  reporte_responsable_dia,
  file.path(dir_publicable, "R9_responsable_dia.xlsx"),
  overwrite = TRUE
)

write.xlsx(
  reporte_responsable_horario,
  file.path(dir_publicable, "R10_responsable_horario.xlsx"),
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

add_sheet(wb, "R6 por horario",              reporte_por_horario)
add_sheet(wb, "R7 por día",                  reporte_por_dia)
add_sheet(wb, "R8 día y horario",            reporte_dia_horario)

add_sheet(wb, "R9 responsable por día",      reporte_responsable_dia)
add_sheet(wb, "R10 responsable por horario", reporte_responsable_horario)

add_sheet(wb, "R11 alerta",                  reporte_alerta)
add_sheet(wb, "Resumen global",              reporte_auditoria_global)
add_sheet(wb, "Auditoría fina",              reporte_auditoria_fina)



# ---- Guardado ----------------------------------------------------------

tryCatch(
  {
    saveWorkbook(wb, ruta_salida, overwrite = TRUE)

    message("Excel generado correctamente")
    message("Ruta: ", normalizePath(ruta_salida))
    message("Hojas: 13")
  },
  error = function(e) {
    message("Error al generar el Excel:")
    message(e$message)
  }
)


# 12. TIEMPO TOTAL DE EJECUCIÓN -------------------------------------------

tiempo_ejecucion <- Sys.time() - t_inicio
message("Reporte generado correctamente")
message("Tiempo total de ejecución: ", round(tiempo_ejecucion, 2))

