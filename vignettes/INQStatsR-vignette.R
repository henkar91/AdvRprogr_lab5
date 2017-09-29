## ---- eval = FALSE-------------------------------------------------------
#  devtools::install_github("henkar91/AdvRprogr_lab5/INQStatsR")
#  library(INQStatsR)

## ---- eval = FALSE-------------------------------------------------------
#  library(httr)
#  library(jsonlite)
#  library(dplyr)
#  library(ggplot2)

## ---- api_example1, eval = FALSE-----------------------------------------
#  df <- databycountry$new(api_key = "insert_generated_api_key",
#                          country_code = c("se", "no", "dk", "fi", "us", "de"),
#                          data = c("population",
#                                   "bigmac_index",
#                                   "death_rate",
#                                   "debts_capita",
#                                   "debts_percent",
#                                   "jobless_rate",
#                                   "life_expectancy",
#                                   "olympicsummergames_goldmedals",
#                                   "gdp_capita",
#                                   "corruption_index",
#                                   "birth_rate",
#                                   "electric_energy_consumption"),
#                          years = 1998:2017)

## ---- api_example2, eval = FALSE-----------------------------------------
#  df$result

## ------------------------------------------------------------------------
sessionInfo()

