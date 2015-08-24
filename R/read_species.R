#' Get a list of the available species
#' @export
#' @param connection An open connection to the SQLite database
#' @importFrom assertthat assert_that
#' @importFrom DBI dbGetQuery
read_species <- function(connection){
  assert_that(inherits(connection, "SQLiteConnection"))

  sql <- paste0("
SELECT DISTINCT
  SpeciesGroup
FROM
  CompositeIndex
ORDER BY
  SpeciesGroup
  ")
  dbGetQuery(conn = connection, statement = sql)
}
