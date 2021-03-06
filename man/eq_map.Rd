% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eq_map.R
\name{eq_map}
\alias{eq_map}
\title{Mapping the earthquake epicenters and providing some annotations from NOAA earthquake data}
\usage{
eq_map(mapdata, annot_col = "DATE")
}
\arguments{
\item{mapdata}{A cleaned data frame with data obtained from NOAA website}

\item{annot_col}{The name of the column from the data to be use for annotation}
}
\value{
A map of the earthquakes epicenters and providing some annotations
}
\description{
Mapping the earthquake epicenters and providing some annotations from NOAA earthquake data
}
\details{
After downloading, reading and cleaning the dataset from NOAA site,
\url{https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1}.
National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database.
National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K.
The cleaning of the data frame is done with the eq_clean_data() function of this package.
The function return a map of the earthquakes epicenters (LATITUDE/LONGITUDE) and annotates each point with
in pop up window containing annotation data stored in a column of the cleaned data frame.
The user is able to choose which column is used for the annotation in the pop-up with this function
by using the argument named "annot_col". If the "annot_col" argument is not used, then the value of the "DATE" column is used.
On the map, each earthquake is shown with a circle, and the radius of the circle
is proportional to the earthquake's magnitude (EQ_PRIMARY).
}
\examples{
\dontrun{
readr::read_delim("signif.txt", delim = "\\t") \%>\%
eq_clean_data() \%>\%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) \%>\%
  eq_map(annot_col = "DATE")
}

}
