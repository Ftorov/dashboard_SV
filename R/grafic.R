library(htmlwidgets)
library(echarts4r)
library(dplyr)
library(tidyr)
library(purrr)
library(knitr)
library(lubridate)

# 1. GRÁFICO COBERTURA DE REGISTROS ------------------------------------------

# PREPARACIÓN DE DATOS

prep_registros_calidad <- function(tabla_reporte) {
  
  tabla_reporte %>%
    transmute(
      evaluados = as.numeric(gsub("\\.", "", n_total)),
      validos   = as.numeric(gsub("\\.", "", n_validos)),
      sin_out   = as.numeric(gsub("\\.", "", n_validos_sin_outliers))
    ) %>%
    summarise(
      evaluados = sum(evaluados, na.rm = TRUE),
      validos   = sum(validos,   na.rm = TRUE),
      sin_out   = sum(sin_out,   na.rm = TRUE)
    ) %>%
    pivot_longer(
      everything(),
      names_to  = "estado",
      values_to = "n"
    ) %>%
    mutate(
      estado = factor(
        estado,
        levels = c("evaluados", "validos", "sin_out"),
        labels = c(
          "Registros evaluados",
          "Registros válidos",
          "Válidos sin outliers"
        )
      )
    )
}


# GRÁFICO PRINCIPAL

