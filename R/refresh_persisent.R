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

  # nocov start
  composite.index <- read_composite_index(channel = remote.db)
  composite.index$ModelType <- gsub(
    "composite index: ",
    "",
    composite.index$ModelType
  )
  dbWriteTable(
    conn = local.db,
    name = "CompositeIndex",
    value = composite.index,
    overwrite = TRUE
  )
  # nocov end
}
