#' Attribute filter
#'
#' @param ... Attribute filter expressions.
#' @param .env Environment to evaluate expressions in.
#'
#' @return An `mlitdata_query_args` object.
#'
#' @export
mlitdata_attribute_filter <- function(...,
                                      .env = rlang::caller_env()) {
  rlang::enexprs(...) |>
    purrr::reduce(\(lhs, rhs) {
      rlang::expr((!!lhs) & (!!rhs))
    }) |>
    mlitdata_attribute_filter_impl(env = .env) |>
    new_mlitdata_query_args()
}

mlitdata_attribute_filter_impl <- function(expr, env) {
  out <- vctrs::vec_init(list())

  if (rlang::as_name(expr[[1]]) %in% c("&", "|")) {
    operator <- switch(
      rlang::as_name(expr[[1]]),
      `&` = "AND",
      `|` = "OR"
    )

    rlang::list2(!!operator := list(mlitdata_attribute_filter_impl(expr[[2]], env),
                                    mlitdata_attribute_filter_impl(expr[[3]], env)))
  } else {
    if (rlang::is_symbol(expr[[2]])) {
      attribute_name <- rlang::as_name(expr[[2]])
      attribute_value <- mlitdata_attribute_value(expr = expr[[3]],
                                                  env = env)
    } else if (rlang::is_symbol(expr[[3]])) {
      attribute_name <- rlang::as_name(expr[[3]])
      attribute_value <- mlitdata_attribute_value(expr = expr[[2]],
                                                  env = env)

      expr[[1]] <- switch(
        rlang::as_name(expr[[1]]),
        `>=` = rlang::expr(`<=`),
        `>` = rlang::expr(`<`),
        `<=` = rlang::expr(`>=`),
        `<` = rlang::expr(`>`),
        expr[[1]]
      )
    }

    operator <- switch(
      rlang::as_name(expr[[1]]),
      `==` = "is",
      `similar` = "similar",
      `>=` = "gte",
      `>` = "gt",
      `<=` = "lte",
      `<` = "lt"
    )

    rlang::list2(attributeName = attribute_name,
                 !!operator := attribute_value)
  }
}

mlitdata_attribute_value <- function(expr, env) {
  if (is.atomic(expr)) {
    expr
  } else if (rlang::is_symbol(expr)) {
    rlang::as_name(expr)
  } else if (rlang::as_name(expr[[2]]) == ".env") {
    env[[rlang::as_name(expr[[3]])]]
  }
}
