

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





