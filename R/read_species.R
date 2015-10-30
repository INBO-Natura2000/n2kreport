#' Get a list of the available species
#' @export
#' @param connection An open connection to the SQLite database
#' @param table the table in which the species are stored
#' @param variable the column in which the species are stored
#' @importFrom assertthat assert_that
#' @importFrom DBI dbExistsTable dbListFields dbGetQuery
read_species <- function(connection, table, variable){
  assert_that(inherits(connection, "DBIConnection"))
  assert_that(is.string(table))
  assert_that(is.string(variable))
  assert_that(dbExistsTable(connection, table))
  assert_that(variable %in% dbListFields(connection, table))

  sql <- sprintf(
    "SELECT DISTINCT\n  %s\nFROM\n  %s\nORDER BY\n  %s",
    variable,
    table,
    variable
  )
  dbGetQuery(conn = connection, statement = sql)
}
