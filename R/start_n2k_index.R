#' Start the n2k_index Shiny app
#'
#' The n2k_index app display indices from the Natura 2000 monitoring
#' @export
#' @importFrom assertthat assert_that
#' @importFrom shiny runApp
start_n2k_index <- function() {
  app.dir <- system.file("shiny", "n2k_index", package = "n2kreport")
  # nocov start
  if (app.dir == "") {
    stop(
      "Could not find n2k_index directory. Try re-installing `n2kreport`.",
      call. = FALSE
    )
  }
  # nocov end
  assert_that(interactive())
  runApp(app.dir, display.mode = "normal") #nocov
}
