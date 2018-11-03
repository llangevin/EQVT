filename <- system.file("extdata", "signif.txt", package="EQVT")
data <- readr::read_delim(filename, delim = '\t')
clean_data <- eq_clean_data(data)

#' Testting eq_clean_data function
testthat::expect_that(clean_data$DATE, testthat::is_a('Date'))
testthat::expect_that(clean_data$LATITUDE, testthat::is_a('numeric'))
testthat::expect_that(clean_data$LONGITUDE, testthat::is_a('numeric'))
testthat::expect_that(clean_data$EQ_PRIMARY, testthat::is_a('numeric'))
testthat::expect_that(clean_data$TOTAL_DEATHS, testthat::is_a('numeric'))

#' Testing eq_location_clean function
clean_data <- eq_location_clean(clean_data)
testthat::expect_that(clean_data,testthat::is_a('data.frame'))
testthat::expect_that('LOCATION_NAME' %in% (colnames(clean_data)), testthat::is_true())

#' Testing eq_map function
testthat::expect_that(clean_data %>%
                        dplyr::filter(COUNTRY == 'MEXICO' & lubridate::year(DATE) >= 2000) %>%
                        eq_map(annot_col = 'DATE'), testthat::is_a('leaflet'))

#' Testing eq_create_label function
testthat::expect_that(eq_create_label(clean_data), testthat::is_a('character'))

testthat::expect_that(clean_data %>%
                        dplyr::filter(COUNTRY == 'MEXICO' & lubridate::year(DATE) >= 2000) %>%
                        dplyr::mutate(popup_text = eq_create_label(.)) %>%
                        eq_map(annot_col = 'popup_text'), testthat::is_a('leaflet'))
