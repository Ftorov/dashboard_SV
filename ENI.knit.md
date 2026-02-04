---
title: ""
subtitle: "Seguimiento de cobertura, calidad y tiempos por etapa del proceso de supervisión"
---







::: panel-tabset
## Verificación






::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-clock"></i>
<span>Duración media</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Promedio del tiempo de respuesta calculado sobre registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:01:16</span>
</div>
</div>
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-arrow-down"></i>
<span>Duración mínima</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Menor tiempo de respuesta observado entre los registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:00:29</span>
</div>
</div>
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-arrow-up"></i>
<span>Duración máxima</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Mayor tiempo de respuesta observado entre los registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:03:42</span>
</div>
</div>
</div>
```

:::
:::




::: columns
::: {.column width="70%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-a5a188d6ccd08d92ecc3" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-a5a188d6ccd08d92ecc3">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"xAxis":[{"show":true}],"yAxis":[{"data":["Registros evaluados","Registros válidos","Válidos sin outliers"],"type":"category","boundaryGap":true}],"legend":{"data":["n"],"show":false,"type":"plain"},"series":[{"data":[{"value":["245","Registros evaluados"]},{"value":["242","Registros válidos"]},{"value":["230","Válidos sin outliers"]}],"name":"n","type":"bar","yAxisIndex":0,"xAxisIndex":0,"coordinateSystem":"cartesian2d","barMaxWidth":42,"itemStyle":"\n        function(params){\n          return { color: params.data.color };\n        }\n      ","label":{"show":true,"position":"insideRight","color":"#FFFFFF","fontWeight":"bold","formatter":"\n          function(params){\n            var v = params.value;\n            if (Array.isArray(v)) v = v[0];\n            if (typeof v === 'string')\n              v = Number(v.replace(/\\./g,'').replace(',','.'));\n            return v\n              .toFixed(0)\n              .replace(/\\B(?=(\\d{3})+(?!\\d))/g, '.');\n          }\n        "}}],"tooltip":{"trigger":"axis","axisPointer":{"type":"shadow"},"formatter":"\n        function(params){\n          var p = params[0];\n          var v = p.value;\n          if (Array.isArray(v)) v = v[0];\n          if (typeof v === 'string')\n            v = Number(v.replace(/\\./g,'').replace(',','.'));\n          return '<b>' + p.axisValue + '<\/b><br>' +\n                 v.toLocaleString('es-CL');\n        }\n      "},"title":[{"left":"center","text":"Cobertura de registros","subtext":"ENI — Verificación"}],"grid":[{"left":40,"right":20,"top":70,"bottom":10,"containLabel":true}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[],"magicType":{"type":["bar","line"]}}},"animation":true,"animationDuration":900,"animationEasing":"cubicOut"},"dispose":true},"evals":["opts.series.0.itemStyle","opts.series.0.label.formatter","opts.tooltip.formatter"],"jsHooks":[]}</script>
```

:::
:::



:::

