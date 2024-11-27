#' Location filter
#'
#' @param bbox A `bbox` object from sf package.
#' @param point A `point` object from sf package.
#' @param distance A numeric value.
#'
#' @return An `mlitdata_query_args` object.
#'
#' @export
mlitdata_location_filter <- function(bbox = NULL,
                                     point = NULL,
                                     distance = NULL) {
  list(rectangle = mlitdata_location_filter_rectangle(bbox = bbox),
       geoDistance = mlitdata_location_filter_geodistance(point = point,
                                                          distance = distance)) |>
    new_mlitdata_query_args()
}

#' @name mlitdata_location_filter
mlitdata_location_filter_rectangle <- function(bbox = NULL) {
  if (is.null(bbox)) {
    return(NULL)
  }

  bbox <- sf::st_bbox(bbox)

  top_left <- sf::st_point(c(bbox["xmin"], bbox["ymax"]))
  bottom_right <- sf::st_point(c(bbox["xmax"], bbox["ymin"]))

  list(topLeft = mlitdata_location_filter_lat_lon_point(top_left),
       bottomRight = mlitdata_location_filter_lat_lon_point(bottom_right)) |>
    new_mlitdata_query_args()
}

#' @name mlitdata_location_filter
mlitdata_location_filter_lat_lon_point <- function(point = NULL) {
  if (is.null(point)) {
    return(NULL)
  }

  list(lat = point[[2]],
       lon = point[[1]]) |>
    new_mlitdata_query_args()
}

#' @name mlitdata_location_filter
mlitdata_location_filter_geodistance <- function(point = NULL,
                                                 distance = NULL) {
  if (is.null(point) || is.null(distance)) {
    return(NULL)
  }

  list(lat = point[[2]],
       lon = point[[1]],
       distance = distance) |>
    new_mlitdata_query_args()
}
