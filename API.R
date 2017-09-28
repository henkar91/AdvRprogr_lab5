
# Packages ----------------------------------------------------------------

library(httr)
library(jsonlite)
library(ggplot2)
library(tidyverse)
library(lubridate)

# API parameters ----------------------------------------------------------

api_key <- "301d155c0a3366e8"
data <- "population,bigmac_index"
countries <- "se,no"
start_year <- "2015"
end_year <- "2016"

# Function ----------------------------------------------------------------

api <- function(data, countries, start_year, end_year){
# API call ----------------------------------------------------------------
# API info 
# http://blog.inqubu.com/inqstats-open-api-published-to-get-demographic-data

# Example query
# GET http://inqstatsapi.inqubu.com?api_key=ADDYOURKEYHERE&data=population&countries=us,gb
url <- paste("http://inqstatsapi.inqubu.com?api_key=", api_key, 
             "&data=", data, "&countries=", countries, 
             "&years=", start_year, ":", end_year, sep = "")
           
    
r <- GET(url = url)

results <- content(r)


# Create df ---------------------------------------------------------------

resp <- data.frame(country = character(), 
                     year = numeric(), 
                     value = numeric(), 
                     stringsAsFactors = FALSE)
for(i in 1:length(results)){
    for (j in 1:length(results[[i]][[data]])){
        tmp <- data.frame(country = results[[i]]$countryName, 
                          year = results[[i]][[data]][[j]]$year, 
                          value = results[[i]][[data]][[j]]$data, 
                          stringsAsFactors = FALSE)
        
        resp <- rbind(resp, tmp, stringsAsFactors = FALSE)
        rm(tmp)
    }
}


resp$value <- as.numeric(resp$value)
resp <<- resp
}


# Function call -----------------------------------------------------------

countries <- "se,dk,no,fi,us,gb,de,tr,dk,br,ru,jp,ar"

# api("happiness_index", countries, 2000, 2016)
# api("corruption_index", countries, 1995, 2016)
# api("life_expectancy", countries, 1995, 1999)
# api("internetusers_percent", countries, 1998, 2017)
# api("olympicsummergames_goldmedals", countries, 1970, 2017)
# api("fifa", countries, 2007, 2017)
# api("inflation", countries,2001, 2017)
api("gdp_capita", countries, 1980, 2017)

gdp <- resp
gdp$dataset <- "gdp_capita"

api("population", countries, 1980, 2017)
pop <- resp
pop$dataset <- "population"

resp <- rbind(pop, gdp)
resp$year <- as.numeric(resp$year)


