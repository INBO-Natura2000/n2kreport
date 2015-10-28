#' Start the n2k_index Shiny app
#'
#' The n2k_index app display indices from the Natura 2000 monitoring
#' @export
#' @importFrom assertthat assert_that
#' @importFrom shiny runApp
#' @param local.path the path to store the local datawarehouse
start_n2k_index <- function(local.path = "~/analysis/n2kreport.sqlite") {
  app.dir <- system.file("shiny", "n2k_index", package = "n2kreport")
  # nocov start
  if (app.dir == "") {
    stop(
      "Could not find n2k_index directory. Try re-installing `n2kreport`.",
      call. = FALSE
    )
  }
  # nocov end
  refresh_persisent(
    remote.db = connect_remote(),
    local.db = connect_local(path = local.path)
  )
  runApp(app.dir, display.mode = "normal", launch.browser = TRUE) #nocov
}
