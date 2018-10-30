# EQVT R package

EQVT is a Data Analysis and Visualization R package developped in the 5th course of the
["Mastering Software Development in R Specialization"](https://www.coursera.org/specializations/r) by Johns Hopkins University on Coursera: ["Mastering Software Development in R Capstone"](https://www.coursera.org/learn/r-capstone).


The overall goal of the capstone project is to integrate the skills we have developed over the courses in this Specialization and to build a software package that can be used to work with the ["NOAA Significant Earthquake Database"](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1).

National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database. National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K.

More specificaly, this package contains:
  
* Two functions that takes raw NOAA data frame and returns a clean data frame: `eq_clean_data` and `eq_location_clean`
* Two geoms that can be used in conjunction with the `ggplot2` package to visualize some of the information in the NOAA earthquakes dataset: 
  *`geom_timeline` to visualize the times, the magnitudes and the number of deaths associated to earthquakes within certain countries.
  *`geom_timelinelabel` for adding annotations to the earthquake data and an option to subset the n_max largest earthquakes by magnitude.
* A function that interactively maps (`leaflet`) the earthquakes epicenters (LATITUDE/LONGITUDE) with the desired annotation (eg Date): `eq_map`
* A function that creates an HTML label that can be used as the annotation text ("Location", "Total deaths", and "Magnitude") in the leaflet map: `eq_create_label`

## Installation

You can install this package from github using the following command:

```{r, eval=FALSE}
devtools::install_github('llangevin/EQVT', build_vignettes = TRUE)
library(EQVT)
```

## Example

A detailed documentation can be found in the package vignette. The following command can be used to launch the vignette:

```{r, eval=FALSE}
vignette('EQVT_vignettes', package = 'EQVT')
```
