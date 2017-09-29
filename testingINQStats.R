api_key = "97c1f72e01dd5ba3"
api_key = "123"
country_code = "us,uk,se"
data = c("population","birth_rate")
data = c("population","birth_rate","co2_emissions","fifa","hdi")
years = 1990:2017

test3 <- databycountry$new(api_key= "a3", country_code = "us,gb,se,lt", data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015)
test2 <- databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = c("us","uk","se","lt"), data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015)
test3 <- databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = c("us","gb","se","lt"), data = c("population","birth_rate","co2_emissions","corruption_index","death_rate"),years = 1990:2015)

test3$result
test3$result$population

df_content[[3]][[1]][[1]]
df_content[[3]][[1]][[2]]
names(df_content)[3]

length(df_content[[1]])

df_content$population
df_content[["birth_rate"]][[3]][[2]]
class(df_content$population)
length(df_content)-2

n <- "lala"
n_rep <- c()
n_rep <- rep.int(n, 10)

