#context(databycountry)

test_that("Error messages are returned if API returns error", {
    expect_error(databycountry$new(api_key= "a3", country_code = c("us","gb","se","lt"), data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015))
    expect_error(databycountry$new(api_key= "97c1f72e01dd5ba3", country_code = c("us","uk"), data = c("population","birth_rate","co2_emissions","fifa","hdi"),years = 1990:2015))
    })
