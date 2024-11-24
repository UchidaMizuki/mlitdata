#' Get data catalog
#'
#' @param catalog_id A character vector of catalog IDs. If NULL, all catalogs
#' are returned.
#' @param catalog_fields A character vector or a list of fields in the catalog.
#' @param dataset_fields A character vector or a list of fields in the dataset.
#' @param datatype_fields A character vector or a list of fields in the
#' datatype.
#' @param attribute_fields A character vector or a list of fields in the
#' attribute.
#' @param path A character vector of the path to the API. By default,
#' `"api/v1"`.
#' @param ... Additional arguments used internally.
#'
#' @return A tibble of data catalog.
#'
#' @examples
#' \dontrun{
#' mlitdata_catalog()
#' mlitdata_catalog(catalog_id = c("ipf", "nlni_ksj"))
#' mlitdata_catalog(catalog_id = c("ipf", "nlni_ksj"),
#'                  dataset_fields = c("id", "title"))
#' mlitdata_catalog(catalog_id = c("ipf", "nlni_ksj"),
#'                  dataset_fields = c("id", "title"),
#'                  attribute_fields = c("name", "display_name"))
#' mlitdata_catalog(dataset_fields = list("id",
#'                                        mlitdata_query("contactPoint",
#'                                                       "fullname")))
#' }
#'
#' @export
mlitdata_catalog <- function(catalog_id = NULL,
                             catalog_fields = c("id", "title"),
                             dataset_fields = NULL,
                             datatype_fields = NULL,
                             attribute_fields = NULL,
                             path = "api/v1", ...) {
  setup <- mlitdata_setup(path = path, ...)
  query <- mlitdata_catalog_query(catalog_id = catalog_id,
                                  catalog_fields = catalog_fields,
                                  dataset_fields = dataset_fields,
                                  datatype_fields = datatype_fields,
                                  attribute_fields = attribute_fields)

  # catalog
  out <- mlitdata_get(query = query,
                      setup = setup) |>
    tibble::as_tibble() |>
    tidyr::unnest_longer("data") |>
    unnest_wider_prefix_fields("data",
                               prefix = "catalog",
                               fields = catalog_fields)
  if (!"datasets" %in% names(out)) {
    return(out)
  }

  # dataset
  out <- out |>
    tidyr::unnest_longer("datasets") |>
    unnest_wider_prefix_fields("datasets",
                               prefix = "dataset",
                               fields = dataset_fields)
  if (!"datatype_desc" %in% names(out)) {
    return(out)
  }

  # datatype
  out <- out |>
    unnest_wider_prefix_fields("datatype_desc",
                               prefix = "datatype",
                               fields = datatype_fields)
  if (!"attributes" %in% names(out)) {
    return(out)
  }

  # attribute
  out |>
    tidyr::unnest_longer("attributes") |>
    unnest_wider_prefix_fields("attributes",
                               prefix = "attribute",
                               fields = attribute_fields)
}

mlitdata_catalog_query <- function(catalog_id = NULL,
                                   catalog_fields = c("id", "title"),
                                   dataset_fields = NULL,
                                   datatype_fields = NULL,
                                   attribute_fields = NULL) {
  query_attribute <- mlitdata_query("attributes",
                                    attribute_fields)
  query_datatype <- mlitdata_query("datatype_desc",
                                   datatype_fields,
                                   query_attribute)
  query_dataset <- mlitdata_query("datasets",
                                  dataset_fields,
                                  query_datatype)
  mlitdata_query("dataCatalog",
                 .args = list(IDs = as.list(catalog_id)),
                 catalog_fields,
                 query_dataset)
}
