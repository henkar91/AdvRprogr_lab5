#context(databycountry)

test_that("Error messages are returned if API returns error", {
    expect_error(databycountry$new(api_key= "a3", country_code = c("us","gb","se","lt"), data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015))
    expect_error(databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = c("us","uk"), data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015))
    })


test_that("Correct output is returned", {
#     expect_that(test1$result[4],equals(values = c(318857056,0,316497531,314112078,311721632,309347057,13.42,13.66,13.68,13.83,13.83)))
# })
    test1 <- databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = c("us"), data = c("population","birth_rate"),years = 2010:2011)
    result1 <- data.frame(Country=rep.int("USA",4),
                          dataset=c(rep.int("population",2),rep.int("birth_rate",2)),
                          years = c("2011","2010","2011","2010"),
                          values = c(311721632,309347057,13.83,13.83))
    
    is_equivalent_to(test1$result[4], result1[4])    
})
