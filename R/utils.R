unnest_wider_prefix_fields <- function(data, col, ..., prefix, fields,
                                       sep = "_") {
  if (is.list(fields)) {
    fields <- rlang::names2(fields)
  }
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
