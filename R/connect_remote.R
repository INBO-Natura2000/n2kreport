#' Make a read-only connection to the remote database
#' @param develop Use the development database (TRUE) or the production database
#'    (FALSE).
#' @export
#' @importFrom assertthat assert_that is.flag noNA
#' @importFrom RODBC odbcDriverConnect
connect_remote <- function(develop = TRUE){
  assert_that(is.flag(develop))
  assert_that(noNA(develop))

  if (develop) {
    odbcDriverConnect(
      "Driver=SQL Server;Server=INBODEV02\\development;
      Database=D0116on00_SoortenMeetnetAnalyse;
      User Id=D0116_RptSoortenMeetnetAnalyse;Password=devdev;"
    )
  } else {
    stop("Production database not yet defined")
  }
}
