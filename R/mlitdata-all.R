mlitdata_all_impl <- function(next_data_request_token = NULL,
                              size = NULL,
                              term = NULL,
                              phrase_match = NULL,
                              location_filter = NULL,
                              attribute_filter = NULL,
                              data_fields = c("id", "title", "shape"),
                              data_shape_as_sf = TRUE,
                              file_fields = NULL,
                              path = "api/v1", ...) {
  setup <- mlitdata_setup(path = path, ...)
  query <- mlitdata_all_query(next_data_request_token = next_data_request_token,
                              size = size,
                              term = term,
                              phrase_match = phrase_match,
                              location_filter = location_filter,
                              attribute_filter = attribute_filter,
                              data_fields = data_fields,
                              file_fields = file_fields)
  mlitdata_all_get(query = query,
                   setup = setup,
                   data_fields = data_fields,
                   data_shape_as_sf = data_shape_as_sf,
                   file_fields = file_fields)
}

mlitdata_all_query <- function(next_data_request_token = NULL,
                               size = NULL,
                               term = NULL,
                               phrase_match = NULL,
                               location_filter = NULL,
                               attribute_filter = NULL,
                               data_fields = c("id", "title"),
                               file_fields = NULL) {
  query_file <- mlitdata_query("files",
                               file_fields)
  query_data <- mlitdata_query("data",
                               data_fields,
                               query_file)
  mlitdata_query("getAllData",
                 .args = list(nextDataRequestToken = next_data_request_token,
                              size = size,
                              term = term,
                              phraseMatch = phrase_match,
                              locationFilter = location_filter,
                              attributeFilter = attribute_filter),
                 "nextDataRequestToken",
                 query_data)
}

mlitdata_all_get <- function(query,
                             setup,
                             data_fields,
                             data_shape_as_sf,
                             file_fields) {
  data <- mlitdata_get(query = query,
                       setup = setup) |>
    purrr::chuck("data", "getAllData")

  next_data_request_token <- data$nextDataRequestToken

  data <- data |>
    purrr::keep_at("data") |>
    tibble::as_tibble() |>
    unnest_wider_prefix_fields("data",
                               prefix = "data",
                               fields = data_fields)
  if ("data_shape" %in% names(data) && data_shape_as_sf) {
    data <- data |>
      st_as_sf_from_json(sf_column_name = "data_shape")
  }

  if (!"files" %in% names(data)) {
    return(list(next_data_request_token = next_data_request_token,
                data = data))
  }

  data <- data |>
    tidyr::unnest_longer("files") |>
    unnest_wider_prefix_fields("files",
                               prefix = "file",
                               fields = file_fields)
  if ("data_shape" %in% names(data) && data_shape_as_sf) {
    data <- data |>
      sf::st_as_sf(sf_column_name = "data_shape")
  }
  list(next_data_request_token = next_data_request_token,
       data = data)
}
