#' Prepare indices for export
#' @export
#' @inheritParams read_species
#' @importFrom assertthat assert_that
#' @importFrom DBI dbReadTable
export_index <- function(connection, table){
  assert_that(inherits(connection, "DBIConnection"))

  dbReadTable(conn = connection, table)
}