::: {.column width="30%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card risk ok">
<div class="kpi-head">
<i class="bi bi-calendar-x"></i>
<span>Error en registro de fecha</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros con inconsistencias temporales, definidas como fechas u horas faltantes o duraciones negativas entre inicio y término. El denominador corresponde al total de registros procesados en la etapa analizada.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">0,00%</span>
</div>
<div class="kpi-sub">0 registros</div>
</div>
<div class="kpi-card risk warn">
<div class="kpi-head">
<i class="bi bi-shield-x"></i>
<span>Regla operativa</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros cuya duración incumple los umbrales mínimos o máximos definidos por encuesta y etapa. El cálculo se realiza sobre el total de registros.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">1,22%</span>
</div>
<div class="kpi-sub">3 registros</div>
</div>
<div class="kpi-card risk bad">
<div class="kpi-head">
<i class="bi bi-exclamation-circle"></i>
<span>Outliers</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros con duraciones atípicas identificadas mediante criterios estadísticos (IQR de Tukey y Z-MAD), calculado sobre el total de registros con duración válida.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">4,90%</span>
</div>
<div class="kpi-sub">12 registros</div>
</div>
</div>
```

:::
:::



:::
:::




::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-clipboard-data"></i>
<span>Registros evaluados</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Total de registros procesados en la etapa considerada.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">245</span>
</div>
</div>
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-check-lg"></i>
<span>Registros válidos</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Número de registros cuya duración cumple las reglas operativas definidas.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">242</span>
</div>
</div>
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-check-circle"></i>
<span>Válidos sin outliers</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Registros válidos que no presentan valores atípicos y que conforman la base final para el análisis.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">230</span>
</div>
</div>
</div>
```

:::
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-fef38585e07e45ef7059" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-fef38585e07e45ef7059">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"yAxis":[{"show":true,"name":"Número de entrevistas"}],"xAxis":[{"data":["lunes","martes","miércoles","jueves","viernes"],"type":"category","boundaryGap":true}],"legend":{"data":["AM","PM"],"show":true,"type":"plain","orient":"vertical","right":10,"top":"middle"},"series":[{"data":[{"value":["lunes","12"]},{"value":["martes","25"]},{"value":["miércoles","29"]},{"value":["jueves","23"]},{"value":["viernes","15"]}],"yAxisIndex":0,"xAxisIndex":0,"name":"AM","type":"line","coordinateSystem":"cartesian2d","smooth":true,"symbol":"circle"},{"data":[{"value":["lunes","29"]},{"value":["martes","32"]},{"value":["miércoles","46"]},{"value":["jueves","20"]},{"value":["viernes","14"]}],"yAxisIndex":0,"xAxisIndex":0,"name":"PM","type":"line","coordinateSystem":"cartesian2d","smooth":true,"symbol":"circle"}],"tooltip":{"trigger":"axis"},"title":[{"left":"center","text":"Distribución de entrevistas — ENI — Verificación","subtext":"Total entrevistas: 245 · AM vs PM por día"}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[],"magicType":{"type":["bar","line"]}}},"animation":true,"animationDuration":900,"animationEasing":"cubicOut"},"dispose":true},"evals":[],"jsHooks":[]}</script>
```

:::
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-67b64207970b8a71f7f2" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-67b64207970b8a71f7f2">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"yAxis":[{"data":["lunes","martes","miércoles","jueves","viernes"],"name":"Día de la semana"}],"xAxis":[{"data":["08","09","10","11","12","13","14","15","16","17","18"],"type":"category","name":"Hora del día","nameLocation":"middle","nameGap":30}],"series":[{"data":[{"value":["08","lunes"," 1"]},{"value":["09","lunes"," 5"]},{"value":["10","lunes"," 3"]},{"value":["11","lunes"," 3"]},{"value":["12","lunes"," 0"]},{"value":["13","lunes"," 0"]},{"value":["14","lunes"," 5"]},{"value":["15","lunes","17"]},{"value":["16","lunes"," 7"]},{"value":["17","lunes"," 0"]},{"value":["18","lunes"," 0"]},{"value":["08","martes"," 0"]},{"value":["09","martes"," 8"]},{"value":["10","martes","11"]},{"value":["11","martes"," 6"]},{"value":["12","martes"," 8"]},{"value":["13","martes"," 0"]},{"value":["14","martes","14"]},{"value":["15","martes"," 7"]},{"value":["16","martes"," 2"]},{"value":["17","martes"," 1"]},{"value":["18","martes"," 0"]},{"value":["08","miércoles"," 6"]},{"value":["09","miércoles"," 6"]},{"value":["10","miércoles"," 7"]},{"value":["11","miércoles","10"]},{"value":["12","miércoles"," 7"]},{"value":["13","miércoles"," 1"]},{"value":["14","miércoles","16"]},{"value":["15","miércoles","10"]},{"value":["16","miércoles","12"]},{"value":["17","miércoles"," 0"]},{"value":["18","miércoles"," 0"]},{"value":["08","jueves"," 2"]},{"value":["09","jueves"," 7"]},{"value":["10","jueves"," 8"]},{"value":["11","jueves"," 6"]},{"value":["12","jueves"," 0"]},{"value":["13","jueves"," 1"]},{"value":["14","jueves"," 4"]},{"value":["15","jueves"," 8"]},{"value":["16","jueves"," 7"]},{"value":["17","jueves"," 0"]},{"value":["18","jueves"," 0"]},{"value":["08","viernes"," 0"]},{"value":["09","viernes"," 1"]},{"value":["10","viernes"," 5"]},{"value":["11","viernes"," 9"]},{"value":["12","viernes"," 5"]},{"value":["13","viernes"," 1"]},{"value":["14","viernes"," 2"]},{"value":["15","viernes"," 2"]},{"value":["16","viernes"," 3"]},{"value":["17","viernes"," 1"]},{"value":["18","viernes"," 0"]}],"name":null,"type":"heatmap","coordinateSystem":"cartesian2d","label":{"show":true,"formatter":"\n          function(params){\n            return params.value[2] === 0 ? '' : params.value[2];\n          }\n        "}}],"visualMap":[{"orient":"vertical","right":10,"top":"middle","calculable":true,"type":"continuous","min":0,"max":17}],"title":[{"left":"center","text":"Distribución horaria del trabajo (08:00 a 18:59)","subtext":"ENI — Verificación"}],"tooltip":{"trigger":"item","formatter":"\n        function (params) {\n          var hora = params.value[0];\n          var dia  = params.value[1];\n          var val  = params.value[2];\n\n          if (val === 0) return '';\n\n          return (\n            '<b>' + dia + '<\/b><br/>' +\n            'Hora: ' + hora + ':00 a ' + hora + ':59<br/>' +\n            'Supervisiones: ' + val\n          );\n        }\n      "},"grid":[{"left":80,"right":80,"top":80,"bottom":40}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[]}}},"dispose":true},"evals":["opts.series.0.label.formatter","opts.tooltip.formatter"],"jsHooks":[]}</script>
```

