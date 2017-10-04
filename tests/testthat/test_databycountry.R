#context(databycountry)

test_that("Error messages are returned if API returns error", {
    expect_error(databycountry$new(
        api_key = "a3",
        country_code = c("us", "gb", "se", "lt"),
        data = c("population", "birth_rate", "co2_emissions", "fifa", "hdi"),
        years = 1990:2015
    ))
    expect_error(
        databycountry$new(
            api_key = "97c1f72e01dd5ba3",
            country_code = c("us", "uk"),
            data = c("population", "birth_rate", "co2_emissions", "fifa", "hdi"),
            years = 1990:2015
        )
    )
})


test1 <- databycountry$new(
    api_key = "97c1f72e01dd5ba3",
    country_code = c("us"),
    data = c("population", "birth_rate"),
    years = 2010:2011
)

test_that("Correct object is returned", {
    expect_silent(
        test <- databycountry$new(
            api_key = "97c1f72e01dd5ba3",
            country_code = c("us"),
            data = c("population", "birth_rate"),
            years = 2010:2011
        )
    )
    expect_named(test1$result, c("country","dataset","years","values"))
})

test_that("class is correct", {
    expect_true(class(test1)[1] == "databycountry")
})

test_that("Correct output is returned 1", {
    result1 <- data.frame(
        country = rep.int("USA", 4),
        dataset = c(rep.int("population", 2), rep.int("birth_rate", 2)),
        years = c("2011", "2010", "2011", "2010"),
        values = c(311721632, 309347057, 13.83, 13.83)
    )
    
    is_equivalent_to(test1$result[4], result1[4])
    is_equivalent_to(test1$result[3], result1[3])
    is_equivalent_to(test1$result[2], result1[2])
    is_equivalent_to(test1$result[1], result1[1])
})

test_that("Field Years returns correct values", {
    expect_true(test1$years == "2010,2011")
})

test_that("Field Country_code returns correct values", {
    expect_true(test1$country_code == "us")
})

test_that("Field data returns correct values", {
    expect_true(test1$data == "population,birth_rate")
})

test_that("Field data returns correct values", {
    expect_true(test1$api_key == "97c1f72e01dd5ba3")
})


test_that("Correct output is returned 2", {
    test2 <-
        databycountry$new(
            api_key = "97c1f72e01dd5ba3",
            country_code = c("se", "lt"),
            data = c("death_rate"),
            years = c(2010, 2015)
        )
    result2 <-
        data.frame(
            country = c(rep.int("Sweden", 2), rep.int("Lithuania", 2)),
            dataset = rep.int("death_rate", 4),
            years = c("2015", "2010", "2015", "2010"),
            values = c(9.40, 9.60, 14.27, 13.60)
        )
    
    is_equivalent_to(test1$result[4], result1[4])
    is_equivalent_to(test1$result[3], result1[3])
    is_equivalent_to(test1$result[2], result1[2])
    is_equivalent_to(test1$result[1], result1[1])
})

# Test if big data is downloaded

test3 <- databycountry$new(
    api_key = "97c1f72e01dd5ba3",
    country_code = c("se", "us", "lt", "gb", "no", "ru", "dk", "fi"),
    data = c(
        "population",
        "bigmac_index",
        "death_rate",
        "debts_capita",
        "debts_percent",
        "fixed_telephone_subscriptions",
        "jobless_rate",
        "life_expectancy",
        "olympicsummergames_goldmedals",
        "gdp_capita",
        "corruption_index",
        "birth_rate",
        "electric_energy_consumption"
    ),
    years = 1990:2017
)

test_that("Check that big data is handled", {
    #no errors received and the data.frame with 4 columns is saved in $result
    expect_true(length(test3$result) == 4)
})

test_that("Check that incorrect arguments are not accepted", {
    expect_error(
        databycountry$new(
            api_key = "97c1f72e01dd5ba3",
            country_code = c(1, 2, 3, 16),
            data = c(123, 567),
            years = c(2017, 2009)
        )
    )
    expect_error(databycountry$new(
        api_key = c("asd", "123"),
        country_code = c("se", "lt"),
        data = c(123, 567),
        years = c(2017, 2009)
    ))
    expect_error(
        databycountry$new(
            api_key = "97c1f72e01dd5ba3",
            country_code = c("se", "lt"),
            data = c(123, 567),
            years = c(2017, 2009)
        )
    )
    expect_error(
        databycountry$new(
            api_key = "97c1f72e01dd5ba3",
            country_code = c("se", "lt"),
            data = c("death_rate"),
            years = c("y2018", "y2015")
        )
    )
})

test4 <- databycountry$new(
    api_key = "97c1f72e01dd5ba3",
    country_code = c("se", "us"),
    data = c("debts_capita",
             "debts_percent"),
    years = 2010:2017
)

test_that("Test method for get_country", {
    expect_true(is.vector(test3$get_country()),
                length(test3$get_country()) > 0)
    expect_equivalent(test4$get_country(), c("Sweden", "USA"))
    
})


test_that("Test method for get_dataset", {
    expect_true(is.vector(test3$get_dataset()),
                length(test3$get_dataset()) > 0)
    expect_equivalent(test4$get_dataset(), c("debts_capita", "debts_percent"))
})