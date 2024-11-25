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
