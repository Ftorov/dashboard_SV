# =========================================================
# GRÁFICO COBERTURA DE REGISTROS — ECHARTS
# =========================================================

library(htmlwidgets)
library(echarts4r)
library(dplyr)
library(tidyr)
library(purrr)


prep_registros_calidad <- function(tabla_reporte)
{ tabla_reporte %>%
    transmute( evaluados = as.numeric(gsub("\\.", "", n_total)),
               validos = as.numeric(gsub("\\.", "", n_validos)),
               sin_out = as.numeric(gsub("\\.", "", n_validos_sin_outliers)) ) %>%
    summarise( evaluados = sum(evaluados, na.rm = TRUE),
               validos = sum(validos, na.rm = TRUE),
               sin_out = sum(sin_out, na.rm = TRUE) ) %>%
    pivot_longer( everything(),
                  names_to = "estado", values_to = "n" ) %>%
    mutate( estado = factor( estado, levels = c("evaluados", "validos", "sin_out"),
                             labels = c( "Registros evaluados", "Registros válidos", "Válidos sin outliers" ) ) ) }

plot_cobertura_registros <- function(
    tabla_reporte,
    titulo,
    subtitulo
) {
  
  datos <- prep_registros_calidad(tabla_reporte) %>%
    mutate(
      color = c("#2F5597", "#6AA84F", "#CC4125")
    )
  
  datos %>%
    e_charts(estado) %>%
    e_bar(
      n,
      barMaxWidth = 42,
      itemStyle = JS("
        function(params){
          return { color: params.data.color };
        }
      ")
    ) %>%
    e_flip_coords() %>%
    e_legend(FALSE) %>%
    e_tooltip(
      trigger = "axis",
      axisPointer = list(type = "shadow"),
      formatter = JS("
        function(params){
          var p = params[0];
          var v = p.value;

          if (Array.isArray(v)) v = v[0];
          if (typeof v === 'string')
            v = Number(v.replace(/\\./g,'').replace(',','.'));

          var formatted = v
            .toFixed(0)
            .replace(/\\B(?=(\\d{3})+(?!\\d))/g, '.');

          return '<b>' + p.axisValue + '</b><br/>' + formatted;
        }
      ")
    ) %>%
    e_x_axis(
      axisLabel = list(
        formatter = JS(
          "function(v){ return v.toLocaleString('es-CL'); }"
        )
      )
    ) %>%
    e_title(
      text = titulo,
      subtext = subtitulo,
      left = "center"
    ) %>%
    e_grid(
      left = 40,
      right = 20,
      top = 70,
      bottom = 10,
      containLabel = TRUE
    )
}




# horario y dia de la semana ----------------------------------------------

prep_dia_franja <- function(consolidado) {
  consolidado %>%
    dplyr::filter(
      !is.na(datetime_i),
      !is.na(dia_semana),
      !is.na(horario)
    ) %>%
    dplyr::mutate(
      dia_semana = factor(
        dia_semana,
        levels = c(
          "lunes", "martes", "miércoles",
          "jueves", "viernes", "sábado", "domingo"
        )
      ),
      horario = factor(horario, levels = c("AM", "PM"))
    )
}

# Base para gráficos
consolidado_grafico <- prep_dia_franja(consolidado)



grafico_am_pm <- function(
    data,
    encuesta = NULL,
    etapa    = NULL
) {
  
  # -----------------------------
  # Filtros explícitos
  # -----------------------------
  df <- data
  
  if (!is.null(encuesta)) {
    df <- df[df$encuesta == encuesta, ]
  }
  
  if (!is.null(etapa)) {
    df <- df[df$etapa == etapa, ]
  }
  
  # -----------------------------
  # Validación
  # -----------------------------
  if (nrow(df) == 0) {
    stop("No hay datos para la combinación solicitada")
  }
  
  n_total <- nrow(df)  # <- aquí están las 245
  
  # -----------------------------
  # Serie día x franja (ABSOLUTA)
  # -----------------------------
  serie <- df %>%
    dplyr::group_by(dia_semana, horario) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    tidyr::pivot_wider(
      names_from  = horario,
      values_from = n,
      values_fill = 0
    )
  
  # -----------------------------
  # Título
  # -----------------------------
  titulo <- paste(
    "Distribución de entrevistas",
    if (!is.null(encuesta)) paste("—", encuesta) else "",
    if (!is.null(etapa)) paste("(", etapa, ")") else ""
  )
  
  subtitulo <- paste(
    "Total entrevistas:",
    format(n_total, big.mark = ".", decimal.mark = ","),
    "· AM vs PM por día"
  )
  
  # -----------------------------
  # Gráfico
  # -----------------------------
  serie %>%
    echarts4r::e_charts(dia_semana) %>%
    echarts4r::e_line(AM, name = "AM", smooth = TRUE, symbol = "circle") %>%
    echarts4r::e_line(PM, name = "PM", smooth = TRUE, symbol = "circle") %>%
    echarts4r::e_tooltip(trigger = "axis") %>%
    echarts4r::e_legend(FALSE) %>%
    echarts4r::e_y_axis(name = "Número de entrevistas") %>%
    echarts4r::e_title(
      text = titulo,
      subtext = subtitulo,
      left = "center"
    )
}

