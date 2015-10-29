#' Refresh the persisent storage
#'
#' The original data is stored in an SQL Server database. This function caches
#' the relevant data from the SQL Server localy.
#' @param remote.db an open ODBC connection to the SQL Server database
#' @param local.db a connection to a local database
#' @export
#' @importFrom assertthat assert_that
#' @importFrom DBI dbWriteTable
refresh_persisent <- function(remote.db, local.db){
  assert_that(inherits(remote.db, "RODBC"))
  assert_that(inherits(local.db, "DBIConnection"))

  # nocov start
  composite.index <- import_composite_index(channel = remote.db)
  dbWriteTable(
    conn = local.db,
    name = "CompositeIndex",
    value = composite.index,
    overwrite = TRUE
  )
  index <- import_index(channel = remote.db)
  dbWriteTable(
    conn = local.db,
    name = "SpeciesIndex",
    value = index,
    overwrite = TRUE
  )
  # nocov end
}
