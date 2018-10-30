#' Visualize the times at which earthquakes occur within certain countries
#'
#' This geom adds a vertical line to each data point with a text annotation (e.g. the location of the earthquake) attached to each line.
#' There is also an option to subset to n_max number of earthquakes, where we take the n_max largest (by magnitude) earthquakes.
#'
#' @return The geom \code{geom_timeline_label} used with the \code{ggplot} function and the \code{geom_timeline} geom,
#' add annotations to the n_max largest (by magnitude) earthquakes.
#'
#' @details The data to be used with this geom must be downloaded and readed from NOAA site,
#' \url{https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1}.
#'
#' @inheritParams ggplot2::layer
#' @param mapping Set of aesthetic mappings created.
#' @param data  The data to be displayed in this layer.
#' @param stat  The statistical transformation to use on the data for this layer, as a string.
#' @param position Position adjustment, either as a string, or the result of a call to a position adjustment function.
#' @param show.legend logical. Should this layer be included in the legends?
#' @param inherit.aes If FALSE, overrides the default aesthetics, rather than combining with them.
#'
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'   a warning. If `TRUE`, missing values are silently removed.
#' @param ... Other arguments passed on to [layer()]. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   `colour = "red"` or `size = 3`. They may also be parameters
#'   to the paired geom/stat.
#'
#'#' @section Aesthetics:
#' \code{geom_timeline_label} understands the following aesthetics (properties of the plot that can show certain elements of the data)
#'  (required aesthetics are in bold):
#' \itemize{
#'   \item \strong{\code{x}}     #Time variable
#'   \item \strong{\code{label}} #Factor for adding annotations to the earthquake data
#'   \item \code{y}              #Factor indicating some stratification
#'   \item \code{n_max}          #number of earthquakes to subset according to their magnitude (EQ_PRIMARY)
#'   \item \code{y_length}       #vertical line length to each data point
#' }
#'
#' @importFrom ggplot2 layer
#'
#' @export
#'
#' @examples
#' # The data must be cleaned using the function \code{eq_clean_data}, included in the package.
#' # The LOCATION_NAME colomn of the data must be cleaned using the function \code{eq_location_clean},
#' # included in the package.
#' # Aesthetics can be specified in the \code{ggplot} function or in \code{geom_timeline} geom function
#' \dontrun{
#' data <- readr::read_delim("signif.txt", delim = "\t")
#' data <- eq_clean_data(data)
#' data <- eq_location_clean(data)
#' data %>%
#' dplyr::filter(COUNTRY == c("MEXICO","USA") & lubridate::year(DATE) >= 2010) %>%
#' ggplot(aes(x=DATE,y=COUNTRY,color=TOTAL_DEATHS,size=EQ_PRIMARY)) +
#' geom_timeline(alpha=.5) +
#' geom_timelinelabel(aes(label=LOCATION_NAME),n_max=3) +
#' theme(legend.position="bottom", legend.box="horizontal", plot.title=element_text(hjust=0.5)) +
#' ggtitle("Earthquakes Visualization Tool") +
#' labs(size = "Richter scale value", color = "# deaths")
#' }
geom_timelinelabel <- function(mapping = NULL, data = NULL, stat = "identity",
                               position = "identity", na.rm = FALSE, show.legend = NA,
                               inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomTimelinelabel, mapping = mapping,  data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' GeomTimelinelabel
#'
#' GeomTimelinelabel Geom coding
#'
#' @importFrom ggplot2 ggproto Geom aes draw_key_point
#' @importFrom grid segmentsGrob gpar textGrob gList
#' @importFrom dplyr slice arrange_ group_by_ %>%
#'
#' @export
GeomTimelinelabel <- ggplot2::ggproto("GeomTimelinelabel", ggplot2::Geom,
                             required_aes = c("x","label"),
                             default_aes = ggplot2::aes(y=0, n_max=0, y_length=1),
                             draw_key = ggplot2::draw_key_point,
                             draw_panel = function(data, panel_params, coord) {

                               if (data$n_max[1]>0){
                                 if (data$y[1]==0){
                                   data<- data %>%
                                     dplyr::arrange_(~ desc(size)) %>%
                                     dplyr::slice(1:data$n_max[1])
                                 }
                                 else {
                                   data<- data %>%
                                     dplyr::arrange_(~ desc(size)) %>%
                                     dplyr::group_by_(~ y) %>%
                                     dplyr::slice(1:data$n_max[1])
                                 }
                               }
                               if (!data$y[1]==0){
                                 data$y_length<-dim(table(data$y))
                               }

                               coords <- coord$transform(data, panel_params)
                               grid::gList(
                                 grid::segmentsGrob(
                                   x0 = coords$x, y0 = coords$y, x1 = coords$x, y1 = (.2/coords$y_length)+coords$y,
                                   gp = grid::gpar(col = "black", lwd = .5)
                                 ),
                                 grid::textGrob(
                                   label = coords$label,
                                   x = coords$x, y = (.2/coords$y_length)+coords$y , just = "left", rot = 45
                                 )
                               )
                             }
)
