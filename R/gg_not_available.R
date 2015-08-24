#' ggplot object with text "No results available"
#' @export
#' @inheritParams gg_index
#' @importFrom assertthat assert_that is.string
#' @importFrom ggplot2 ggplot annotate theme_classic theme element_blank ggtitle
gg_not_available <- function(title){
  if (!missing(title)) {
    assert_that(is.string(title))
  }

  p <- ggplot() +
    annotate("text", x = 1, y = 1, label = "No results available") +
    theme_classic() +
    theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.line = element_blank()
    )
  if (!missing(title)) {
    p <- p + ggtitle(title)
  }
  return(p)
}
