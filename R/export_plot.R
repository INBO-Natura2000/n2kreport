#' Export a single plot
#' @param file the name of the output file
#' @param plot a ggplot2 object
#' @param width the width in cm
#' @param height the height in cm
#' @export
#' @importFrom assertthat assert_that is.string is.number
#' @importFrom ggplot2 ggsave
export_plot <- function(file, plot, width = 10, height = 10){
  assert_that(is.string(file))
  assert_that(inherits(plot, "ggplot"))
  assert_that(is.number(width))
  assert_that(is.number(height))
  assert_that(width > 0)
  assert_that(height > 0)

  ggsave(
    filename = file,
    plot = plot,
    units = "cm",
    scale = 2,
    width = width,
    height = height
  )
}
