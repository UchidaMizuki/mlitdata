mlitdata_setup <- function(path,
                           url = "https://www.mlit-data.jp/",
                           content_type = "application/json", ...) {
  rlang::dots_list(path = path,
                   url = url,
                   content_type = content_type, ...,
                   .named = TRUE)
}

mlitdata_get <- function(query, setup) {
  apikey <- Sys.getenv("MLITDATA_API_KEY")
  if (apikey == "") {
    rlang::abort("`MLITDATA_API_KEY` does not exist. Please set the key with `Sys.setenv(MLITDATA_API_KEY = )`.")
  }

  httr2::request(setup$url) |>
    httr2::req_url_path_append(setup$path) |>
    httr2::req_headers(`Content-type` = setup$content_type,
                       apikey = apikey) |>
    httr2::req_url_query(query = as.character(query)) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
