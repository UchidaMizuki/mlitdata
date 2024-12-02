% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mlitdata-catalog.R
\name{mlitdata_catalog}
\alias{mlitdata_catalog}
\title{Get data catalog}
\usage{
mlitdata_catalog(
  catalog_id = NULL,
  catalog_fields = c("id", "title"),
  dataset_fields = NULL,
  datatype_fields = NULL,
  attribute_fields = NULL,
  path = "api/v1",
  ...
)
}
\arguments{
\item{catalog_id}{A character vector of catalog IDs. If NULL, all catalogs
are returned.}

\item{catalog_fields}{A character vector or a list of fields in the catalog.}

\item{dataset_fields}{A character vector or a list of fields in the dataset.}

\item{datatype_fields}{A character vector or a list of fields in the
datatype.}

\item{attribute_fields}{A character vector or a list of fields in the
attribute.}

\item{path}{A character vector of the path to the API. By default,
\code{"api/v1"}.}

\item{...}{Additional arguments used internally.}
}
\value{
A tibble of data catalog.
}
\description{
Get data catalog
}
\examples{
\dontrun{
mlitdata_catalog()
mlitdata_catalog(catalog_id = c("ipf", "nlni_ksj"))
mlitdata_catalog(catalog_id = c("ipf", "nlni_ksj"),
                 dataset_fields = c("id", "title"))
mlitdata_catalog(catalog_id = c("ipf", "nlni_ksj"),
                 dataset_fields = c("id", "title"),
                 attribute_fields = c("name", "display_name"))
mlitdata_catalog(dataset_fields = list("id",
                                       mlitdata_query("contactPoint",
                                                      "fullname")))
}

}
