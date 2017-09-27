
# Packages ----------------------------------------------------------------

library(httr)
library(jsonlite)
library(ggplot2)
library(tidyverse)

# API parameters ----------------------------------------------------------

api_key <- "301d155c0a3366e8"
data <- "fifa"
countries <- "se,us,gb,de,tr,dk,br,cn,ru,jp,ar"
# start_year <- ""
# end_year <- ""




# Function ----------------------------------------------------------------

api <- function(data, countries){
# API call ----------------------------------------------------------------
# API info 
# http://blog.inqubu.com/inqstats-open-api-published-to-get-demographic-data

# Example query
# GET http://inqstatsapi.inqubu.com?api_key=ADDYOURKEYHERE&data=population&countries=us,gb
url <- paste("http://inqstatsapi.inqubu.com?api_key=", api_key, "&data=", data, "&countries=", countries, sep = "")
    
r <- GET(url = url)

results <- content(r)


# Create df ---------------------------------------------------------------

output <- data.frame(country = character(), year = numeric(), value = numeric(), stringsAsFactors = FALSE)
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
# plot --------------------------------------------------------------------

return(ggplot(data = output, aes(x = year, y = value, colour = country, group = country)) +
    geom_path() +
    geom_point())
}


# Function call -----------------------------------------------------------
api("happiness_index", countries)
api("corruption_index", countries)
api("life_expectancy", countries)
api("internetusers_percent", countries)
api("olympicsummergames_goldmedals", countries)
api("fifa", countries)
api("inflation", countries)
