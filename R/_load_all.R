library(dplyr)
library(janitor)
library(htmltools)
library(tibble)

metadata_reporte <- list(
  fecha_descarga   = as.Date("2026-01-26"),
  fecha_generacion = Sys.Date()
)

fecha_ultima_actualizacion <- metadata_reporte$fecha_generacion


source("R/report.R",  encoding = "UTF-8")
source("R/target.R",  encoding = "UTF-8")
source("R/grafic.R",  encoding = "UTF-8")
