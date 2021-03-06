#' @title INQStats data query
#' @field api_key a key received from INQStats.
#' @field country_code a vector of ISO 3166-1 country codes, e.g. "us,gb,se".
#' @field data a data-set, as a vector, e.g. c("population","birth_rate").
#' @field years a year range, as a vector, e.g.  1990:2002.
#' @field result a data frame.
#' @description Returns the data from INQStats.
#' Further information about  INQStats, e.g. how to get api key, what data is available, can be found on \url{http://blog.inqubu.com/inqstats-open-api-published-to-get-demographic-data}
#' @examples
#' databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = "us,lt,se", data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015)$result
#' @export databycountry
#' @export


databycountry <-  setRefClass(
    "databycountry",
    fields = list(
        # api key is provided by the INQStats, our key is "97c1f72e01dd5ba3"
        api_key = "character",
        # two letter ISO 3166-1 country code
        country_code = "vector",
        # what information is required, i.e., population, birth_rate... http://blog.inqubu.com/inqstats-open-api-published-to-get-demographic-data
        data  = "vector",
        # numeric vector of how many years info user needs
        years = "vector",
        result = "data.frame"
    ),
    methods = list(
        initialize = function(api_key, country_code, data, years) {
            # Add neccessary libraries
            
            stopifnot(is.numeric(years), is.vector(years))
            stopifnot(is.character(country_code), is.vector(country_code))
            stopifnot(is.character(data), is.vector(data))
            stopifnot(is.character(api_key), length(api_key) == 1)
            
            # Create character string without spaces of country_code
            country_ch <-
                gsub(" ", "", toString(country_code), fixed = TRUE)
            # Create character string without spaces of years
            years_ch <- gsub(" ", "", toString(years), fixed = TRUE)
            # Create character string without spaces of data
            data_ch <- gsub(" ", "", toString(data), fixed = TRUE)
            
            # Create return of fields
            api_key <<- api_key
            country_code <<- country_ch
            data <<- data_ch
            years <<- years_ch
            
            # Call API server
            url <-  "http://inqstatsapi.inqubu.com"
            raw_result <-
                GET(
                    url,
                    query = list(
                        api_key = api_key,
                        countries = country_ch,
                        data = data_ch,
                        years = years_ch
                    )
                )
            
            # Parse the response from JSON to R
            raw_content <- rawToChar(raw_result$content)
            
            # INQStats
            if (http_type(raw_result) != "application/json") {
                resp_string <- substr(raw_content, 2, nchar(raw_content) - 1)
                if (grep("error", resp_string) == 1) {
                    stop(sprintf(
                        "API did not return json.\n Response:<%s>",
                        resp_string
                    ),
                    call. = FALSE)
                    
                }
                else{
                    stop("API did not return json", call. = FALSE)
                    
                }
            }
            
            # use function from jsonlite to convert response to R data frame
            df_content <- fromJSON(raw_content)
            
            if (df_content[[1]] == "error" ||
                http_error(raw_result)) {
                stop(
                    sprintf(
                        "INQStats API request failed.\nstatus_code:[%s]\nmsg:<%s>",
                        status_code(raw_result),
                        df_content$msg
                    ),
                    call. = FALSE
                )
            }
            
            
            
            df_output <- data.frame(
                country = character(),
                dataset = character(),
                years = numeric(),
                values = numeric()
            )
            
            for (i in 1:length(df_content[[1]])) {
                country_name <- df_content$countryName[i]
                
                # loop through all datasets (exclude countryCode and countryName)
                for (j in 3:length(df_content)) {
                    # Skip this iterration if this dataset is empty (no values received from API)
                    if (length(df_content[[j]][[i]]) == 0) {
                        next
                    }
                    # take years of the jth dataset for the ith country
                    years_j <- df_content[[j]][[i]][[1]]
                    # take value of the jth dataset for the ith country
                    value_j <- df_content[[j]][[i]][[2]]
                    # create vestor of countryNames
                    country_j <-
                        rep.int(country_name, length(value_j))
                    # Create vector of dataset name
                    dataset_j <-
                        rep.int(names(df_content)[j], length(value_j))
                    # create temp dataframe
                    output_temp <- data.frame(
                        country = country_j,
                        dataset = dataset_j,
                        years = years_j,
                        values = value_j
                    )
                    
                    # merge the rows to df_output
                    df_output <- rbind(df_output, output_temp)
                }
                
                
            }
            result <<- df_output
        },
        get_country = function() {
            return(as.vector(unique(result[["country"]])))
        },
        get_dataset = function() {
            return(as.vector(unique(result[["dataset"]])))
        }
    )
)

