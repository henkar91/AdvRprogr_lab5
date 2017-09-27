library(httr)
library(jsonlite)

# Things to do:
# not sure if makes sense to have 'data' field as vector?.. It makes sense to have years as vector cause no one can be bothered to list out all years in the range (this is the format that you expect to receive)
# however, if we insist user to provide 'data' as a character string they might add some random spaces or forget commas, so maybe vector is 'safer' option...
# We need to ask Krzysztof if this way of getting result is ok  (see example at the bottom). I believe it should be fine as long as we properly document the package and provide the examples in documentation or vignette 
# Also need to think about country_code, now the code only works if we provide one country_code. If we provide two or more countries, the response from API is no longer data.frame format which means we would need to format it ourselves.. NOt sure how flexibal our function has to be.
# If we want to be bale to compare data from different countries, we need to have countru_code vector and then extend code that if length(country_code)>1 [prepare a df manually from the results]
databycountry <-  setRefClass(
    "databycountry",
    fields = list(
        # api key is provided by the INQStats, our key is "97c1f72e01dd5ba3"
        api_key = "character",
        # two letter ISO 3166-1 country code
        country_code = "character",
        # what information is required, i.e., population, birth_rate... http://blog.inqubu.com/inqstats-open-api-published-to-get-demographic-data
                data  = "vector",
        # numeric vector of how many years info user needs
        years = "vector",
        result = "data.frame"
    ),
    methods = list(
        initialize = function(api_key, country_code, data, years) {
            # Create character string without spaces of years
            years_ch <- gsub(" ", "", toString(years), fixed = TRUE)
            # Create character string without spaces of data
            data_ch <- gsub(" ", "", toString(data), fixed = TRUE)
            url <-  "http://inqstatsapi.inqubu.com"
            raw_result <-
                GET(
                    url,
                    query = list(
                        api_key = api_key,
                        countries = country_code ,
                        data = data_ch,
                        years = years_ch
                    )
                )
            raw_content <- rawToChar(raw_result$content)
            # use function from jsonlite to convert response to R data frame
            df_content <- fromJSON(raw_content)
            result <<- df_content
        }
    )
)
# to query the results of this follow the example below:
# test2 <- databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = "us", data = c("population","birth_rate"),years = 1990:2000)
# test2$result$population 
# test2$result$birth_rate
