#' Open a connection to the local database
#' @export
#' @param path the path to the local database
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom assertthat assert_that is.string
connect_local <- function(path = "~/analysis/n2kreport.sqlite"){
  assert_that(is.string(path))

  dbConnect(SQLite(), path)
}
