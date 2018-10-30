#' Mapping the earthquake epicenters and providing some annotations from NOAA earthquake data
#'
#' @param mapdata A cleaned data frame with data obtained from NOAA website
#' @param annot_col The name of the column from the data to be use for annotation
#'
#' @return A map of the earthquakes epicenters and providing some annotations
#'
#' @details After downloading, reading and cleaning the dataset from NOAA site,
#' \url{https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1}.
#' National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database.
#' National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K.
#' The cleaning of the data frame is done with the eq_clean_data() function of this package.
#' The function return a map of the earthquakes epicenters (LATITUDE/LONGITUDE) and annotates each point with
#' in pop up window containing annotation data stored in a column of the cleaned data frame.
#' The user is able to choose which column is used for the annotation in the pop-up with this function
#' by using the argument named "annot_col". If the "annot_col" argument is not used, then the value of the "DATE" column is used.
#' On the map, each earthquake is shown with a circle, and the radius of the circle
#' is proportional to the earthquake's magnitude (EQ_PRIMARY).
#'
#' @examples
#' \dontrun{
#' readr::read_delim("signif.txt", delim = "\t") %>%
#' eq_clean_data() %>%
#'   dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'   eq_map(annot_col = "DATE")
#' }
#'
#' @importFrom dplyr %>%
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#'
#' @export

eq_map <- function(mapdata, annot_col = "DATE") {
    leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(lng = mapdata$LONGITUDE, lat = mapdata$LATITUDE,
                              radius = as.numeric(mapdata$EQ_PRIMARY), popup = mapdata[[annot_col]],
                              stroke = FALSE, fillOpacity = 0.5)
}

#' More interesting pop-ups for the interactive map used with the eq_map() function
#'
#' @param mapdata A cleaned data frame with data obtained from NOAA website
#'
#' @return An HTML label that can be used as the annotation text in the leaflet map.
#'
#' @details This function return a more interesting pop-ups for the interactive map created with the eq_map() function.
#' The function is called before the eq_map() function and used the same cleaned data.
#' The cleaning of the data frame is done with the eq_clean_data() and eq_location_clean() functions of this package.
#' For each earthquake, the pop-up will show its "Location", "Total deaths" and "Magnitude".
#'
#' @examples
#' \dontrun{
#' readr::read_delim("signif.txt", delim = "\t") %>%
#'   eq_clean_data() %>%
#'   eq_location_clean() %>%
#'   dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'   dplyr::mutate(popup_text = eq_create_label(.)) %>%
#'   eq_map(annot_col = "popup_text")
#' }
#'
#' @export

eq_create_label <- function(mapdata){
  paste(ifelse(is.na(mapdata$LOCATION_NAME),"", paste("<b>Location: </b>",mapdata$LOCATION_NAME,"<br/>")),
        ifelse(is.na(mapdata$EQ_PRIMARY),"", paste("<b>Magnitude: </b>",mapdata$EQ_PRIMARY,"<br/>")),
        ifelse(is.na(mapdata$TOTAL_DEATHS),"", paste("<b>Total deaths: </b>",mapdata$TOTAL_DEATHS,"<br/>")))
}
