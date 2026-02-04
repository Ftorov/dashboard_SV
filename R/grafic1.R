# =========================================================
# GRÁFICOS OPERATIVOS — PREPARACIÓN Y FUNCIONES
# =========================================================

library(dplyr)
library(lubridate)
library(tidyr)
library(echarts4r)
library(ggplot2)

# ---------------------------------------------------------
# 1) PREPARACIÓN BASE: día de semana + franja AM/PM
# ---------------------------------------------------------

prep_dia_franja <- function(consolidado) {
  consolidado %>%
    filter(!is.na(datetime_i)) %>%
    mutate(
      dia_semana = factor(
        lubridate::wday(
          datetime_i,
          label = TRUE,
          abbr = FALSE,
          week_start = 1
        ),
        levels = c(
          "lunes", "martes", "miércoles",
          "jueves", "viernes", "sábado", "domingo"
        )
      ),
      franja = if_else(lubridate::hour(datetime_i) < 12, "AM", "PM")
    )
}

# ---------------------------------------------------------
# 2) SERIE AM / PM POR DÍA (GLOBAL O POR ENCUESTA)
# ---------------------------------------------------------

serie_am_pm <- function(df) {
  df %>%
    group_by(dia_semana, franja) %>%
    summarise(n = n(), .groups = "drop") %>%
    pivot_wider(
      names_from = franja,
      values_from = n,
      values_fill = 0
    )
}

serie_am_pm_encuesta <- function(df) {
  df %>%
    group_by(encuesta, dia_semana, franja) %>%
    summarise(n = n(), .groups = "drop") %>%
    pivot_wider(
      names_from = franja,
      values_from = n,
      values_fill = 0
    )
}

# ---------------------------------------------------------
# 3) GRÁFICO LÍNEAS AM / PM (ECHARTS)
# ---------------------------------------------------------

plot_lineas_am_pm <- function(df, titulo) {
  df %>%
    e_charts(dia_semana) %>%
    e_line(AM, name = "AM", smooth = TRUE, symbol = "circle") %>%
    e_line(PM, name = "PM", smooth = TRUE, symbol = "circle") %>%
    e_tooltip(trigger = "axis") %>%
    e_legend(orient = "vertical", right = 10, top = "middle") %>%
    e_x_axis(
      name = "Día de la semana",
      nameLocation = "middle",
      nameGap = 30
    ) %>%
    e_y_axis(name = "Número de entrevistas") %>%
    e_title(
      text = titulo,
      subtext = "Comparación AM vs PM",
      left = "center"
    )
}



# # Cargar funciones
# source("R/graficos_operativos.R")
# 
# # Preparar datos
# consolidado_grafico <- prep_dia_franja(consolidado)
# 
# # Serie para una encuesta específica
# serie <- consolidado_grafico %>%
#   filter(encuesta == "ENI") %>%
#   serie_am_pm()
# 
# # Gráfico
# plot_lineas_am_pm(
#   serie,
#   titulo = "Entrevistas por día de la semana — ENI"
# )







# ---------------------------------------------------------
# 4) HEATMAP HORARIO (GGPLOT — ROBUSTO)
# ---------------------------------------------------------

plot_heatmap_horario <- function(heatmap_df, encuesta) {
  heatmap_df %>%
    filter(
      dia %in% c("lunes", "martes", "miércoles", "jueves", "viernes")
    ) %>%
    mutate(
      dia = factor(
        dia,
        levels = c(
          "lunes", "martes", "miércoles",
          "jueves", "viernes"
        )
      )
    ) %>%
    ggplot(
      aes(x = hora, y = dia, fill = value)
    ) +
    geom_tile(color = "white", linewidth = 0.2) +
    scale_fill_viridis_c(option = "C", name = "Entrevistas") +
    labs(
      title = "Distribución horaria del trabajo (08–19)",
      subtitle = paste("Heatmap lunes a viernes —", encuesta),
      x = "Hora del día",
      y = "Día de la semana"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      panel.grid = element_blank(),
      legend.position = "right"
    )
}



plot_heatmap_horario(
  heatmap_df,
  encuesta = "ENI"
)






library(echarts4r)
library(dplyr)
library(tidyr)
library(purrr)


# 1) CALIDAD — BARRA HORIZONTAL (%)

grafico_calidad <- function(fila) {
  
  datos <- tibble(
    indicador = c("Error fecha", "Regla operativa", "Outliers"),
    valor = as.numeric(
      gsub(",", ".", c(
        fila$pct_error_fecha,
        fila$pct_regla_operativa,
        fila$pct_outliers
      ))
    )
  ) 
  
  datos %>%
    e_charts(indicador) %>%
    e_bar(
      valor,
      name = "Porcentaje",
      barMaxWidth = 38,
      itemStyle = list(
        color = "#1E3B7D"   
      )) %>%
    e_flip_coords() %>%
    e_tooltip(
      trigger = "axis",
      axisPointer = list(type = "shadow"),
      formatter = htmlwidgets::JS("
        function(params){
          var p = params[0];
          var v = p.value;
          if (Array.isArray(v)) v = v[0];
          else if (typeof v === 'object' && v !== null && 'value' in v) v = v.value;
          return '<b>' + p.axisValue + '</b><br/>' +
                 Number(v).toLocaleString('es-CL',
                   { minimumFractionDigits: 2, maximumFractionDigits: 2 }
                 ) + ' %';
        }
      ")
    ) %>%
    e_x_axis(
      max = 100,
      axisLabel = list(
        formatter = htmlwidgets::JS("function(v){ return v + '%'; }")
      )
    ) %>%
    e_legend(FALSE) %>%
    e_title("") %>% 
    e_animation(duration = 1200, easing = "elasticOut") %>% 
    e_grid(top = 110, left = 30, right = 30, bottom = 10, containLabel = TRUE) 
}



# fila <- reporte_origen_etapa %>%
#   filter(encuesta == "ENI", etapa == "Consistencia")
# 
# grafico_calidad(fila)