:::
:::




## Recolección




::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-clock"></i>
<span>Duración media</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Promedio del tiempo de respuesta calculado sobre registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:00:52</span>
</div>
</div>
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-arrow-down"></i>
<span>Duración mínima</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Menor tiempo de respuesta observado entre los registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:00:18</span>
</div>
</div>
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-arrow-up"></i>
<span>Duración máxima</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Mayor tiempo de respuesta observado entre los registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:05:22</span>
</div>
</div>
</div>
```

:::
:::




::: columns
::: {.column width="70%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-8c71825095970b27caaa" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-8c71825095970b27caaa">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"xAxis":[{"show":true}],"yAxis":[{"data":["Registros evaluados","Registros válidos","Válidos sin outliers"],"type":"category","boundaryGap":true}],"legend":{"data":["n"],"show":false,"type":"plain"},"series":[{"data":[{"value":["3395","Registros evaluados"]},{"value":["2072","Registros válidos"]},{"value":["2046","Válidos sin outliers"]}],"name":"n","type":"bar","yAxisIndex":0,"xAxisIndex":0,"coordinateSystem":"cartesian2d","barMaxWidth":42,"itemStyle":"\n        function(params){\n          return { color: params.data.color };\n        }\n      ","label":{"show":true,"position":"insideRight","color":"#FFFFFF","fontWeight":"bold","formatter":"\n          function(params){\n            var v = params.value;\n            if (Array.isArray(v)) v = v[0];\n            if (typeof v === 'string')\n              v = Number(v.replace(/\\./g,'').replace(',','.'));\n            return v\n              .toFixed(0)\n              .replace(/\\B(?=(\\d{3})+(?!\\d))/g, '.');\n          }\n        "}}],"tooltip":{"trigger":"axis","axisPointer":{"type":"shadow"},"formatter":"\n        function(params){\n          var p = params[0];\n          var v = p.value;\n          if (Array.isArray(v)) v = v[0];\n          if (typeof v === 'string')\n            v = Number(v.replace(/\\./g,'').replace(',','.'));\n          return '<b>' + p.axisValue + '<\/b><br>' +\n                 v.toLocaleString('es-CL');\n        }\n      "},"title":[{"left":"center","text":"Cobertura de registros","subtext":"ENI — Recolección"}],"grid":[{"left":40,"right":20,"top":70,"bottom":10,"containLabel":true}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[],"magicType":{"type":["bar","line"]}}},"animation":true,"animationDuration":900,"animationEasing":"cubicOut"},"dispose":true},"evals":["opts.series.0.itemStyle","opts.series.0.label.formatter","opts.tooltip.formatter"],"jsHooks":[]}</script>
```

:::
:::



:::

