###############################################################################
if(getRversion() >= '2.15.1')
utils::globalVariables(c("LOCATION_NAME","I_D","YEAR","MONTH","DAY","LATITUDE","LONGITUDE",
                         "EQ_PRIMARY","COUNTRY","STATE","TOTAL_DEATHS","DATE","YEAR4"))
#' Cleaning NOAA earthquake data and geolocalisation values
#'
#' @param datatoclean A data frame with raw data obtained from NOAA website
#'
#' @return A data frame with cleaned date, latitude and longitude numerical columns
#'
#' @details After downloading and reading in the dataset from NOAA site,
#' \url{https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1}.
#' National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database.
#' National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K
#' The function returns a date column created by uniting the year, month, day and
#' converting it to the Date class and also converts LATITUDE and LONGITUDE columns
#' to numeric class.
#'
#' @examples
#' \dontrun{
#' data <- readr::read_delim("signif.txt", delim = "\t")
#' data <- eq_clean_data(data)
#' }
#'
#' @importFrom dplyr %>% mutate select if_else
#' @importFrom tidyr unite
#' @importFrom lubridate year ymd
#'
#' @export

eq_clean_data <- function(datatoclean) {
  clean_data <- datatoclean %>%
    dplyr::select(I_D, YEAR, MONTH, DAY, LATITUDE, LONGITUDE, LOCATION_NAME, EQ_PRIMARY, COUNTRY, STATE, TOTAL_DEATHS) %>%
    dplyr::mutate(YEAR4=sprintf("%04d",as.numeric(gsub('-','',YEAR)))) %>%
    dplyr::mutate(MONTH=dplyr::if_else(is.na(MONTH),'01',sprintf("%02d", MONTH))) %>%
    dplyr::mutate(DAY=dplyr::if_else(is.na(DAY),'01',sprintf("%02d", DAY))) %>%
    tidyr::unite(DATE,YEAR4,MONTH,DAY,sep='-',remove = FALSE) %>%
    dplyr::mutate(DATE = lubridate::ymd(DATE)) %>%
    dplyr::select(-YEAR4)

  lubridate::year(clean_data$DATE) <- clean_data$YEAR

  clean_data <- clean_data %>%
    dplyr::mutate(LATITUDE = as.numeric(LATITUDE),LONGITUDE = as.numeric(LONGITUDE),
                  EQ_PRIMARY = as.numeric(EQ_PRIMARY), TOTAL_DEATHS = as.numeric(TOTAL_DEATHS))
  clean_data
}

#' Cleaning NOAA earthquake data location values
#'
#' @param locationtoclean A data frame with raw data obtained from NOAA website
#'
#' @return A data frame with cleaned LOCATION_NAME column
#'
#' @details After downloading and reading in the dataset from NOAA site,
#' \url{https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1}.
#' National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database.
#' National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K
#' The function cleans the LOCATION_NAME column by stripping out the country name (including the colon)
#' and converts names to title case (as opposed to all caps).
#'
#' @examples
#' \dontrun{
#' library(readr)
#' data <- readr::read_delim("signif.txt", delim = "\t")
#' data <- eq_location_clean(data)
#' }
#'
#' @importFrom dplyr %>% mutate
#'
#' @export

eq_location_clean <- function(locationtoclean) {
  location_clean <- locationtoclean %>%
    dplyr::mutate(LOCATION_NAME=gsub("^.*:"," ",LOCATION_NAME)) %>%
    dplyr::mutate(LOCATION_NAME=gsub("\\b([[:alpha:]])([[:alpha:]]+)", "\\U\\1\\L\\2" ,LOCATION_NAME, perl=TRUE))
  location_clean
}
