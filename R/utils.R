unnest_wider_prefix_fields <- function(data, col, ..., prefix, fields,
                                       sep = "_") {
  fields <- fields |>
    purrr::map_chr(\(field) {
      if (inherits(field, "mlitdata_query")) {
        field$name
      } else {
        field
      }
    })
  data |>
    tidyr::unnest_wider({{ col }},
                        names_repair = \(x) {
                          dplyr::if_else(x %in% fields,
                                         stringr::str_c(prefix, x,
                                                        sep = sep),
                                         x)
                        }, ...)
}

encode_string <- function(x,
                          quote = "\"", ...) {
  encodeString(x,
               quote = quote, ...)
}

st_as_sf_from_json <- function(data,
                               sf_column_name) {
  data <- data |>
    tibble::rowid_to_column(".rows")

  data_geometry <- data |>
    dplyr::select(".rows", dplyr::all_of(sf_column_name)) |>
    dplyr::mutate(!!sf_column_name := .data[[sf_column_name]] |>
                    purrr::map(\(x) {
                      if (is.null(x)) {
                        NULL
                      } else {
                        x |>
                          jsonlite::toJSON(auto_unbox = TRUE) |>
                          sf::read_sf() |>
                          sf::st_geometry()
                      }
                    })) |>
    tidyr::unnest_longer(dplyr::all_of(sf_column_name))

  data |>
    dplyr::select(!dplyr::all_of(sf_column_name)) |>
    dplyr::left_join(data_geometry,
                     by = ".rows") |>
    dplyr::select(!".rows") |>
    sf::st_as_sf(sf_column_name = sf_column_name)
}