::: {.column width="30%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card risk ok">
<div class="kpi-head">
<i class="bi bi-calendar-x"></i>
<span>Error en registro de fecha</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros con inconsistencias temporales, definidas como fechas u horas faltantes o duraciones negativas entre inicio y término. El denominador corresponde al total de registros procesados en la etapa analizada.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">0,00%</span>
</div>
<div class="kpi-sub">0 registros</div>
</div>
<div class="kpi-card risk bad">
<div class="kpi-head">
<i class="bi bi-shield-x"></i>
<span>Regla operativa</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros cuya duración incumple los umbrales mínimos o máximos definidos por encuesta y etapa. El cálculo se realiza sobre el total de registros.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">38,97%</span>
</div>
<div class="kpi-sub">1.323 registros</div>
</div>
<div class="kpi-card risk warn">
<div class="kpi-head">
<i class="bi bi-exclamation-circle"></i>
<span>Outliers</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros con duraciones atípicas identificadas mediante criterios estadísticos (IQR de Tukey y Z-MAD), calculado sobre el total de registros con duración válida.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">0,77%</span>
</div>
<div class="kpi-sub">26 registros</div>
</div>
</div>
```

:::
:::



:::
:::




::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-clipboard-data"></i>
<span>Registros evaluados</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Total de registros procesados en la etapa considerada.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">3.395</span>
</div>
</div>
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-check-lg"></i>
<span>Registros válidos</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Número de registros cuya duración cumple las reglas operativas definidas.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">2.072</span>
</div>
</div>
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-check-circle"></i>
<span>Válidos sin outliers</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Registros válidos que no presentan valores atípicos y que conforman la base final para el análisis.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">2.046</span>
</div>
</div>
</div>
```

:::
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-ef9e5b5c880867287c75" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-ef9e5b5c880867287c75">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"yAxis":[{"show":true,"name":"Número de entrevistas"}],"xAxis":[{"data":["lunes","martes","miércoles","jueves","viernes"],"type":"category","boundaryGap":true}],"legend":{"data":["AM","PM"],"show":true,"type":"plain","orient":"vertical","right":10,"top":"middle"},"series":[{"data":[{"value":["lunes","442"]},{"value":["martes","157"]},{"value":["miércoles"," 80"]},{"value":["jueves","529"]},{"value":["viernes","474"]}],"yAxisIndex":0,"xAxisIndex":0,"name":"AM","type":"line","coordinateSystem":"cartesian2d","smooth":true,"symbol":"circle"},{"data":[{"value":["lunes","443"]},{"value":["martes"," 64"]},{"value":["miércoles","305"]},{"value":["jueves","598"]},{"value":["viernes","303"]}],"yAxisIndex":0,"xAxisIndex":0,"name":"PM","type":"line","coordinateSystem":"cartesian2d","smooth":true,"symbol":"circle"}],"tooltip":{"trigger":"axis"},"title":[{"left":"center","text":"Distribución de entrevistas — ENI — Recolección","subtext":"Total entrevistas: 3.395 · AM vs PM por día"}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[],"magicType":{"type":["bar","line"]}}},"animation":true,"animationDuration":900,"animationEasing":"cubicOut"},"dispose":true},"evals":[],"jsHooks":[]}</script>
```

:::
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-e1d81dc4b463269198af" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-e1d81dc4b463269198af">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"yAxis":[{"data":["lunes","martes","miércoles","jueves","viernes"],"name":"Día de la semana"}],"xAxis":[{"data":["08","09","10","11","12","13","14","15","16","17","18"],"type":"category","name":"Hora del día","nameLocation":"middle","nameGap":30}],"series":[{"data":[{"value":["08","lunes"," 19"]},{"value":["09","lunes","107"]},{"value":["10","lunes","162"]},{"value":["11","lunes","153"]},{"value":["12","lunes"," 54"]},{"value":["13","lunes"," 26"]},{"value":["14","lunes","162"]},{"value":["15","lunes"," 96"]},{"value":["16","lunes","105"]},{"value":["17","lunes","  0"]},{"value":["18","lunes","  0"]},{"value":["08","martes"," 36"]},{"value":["09","martes"," 40"]},{"value":["10","martes"," 42"]},{"value":["11","martes"," 36"]},{"value":["12","martes","  5"]},{"value":["13","martes","  0"]},{"value":["14","martes"," 15"]},{"value":["15","martes"," 17"]},{"value":["16","martes"," 15"]},{"value":["17","martes"," 12"]},{"value":["18","martes","  0"]},{"value":["08","miércoles","  0"]},{"value":["09","miércoles","  7"]},{"value":["10","miércoles"," 20"]},{"value":["11","miércoles"," 53"]},{"value":["12","miércoles"," 13"]},{"value":["13","miércoles","  7"]},{"value":["14","miércoles"," 99"]},{"value":["15","miércoles","108"]},{"value":["16","miércoles"," 61"]},{"value":["17","miércoles"," 17"]},{"value":["18","miércoles","  0"]},{"value":["08","jueves"," 21"]},{"value":["09","jueves","127"]},{"value":["10","jueves","180"]},{"value":["11","jueves","199"]},{"value":["12","jueves","116"]},{"value":["13","jueves"," 25"]},{"value":["14","jueves","146"]},{"value":["15","jueves","196"]},{"value":["16","jueves","110"]},{"value":["17","jueves","  5"]},{"value":["18","jueves","  0"]},{"value":["08","viernes"," 31"]},{"value":["09","viernes","130"]},{"value":["10","viernes","148"]},{"value":["11","viernes","165"]},{"value":["12","viernes"," 57"]},{"value":["13","viernes"," 40"]},{"value":["14","viernes"," 99"]},{"value":["15","viernes"," 68"]},{"value":["16","viernes"," 33"]},{"value":["17","viernes","  1"]},{"value":["18","viernes","  5"]}],"name":null,"type":"heatmap","coordinateSystem":"cartesian2d","label":{"show":true,"formatter":"\n          function(params){\n            return params.value[2] === 0 ? '' : params.value[2];\n          }\n        "}}],"visualMap":[{"orient":"vertical","right":10,"top":"middle","calculable":true,"type":"continuous","min":0,"max":199}],"title":[{"left":"center","text":"Distribución horaria del trabajo (08:00 a 18:59)","subtext":"ENI — Recolección"}],"tooltip":{"trigger":"item","formatter":"\n        function (params) {\n          var hora = params.value[0];\n          var dia  = params.value[1];\n          var val  = params.value[2];\n\n          if (val === 0) return '';\n\n          return (\n            '<b>' + dia + '<\/b><br/>' +\n            'Hora: ' + hora + ':00 a ' + hora + ':59<br/>' +\n            'Supervisiones: ' + val\n          );\n        }\n      "},"grid":[{"left":80,"right":80,"top":80,"bottom":40}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[]}}},"dispose":true},"evals":["opts.series.0.label.formatter","opts.tooltip.formatter"],"jsHooks":[]}</script>
```

