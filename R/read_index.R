#' read the required indices
#' @export
#' @inheritParams read_species
#' @param species the ID of the relevant species
#' @importFrom assertthat assert_that is.string
#' @importFrom DBI dbGetQuery
read_index <- function(connection, species){
  assert_that(inherits(connection, "DBIConnection"))
  assert_that(is.string(species))

  sql <- paste0(
    "
SELECT
  *
FROM
  CompositeIndex
WHERE
  ModelType = 'fYear' AND
  SpeciesGroup = '", species, "'
    "
  )
  index <- dbGetQuery(conn = connection, statement = sql)
  index$Period <- as.numeric(index$Period)
  return(index)
}
