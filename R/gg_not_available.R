#' ggplot object with text "No results available"
#' @export
#' @importFrom ggplot2 ggplot annotate theme_classic theme element_blank
gg_not_available <- function(){
  ggplot() +
    annotate("text", x = 1, y = 1, label = "No results available") +
    theme_classic() +
    theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.line = element_blank()
    )
}