:::
:::




## Análisis y consistencia




::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-clock"></i>
<span>Duración media</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Promedio del tiempo de respuesta calculado sobre registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:01:35</span>
</div>
</div>
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-arrow-down"></i>
<span>Duración mínima</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Menor tiempo de respuesta observado entre los registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:00:18</span>
</div>
</div>
<div class="kpi-card time neutral">
<div class="kpi-head">
<i class="bi bi-arrow-up"></i>
<span>Duración máxima</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Mayor tiempo de respuesta observado entre los registros válidos sin outliers.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">00:08:15</span>
</div>
</div>
</div>
```

:::
:::




::: columns
::: {.column width="70%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-7fd66dec2593409ae99a" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-7fd66dec2593409ae99a">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"xAxis":[{"show":true}],"yAxis":[{"data":["Registros evaluados","Registros válidos","Válidos sin outliers"],"type":"category","boundaryGap":true}],"legend":{"data":["n"],"show":false,"type":"plain"},"series":[{"data":[{"value":["1407","Registros evaluados"]},{"value":["1366","Registros válidos"]},{"value":["1274","Válidos sin outliers"]}],"name":"n","type":"bar","yAxisIndex":0,"xAxisIndex":0,"coordinateSystem":"cartesian2d","barMaxWidth":42,"itemStyle":"\n        function(params){\n          return { color: params.data.color };\n        }\n      ","label":{"show":true,"position":"insideRight","color":"#FFFFFF","fontWeight":"bold","formatter":"\n          function(params){\n            var v = params.value;\n            if (Array.isArray(v)) v = v[0];\n            if (typeof v === 'string')\n              v = Number(v.replace(/\\./g,'').replace(',','.'));\n            return v\n              .toFixed(0)\n              .replace(/\\B(?=(\\d{3})+(?!\\d))/g, '.');\n          }\n        "}}],"tooltip":{"trigger":"axis","axisPointer":{"type":"shadow"},"formatter":"\n        function(params){\n          var p = params[0];\n          var v = p.value;\n          if (Array.isArray(v)) v = v[0];\n          if (typeof v === 'string')\n            v = Number(v.replace(/\\./g,'').replace(',','.'));\n          return '<b>' + p.axisValue + '<\/b><br>' +\n                 v.toLocaleString('es-CL');\n        }\n      "},"title":[{"left":"center","text":"Cobertura de registros","subtext":"ENI — Consistencia"}],"grid":[{"left":40,"right":20,"top":70,"bottom":10,"containLabel":true}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[],"magicType":{"type":["bar","line"]}}},"animation":true,"animationDuration":900,"animationEasing":"cubicOut"},"dispose":true},"evals":["opts.series.0.itemStyle","opts.series.0.label.formatter","opts.tooltip.formatter"],"jsHooks":[]}</script>
```

