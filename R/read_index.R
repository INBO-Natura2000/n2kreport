#' read the required indices
#' @export
#' @inheritParams read_species
#' @param species the ID of the relevant species
#' @param frequency Return the yearly indices or per cycle
#' @importFrom assertthat assert_that is.string
#' @importFrom DBI dbGetQuery
read_index <- function(connection, table, variable, species, frequency){
  assert_that(inherits(connection, "DBIConnection"))
  assert_that(is.string(table))
  assert_that(is.string(variable))
  assert_that(dbExistsTable(connection, table))
  assert_that(variable %in% dbListFields(connection, table))
  assert_that(is.string(species))
  assert_that(is.string(frequency))

  sql <- sprintf(
    "SELECT\n  *\nFROM\n  %s\nWHERE\n  ModelType = '%s' AND\n  %s = '%s'",
    table,
    frequency,
    variable,
    species
  )
  dbGetQuery(conn = connection, statement = sql)
}
