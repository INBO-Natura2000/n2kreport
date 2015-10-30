#' Create a dummy database
#'
#' This database is used to test several functions. It allows to get the Shiny
#' app running without connection to the original database. It will not
#' overwrite existing data
#' @export
#' @param connection A DBI connection to the dummy database. Defaults to an in
#'   memory SQLite database
#' @importFrom assertthat assert_that
#' @importFrom dplyr %>% mutate_ n rowwise
#' @importFrom DBI dbWriteTable
create_dummy_db <- function(connection){
  assert_that(inherits(connection, "DBIConnection"))

  expand.grid(
    Scheme = "abc",
    ModelType = c("fYear", "fCycle"),
    SpeciesGroup = LETTERS[1:3],
    Period = 2010:2015
  ) %>%
    mutate_(
      Estimate = ~runif(n(), min = -0.5, max = 0.5),
      Error = ~runif(n(), min = 0.1, max = 0.2),
      LCL = ~ Estimate - Error,
      UCL = ~ Estimate + Error
    ) %>%
    rowwise() %>%
    mutate_(
      Fingerprint = ~get_sha1(c(Scheme, ModelType, SpeciesGroup))
    ) %>%
    as.data.frame() %>%
    dbWriteTable(
      conn = connection,
      name = "CompositeIndex"
    )
  return(TRUE)
}