:::
:::



:::

::: {.column width="30%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card risk warn">
<div class="kpi-head">
<i class="bi bi-calendar-x"></i>
<span>Error en registro de fecha</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros con inconsistencias temporales, definidas como fechas u horas faltantes o duraciones negativas entre inicio y término. El denominador corresponde al total de registros procesados en la etapa analizada.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">0,07%</span>
</div>
<div class="kpi-sub">1 registros</div>
</div>
<div class="kpi-card risk bad">
<div class="kpi-head">
<i class="bi bi-shield-x"></i>
<span>Regla operativa</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros cuya duración incumple los umbrales mínimos o máximos definidos por encuesta y etapa. El cálculo se realiza sobre el total de registros.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">2,84%</span>
</div>
<div class="kpi-sub">40 registros</div>
</div>
<div class="kpi-card risk bad">
<div class="kpi-head">
<i class="bi bi-exclamation-circle"></i>
<span>Outliers</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Porcentaje de registros con duraciones atípicas identificadas mediante criterios estadísticos (IQR de Tukey y Z-MAD), calculado sobre el total de registros con duración válida.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">6,54%</span>
</div>
<div class="kpi-sub">92 registros</div>
</div>
</div>
```

:::
:::



:::
:::




::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="kpi-grid">
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-clipboard-data"></i>
<span>Registros evaluados</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Total de registros procesados en la etapa considerada.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">1.407</span>
</div>
</div>
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-check-lg"></i>
<span>Registros válidos</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Número de registros cuya duración cumple las reglas operativas definidas.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">1.366</span>
</div>
</div>
<div class="kpi-card neutral neutral">
<div class="kpi-head">
<i class="bi bi-check-circle"></i>
<span>Válidos sin outliers</span>
<details class="kpi-help">
<summary title="Ver definición metodológica">
<i class="bi bi-info-circle"></i>
</summary>
<div class="kpi-help-text">Registros válidos que no presentan valores atípicos y que conforman la base final para el análisis.</div>
</details>
</div>
<div class="kpi-main">
<span class="kpi-value">1.274</span>
</div>
</div>
</div>
```

:::
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-560f9934238ae03f9ef0" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-560f9934238ae03f9ef0">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"yAxis":[{"show":true,"name":"Número de entrevistas"}],"xAxis":[{"data":["lunes","martes","miércoles","jueves","viernes"],"type":"category","boundaryGap":true}],"legend":{"data":["AM","PM"],"show":true,"type":"plain","orient":"vertical","right":10,"top":"middle"},"series":[{"data":[{"value":["lunes","171"]},{"value":["martes","178"]},{"value":["miércoles"," 74"]},{"value":["jueves"," 86"]},{"value":["viernes"," 91"]}],"yAxisIndex":0,"xAxisIndex":0,"name":"AM","type":"line","coordinateSystem":"cartesian2d","smooth":true,"symbol":"circle"},{"data":[{"value":["lunes","242"]},{"value":["martes","282"]},{"value":["miércoles"," 64"]},{"value":["jueves","125"]},{"value":["viernes"," 94"]}],"yAxisIndex":0,"xAxisIndex":0,"name":"PM","type":"line","coordinateSystem":"cartesian2d","smooth":true,"symbol":"circle"}],"tooltip":{"trigger":"axis"},"title":[{"left":"center","text":"Distribución de entrevistas — ENI — Consistencia","subtext":"Total entrevistas: 1.407 · AM vs PM por día"}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[],"magicType":{"type":["bar","line"]}}},"animation":true,"animationDuration":900,"animationEasing":"cubicOut"},"dispose":true},"evals":[],"jsHooks":[]}</script>
```

:::
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div class="echarts4r html-widget html-fill-item" id="htmlwidget-5e080de89ad5353813a1" style="width:100%;height:500px;"></div>
<script type="application/json" data-for="htmlwidget-5e080de89ad5353813a1">{"x":{"theme":"","tl":false,"draw":true,"renderer":"canvas","events":[],"buttons":[],"opts":{"yAxis":[{"data":["lunes","martes","miércoles","jueves","viernes"],"name":"Día de la semana"}],"xAxis":[{"data":["08","09","10","11","12","13","14","15","16","17","18"],"type":"category","name":"Hora del día","nameLocation":"middle","nameGap":30}],"series":[{"data":[{"value":["08","lunes","16"]},{"value":["09","lunes","37"]},{"value":["10","lunes","68"]},{"value":["11","lunes","44"]},{"value":["12","lunes","27"]},{"value":["13","lunes","15"]},{"value":["14","lunes","56"]},{"value":["15","lunes","72"]},{"value":["16","lunes","57"]},{"value":["17","lunes","13"]},{"value":["18","lunes"," 2"]},{"value":["08","martes","29"]},{"value":["09","martes","38"]},{"value":["10","martes","57"]},{"value":["11","martes","54"]},{"value":["12","martes","36"]},{"value":["13","martes"," 5"]},{"value":["14","martes","30"]},{"value":["15","martes","79"]},{"value":["16","martes","67"]},{"value":["17","martes","36"]},{"value":["18","martes","29"]},{"value":["08","miércoles"," 6"]},{"value":["09","miércoles","14"]},{"value":["10","miércoles","30"]},{"value":["11","miércoles","24"]},{"value":["12","miércoles","12"]},{"value":["13","miércoles"," 1"]},{"value":["14","miércoles","13"]},{"value":["15","miércoles","21"]},{"value":["16","miércoles","15"]},{"value":["17","miércoles"," 2"]},{"value":["18","miércoles"," 0"]},{"value":["08","jueves"," 7"]},{"value":["09","jueves","21"]},{"value":["10","jueves","27"]},{"value":["11","jueves","30"]},{"value":["12","jueves","31"]},{"value":["13","jueves"," 6"]},{"value":["14","jueves","17"]},{"value":["15","jueves","47"]},{"value":["16","jueves","24"]},{"value":["17","jueves"," 0"]},{"value":["18","jueves"," 0"]},{"value":["08","viernes"," 2"]},{"value":["09","viernes","25"]},{"value":["10","viernes","28"]},{"value":["11","viernes","36"]},{"value":["12","viernes","10"]},{"value":["13","viernes","22"]},{"value":["14","viernes","19"]},{"value":["15","viernes","39"]},{"value":["16","viernes"," 3"]},{"value":["17","viernes"," 1"]},{"value":["18","viernes"," 0"]}],"name":null,"type":"heatmap","coordinateSystem":"cartesian2d","label":{"show":true,"formatter":"\n          function(params){\n            return params.value[2] === 0 ? '' : params.value[2];\n          }\n        "}}],"visualMap":[{"orient":"vertical","right":10,"top":"middle","calculable":true,"type":"continuous","min":0,"max":79}],"title":[{"left":"center","text":"Distribución horaria del trabajo (08:00 a 18:59)","subtext":"ENI — Consistencia"}],"tooltip":{"trigger":"item","formatter":"\n        function (params) {\n          var hora = params.value[0];\n          var dia  = params.value[1];\n          var val  = params.value[2];\n\n          if (val === 0) return '';\n\n          return (\n            '<b>' + dia + '<\/b><br/>' +\n            'Hora: ' + hora + ':00 a ' + hora + ':59<br/>' +\n            'Supervisiones: ' + val\n          );\n        }\n      "},"grid":[{"left":80,"right":80,"top":80,"bottom":40}],"toolbox":{"show":true,"orient":"horizontal","right":10,"top":10,"feature":{"saveAsImage":[]}}},"dispose":true},"evals":["opts.series.0.label.formatter","opts.tooltip.formatter"],"jsHooks":[]}</script>
```

:::
:::



:::

