new_mlitdata_query <- function(name,
                               args = NULL,
                               fields = NULL) {
  structure(list(name = name,
                 args = new_mlitdata_query_args(args),
                 fields = new_mlitdata_query_fields(fields)),
            class = "mlitdata_query")
}

new_mlitdata_query_args <- function(args) {
  args <- args |>
    purrr::discard(is.null)

  if (rlang::is_empty(args)) {
    NULL
  } else {
    structure(args,
              class = "mlitdata_query_args")
  }
}

new_mlitdata_query_fields <- function(fields) {
  if (rlang::is_empty(fields)) {
    NULL
  } else {
    structure(fields,
              class = "mlitdata_query_fields")
  }
}

#' Build a query object
#'
#' @param .name The name of the query.
#' @param ... The fields of the query.
#' @param .args The arguments of the query.
#'
#' @return An `mlitdata_query` object.
#'
#' @export
mlitdata_query <- function(.name, ...,
                           .args = NULL) {
  fields <- rlang::list2(...) |>
    purrr::map(\(value) {
      if (inherits(value, "mlitdata_query")) {
        list(value)
      } else {
        as.list(value)
      }
    }) |>
    vctrs::list_unchop() |>
    purrr::map(\(value) {
      if (inherits(value, "mlitdata_query")) {
        value
      } else {
        new_mlitdata_query(name = value)
      }
    })

    if (rlang::is_empty(fields)) {
      NULL
    } else {
      new_mlitdata_query(name = .name,
                         args = .args,
                         fields = fields)
    }
}

#' @export
as.character.mlitdata_query <- function(x, ...) {
  format(x, ...) |>
    stringr::str_c(collapse = "\n")
}

#' @export
print.mlitdata_query <- function(x, ...) {
  print_mlitdata_query(x, ...)
}

#' @export
print.mlitdata_query_args <- function(x, ...) {
  print_mlitdata_query(x, ...)
}

#' @export
print.mlitdata_query_fields <- function(x, ...) {
  print_mlitdata_query(x, ...)
}

print_mlitdata_query <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}

#' @export
format.mlitdata_query <- function(x, ...) {
  c("{",
    stringr::str_c("  ", format_mlitdata_query(x)),
    "}")
}

#' @export
format.mlitdata_query_args <- function(x, ...) {
  format_mlitdata_query_args(x)
}

#' @export
format.mlitdata_query_fields <- function(x, ...) {
  format_mlitdata_query_fields(x)
}

format_mlitdata_query <- function(x) {
  if (rlang::is_empty(x)) {
    ""
  } else {
    name <- x$name

    if (is.null(x$args) && is.null(x$fields)) {
      name
    } else {
      fields <- format_mlitdata_query_fields(x$fields)

      if (is.null(x$args)) {
        c(stringr::str_c(name, " {"),
          stringr::str_c("  ", fields),
          "}")
      } else {
        args <- format_mlitdata_query_args(x$args)

        c(stringr::str_c(name, "("),
          stringr::str_c("  ", args),
          ") {",
          stringr::str_c("  ", fields),
          "}")
      }
    }
  }
}

format_mlitdata_query_args <- function(args) {
  if (rlang::is_empty(args)) {
    "null"
  } else if (rlang::is_scalar_logical(args)) {
    stringr::str_to_lower(as.character(args))
  } else if (rlang::is_scalar_integer(args) || rlang::is_scalar_double(args)) {
    as.character(args)
  } else if (rlang::is_scalar_character(args)) {
    encode_string(args)
  } else if (rlang::is_named2(args)) {
    args |>
      purrr::imap(\(value, name) {
        if (rlang::is_empty(value) || is.atomic(value)) {
          if (rlang::is_empty(value) || rlang::is_scalar_atomic(value)) {
            value <- format_mlitdata_query_args(value)
            stringr::str_c(name, ": ", value)
          } else {
            rlang::list2(!!name := vctrs::vec_chop(value)) |>
              format_mlitdata_query_args()
          }
        } else if (is.list(value)) {
          is_named <- rlang::is_named2(value)
          value <- format_mlitdata_query_args(value)

          if (is_named) {
            c(stringr::str_c(name, ": {"),
              stringr::str_c("  ", value),
              "}")
          } else {
            c(stringr::str_c(name, ": ["),
              stringr::str_c("  ", value),
              "]")
          }
        }
      }) |>
      unname() |>
      vctrs::list_unchop()
  } else {
    size <- vctrs::vec_size(args)

    args |>
      purrr::imap(\(value, index) {
        is_named <- rlang::is_named2(value)
        value <- format_mlitdata_query_args(value)

        if (is_named) {
          if (index == size) {
            c("{",
              stringr::str_c("  ", value),
              "}")
          } else {
            c("{",
              stringr::str_c("  ", value),
              "},")
          }
        } else {
          if (index == size) {
            stringr::str_c("  ", value)
          } else {
            stringr::str_c("  ", value, ",")
          }
        }
      }) |>
      vctrs::list_unchop()
  }
}

format_mlitdata_query_fields <- function(fields) {
  fields |>
    purrr::map(format_mlitdata_query) |>
    vctrs::list_unchop()
}
