
# Packages ----------------------------------------------------------------

library(httr)
library(jsonlite)
library(ggplot2)
library(tidyverse)
library(lubridate)

# API parameters ----------------------------------------------------------

api_key <- "301d155c0a3366e8"
data <- "population"
countries <- "se,us"
start_year <- "2014"
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

output <- data.frame(country = character(), 
                     year = numeric(), 
                     value = numeric(), 
                     stringsAsFactors = FALSE)
for(i in 1:length(results)){
    for (j in 1:length(results[[i]][[data]])){
        tmp <- data.frame(country = results[[i]]$countryName, 
                          year = results[[i]][[data]][[j]]$year, 
                          value = results[[i]][[data]][[j]]$data, 
                          stringsAsFactors = FALSE)
        
        output <- rbind(output, tmp, stringsAsFactors = FALSE)
        rm(tmp)
    }
}

output$value <- as.numeric(output$value)
output <<- output
# plot --------------------------------------------------------------------
# 
# ggplot(data = output, aes(x = year, y = value, colour = country, group = country)) +
#     geom_path() +
#     geom_point()
}


# Function call -----------------------------------------------------------

countries <- "se,us,gb,de,tr,dk,br,ru,jp,ar"

api("happiness_index", countries, 2000, 2016)
api("corruption_index", countries, 1995, 2016)
api("life_expectancy", countries, 1995, 1999)
api("internetusers_percent", countries, 1998, 2017)
api("olympicsummergames_goldmedals", countries, 1970, 2017)
api("fifa", countries, 2007, 2017)
api("inflation", countries,2001, 2017)
api("gdp_capita", countries, 2000, 2005)
api("population", countries, 2005, 2017)

output$dataset <- "population"
output$dataset <- "gdp_capita"

resp <- rbind(resp,output)