plot_cobertura_registros <- function(
    tabla_reporte,
    titulo,
    subtitulo
) {
  

  # VALIDACIÓN 1: SIN FILAS

  if (is.null(tabla_reporte) || nrow(tabla_reporte) == 0) {
    return(
      knitr::asis_output(
        ""
      )
    )
  }
  
  datos <- prep_registros_calidad(tabla_reporte)
  

  # VALIDACIÓN 2: SIN VALORES NUMÉRICOS

  if (sum(datos$n, na.rm = TRUE) == 0) {
    return(
      knitr::asis_output(
        ""
      )
    )
  }
  

  # COLORES

  datos <- datos %>%
    mutate(color = c("#2F5597", "#6AA84F", "#CC4125"))
  

  # GRÁFICO

  datos %>%
    e_charts(estado) %>%
    e_bar(
      n,
      barMaxWidth = 42,
      itemStyle = JS("
        function(params){
          return { color: params.data.color };
        }
      "),
      label = list(
        show = TRUE,
        position = "insideRight",
        color = "#FFFFFF",
        fontWeight = "bold",
        formatter = JS("
          function(params){
            var v = params.value;
            if (Array.isArray(v)) v = v[0];
            if (typeof v === 'string')
              v = Number(v.replace(/\\./g,'').replace(',','.'));
            return v
              .toFixed(0)
              .replace(/\\B(?=(\\d{3})+(?!\\d))/g, '.');
          }
        ")
      )
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
          return '<b>' + p.axisValue + '</b><br>' +
                 v.toLocaleString('es-CL');
        }
      ")
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
    ) %>%
    e_toolbox(
      show   = TRUE,
      orient = "horizontal",
      right  = 10,
      top    = 10
    ) %>%
    e_toolbox_feature("saveAsImage") %>%
    e_toolbox_feature("magicType", type = c("bar", "line")) %>%
    e_animation(
      duration = 900,
      easing   = "cubicOut"
    )
}




# 2. GRAFICO HORARIO Y DIA DE LA SEMANA --------------------------------------


# PREPARACIÓN BASE

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


# FUNCIÓN DE GRÁFICO

grafico_am_pm <- function(
    data,
    encuesta = NULL,
    etapa    = NULL
) {
  

  # FILTROS

  df <- data
  
  if (!is.null(encuesta)) {
    df <- df[df$encuesta == encuesta, ]
  }
  
  if (!is.null(etapa)) {
    df <- df[df$etapa == etapa, ]
  }
  

  # VALIDACIÓN: SIN FILAS

  if (is.null(df) || nrow(df) == 0) {
    return(
      knitr::asis_output(
        "
        "
      )
    )
  }
  
  n_total <- nrow(df)
  

  # SERIE DÍA × FRANJA

  serie <- df %>%
    dplyr::group_by(dia_semana, horario) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    tidyr::pivot_wider(
      names_from  = horario,
      values_from = n,
      values_fill = 0
    )
  

  # VALIDACIÓN: SIN VALORES

  if (sum(serie$AM + serie$PM, na.rm = TRUE) == 0) {
    return(
      knitr::asis_output(
        ""
      )
    )
  }
  

  # TÍTULOS

  titulo <- paste(
    "Distribución de entrevistas",
    if (!is.null(encuesta)) paste("—", encuesta) else "",
    if (!is.null(etapa)) paste("—", etapa) else ""
  )
  
  subtitulo <- paste(
    "Total entrevistas:",
    format(n_total, big.mark = ".", decimal.mark = ","),
    "· AM vs PM por día"
  )
  

  # GRÁFICO

  serie %>%
    echarts4r::e_charts(dia_semana) %>%
    echarts4r::e_line(
      AM,
      name = "AM",
      smooth = TRUE,
      symbol = "circle"
    ) %>%
    echarts4r::e_line(
      PM,
      name = "PM",
      smooth = TRUE,
      symbol = "circle"
    ) %>%
    echarts4r::e_tooltip(trigger = "axis") %>%
    echarts4r::e_legend(
      show   = TRUE,
      orient = "vertical",
      right  = 10,
      top    = "middle"
    ) %>%
    echarts4r::e_y_axis(name = "Número de entrevistas") %>%
    echarts4r::e_title(
      text     = titulo,
      subtext = subtitulo,
      left     = "center"
    ) %>%
    echarts4r::e_toolbox(
      show   = TRUE,
      orient = "horizontal",
      right  = 10,
      top    = 10
    ) %>%
    echarts4r::e_toolbox_feature("saveAsImage") %>%
    echarts4r::e_toolbox_feature("magicType", type = c("bar", "line")) %>%
    echarts4r::e_animation(
      duration = 900,
      easing   = "cubicOut"
    )
}



# 3. HEATMAP DIA Y HORARIO -----------------------------------------------------------------




plot_heatmap_horario_etapa <- function(
    consolidado,
    encuesta_sel,
    etapa_sel
) {

  # 1) FILTRO

  df <- consolidado %>%
    dplyr::filter(
      !is.na(datetime_i),
      .data[["encuesta"]] == encuesta_sel,
      .data[["etapa"]]    == etapa_sel
    ) %>%
    dplyr::mutate(
      dia  = weekdays(as.Date(datetime_i)),
      hora = lubridate::hour(datetime_i)
    ) %>%
    dplyr::filter(
      dia %in% c("lunes", "martes", "miércoles", "jueves", "viernes"),
      hora >= 8,
      hora <= 18
    )
  

  # VALIDACIÓN 1: SIN FILAS

  if (is.null(df) || nrow(df) == 0) {
    return(
      knitr::asis_output(
        ""
      )
    )
  }
  

  # 2) AGREGACIÓN PARA HEATMAP

  horas_levels <- sprintf("%02d", 8:18)
  
  heatmap_df <- df %>%
    dplyr::mutate(
      hora = factor(
        sprintf("%02d", hora),
        levels = horas_levels
      ),
      dia = factor(
        dia,
        levels = c(
          "lunes",
          "martes",
          "miércoles",
          "jueves",
          "viernes"
        )
      )
    ) %>%
    dplyr::count(dia, hora, name = "value") %>%
    tidyr::complete(
      dia,
      hora,
      fill = list(value = 0)
    )
  

  # VALIDACIÓN 2: SIN VALORES

  if (sum(heatmap_df$value, na.rm = TRUE) == 0) {
    return(
      knitr::asis_output(
        ""
      )
    )
  }
  

  # 3) ECHARTS HEATMAP

  heatmap_df %>%
    e_charts(hora) %>%
    e_heatmap(
      dia,
      value,
      label = list(
        show = TRUE,
        formatter = JS("
          function(params){
            return params.value[2] === 0 ? '' : params.value[2];
          }
        ")
      )
    ) %>%
    e_visual_map(
      value,
      calculable = TRUE,
      orient = "vertical",
      right = 10,
      top = "middle"
    ) %>%
    e_x_axis(
      type = "category",
      data = horas_levels,
      name = "Hora del día",
      nameLocation = "middle",
      nameGap = 30
    ) %>%
    e_y_axis(
      name = "Día de la semana"
    ) %>%
    e_title(
      text = "Distribución horaria del trabajo (08:00 a 18:59)",
      subtext = paste(encuesta_sel, "—", etapa_sel),
      left = "center"
    ) %>%
    e_tooltip(
      trigger = "item",
      formatter = JS("
        function (params) {
          var hora = params.value[0];
          var dia  = params.value[1];
          var val  = params.value[2];

          if (val === 0) return '';

          return (
            '<b>' + dia + '</b><br/>' +
            'Hora: ' + hora + ':00 a ' + hora + ':59<br/>' +
            'Supervisiones: ' + val
          );
        }
      ")
    ) %>%
    e_grid(
      left = 80,
      right = 80,
      top = 80,
      bottom = 40
    ) %>%
    e_toolbox(
      show   = TRUE,
      orient = "horizontal",
      right  = 10,
      top    = 10
    ) %>%
    e_toolbox_feature("saveAsImage")
}
