#' Create a ggplot2 object on an index
#' @param index A \code{data.frame} with the indices
#' @param baseline An optional number 
#' @param backtransform A logical value indicating is the results should be 
#'    displayed in the original scale (\code{TRUE}) or in the log-scale 
#'    (\code{FALSE})
#' @export
#' @importFrom assertthat assert_that is.flag noNA is.number
#' @importFrom ggplot2 ggplot aes_string geom_hline geom_errorbar geom_point 
#'    scale_x_continuous scale_y_continuous
#' @importFrom scales percent
gg_index <- function(index, baseline = 1, backtransform = TRUE){
  assert_that(is.flag(backtransform))
  assert_that(noNA(backtransform))
  
  if (backtransform) {
    index$Estimate <- exp(index$Estimate)
    index$LCL <- exp(index$LCL)
    index$UCL <- exp(index$UCL)
  }
  p <- ggplot(
    index, 
    aes_string(x = "Period", y = "Estimate", ymin = "LCL", ymax = "UCL")
  ) 
  if (!missing(baseline)) {
    assert_that(is.number(baseline))
    p <- p + geom_hline(yintercept = baseline, linetype = 3)
  }
  p <- p + geom_errorbar() + geom_point() + scale_x_continuous("")
  if (backtransform) {
    p + scale_y_continuous("Index", label = percent)
  } else {
    p + scale_y_continuous("Index")
  }
}
