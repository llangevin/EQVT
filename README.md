[![Travis-CI Build Status](https://travis-ci.org/llangevin/EQVT.svg?branch=master)](https://travis-ci.org/llangevin/EQVT)

# EQVT R package

EQVT is a Data Analysis and Visualization R package developped in the 5th course of the
["Mastering Software Development in R Specialization"](https://www.coursera.org/specializations/r) by Johns Hopkins University on Coursera: ["Mastering Software Development in R Capstone"](https://www.coursera.org/learn/r-capstone).

The overall goal of the capstone project is to integrate the skills we have developed over the courses in this Specialization and to build a software package that can be used to work with the ["NOAA Significant Earthquake Database"](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1).

National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database. National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K.

## Installation

You can install this package from github using the following command:

```{r, eval=FALSE}
library(devtools)
devtools::install_github('llangevin/EQVT', build_vignettes = TRUE)
library(EQVT)
```

## EQVT functions:
  
* Two functions that takes raw NOAA data frame and returns a clean data frame: `eq_clean_data` and `eq_location_clean`
* A function that interactively maps (`leaflet`) the earthquakes epicenters (LATITUDE/LONGITUDE) with the desired annotation (eg Date): `eq_map`
* A function that creates an HTML label that can be used as the annotation text ("Location", "Total deaths", and "Magnitude") in the leaflet map: `eq_create_label`
* Two geoms that can be used in conjunction with the `ggplot2` package to visualize some of the information in the NOAA earthquakes dataset: 
     + `geom_timeline` to visualize the times, the magnitudes and the number of deaths associated to earthquakes within certain countries.
     + `geom_timelinelabel` for adding annotations to the earthquake data and an option to subset the n_max largest earthquakes by magnitude.

## Examples

Download the data from the NOAA website, saved it to your working directory and transform it to a data frame using the `read_delim` function:
  
```{r eval = FALSE}
library(readr)
data <- readr::read_delim("signif.txt", delim = "\t")
```
Or you can use the file included in the package (September 2018):

```{r eval = FALSE}
filename <- system.file("extdata", "signif.txt", package="EQVT")
library(readr)
data <- readr::read_delim(filename, delim = "\t")
```

Before using the EQVT visualization tools, the data must be cleaned with the functions `eq_clean_data` and `eq_location_clean`.

```{r eval = FALSE}
clean_data <- eq_clean_data(data)
clean_data <- eq_location_clean(clean_data)
```

To map the earthquakes epicenters in Mexico since 2000 and providing their dates in annotation use the `eq_map` function:

```{r eval = FALSE}
clean_data %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  eq_map(annot_col = "DATE")
```

To have in annotation the Location, Total deaths, and Magnitude of the earthquakes, use the `eq_create_label` function before the `eq_map` function:

```{r eval = FALSE}
clean_data %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  dplyr::mutate(popup_text = eq_create_label(.)) %>%
  eq_map(annot_col = "popup_text")
```

To visualize the times, the magnitudes and the number of deaths associated to earthquakes within certain countries, use the `geom_timeline` geom with the `ggplot` function:

```{r eval = FALSE}
data %>%
  dplyr::filter(COUNTRY == c("MEXICO","USA") & lubridate::year(DATE) >= 2010) %>%
  ggplot(aes(x=DATE,y=COUNTRY,color=TOTAL_DEATHS,size=EQ_PRIMARY)) +
  geom_timeline(alpha=.5) +
  theme(legend.position="bottom", legend.box="horizontal", plot.title=element_text(hjust=0.5)) +
  ggtitle("Earthquakes Visualization Tool") +
  labs(size = "Richter scale value", color = "# deaths")
```

Use the `geom_timelinelabel` geom for adding annotations to the earthquake data and an option to subset the n_max largest earthquakes by magnitude:

```{r eval = FALSE}
data %>%
  dplyr::filter(COUNTRY == c("MEXICO","USA") & lubridate::year(DATE) >= 2010) %>%
  ggplot(aes(x=DATE,y=COUNTRY,color=TOTAL_DEATHS,size=EQ_PRIMARY)) +
  geom_timeline(alpha=.5) +
  geom_timelinelabel(aes(label=LOCATION_NAME),n_max=3) +
  theme(legend.position="bottom", legend.box="horizontal", plot.title=element_text(hjust=0.5)) +
  ggtitle("Earthquakes Visualization Tool") +
  labs(size = "Richter scale value", color = "# deaths")
```
