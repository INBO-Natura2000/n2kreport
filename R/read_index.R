#' read the required indices
#' @export
#' @inheritParams read_species
#' @param species the ID of the relevant species
#' @importFrom assertthat assert_that is.string
#' @importFrom DBI dbGetQuery
read_index <- function(connection, species, frequency){
  assert_that(inherits(connection, "DBIConnection"))
  assert_that(is.string(species))
  assert_that(is.string(frequency))

  sql <- paste0(
    "
SELECT
  *
FROM
  CompositeIndex
WHERE
  ModelType = '", frequency, "' AND
  SpeciesGroup = '", species, "'
    "
  )
  dbGetQuery(conn = connection, statement = sql)
}
