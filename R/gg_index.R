#' Create a ggplot2 object on an index
#' @param index A \code{data.frame} with the indices
#' @param baseline An optional number
#' @param backtransform A logical value indicating is the results should be
#'    displayed in the original scale (\code{TRUE}) or in the log-scale
#'    (\code{FALSE})
#' @param breaks an optional vector of breaks on the x axis
#' @param labels an optional vector of labels on the x axis
#' @param title an optional title
#' @export
#' @importFrom assertthat assert_that is.flag noNA is.number is.string
#' @importFrom ggplot2 ggplot aes_string geom_hline geom_ribbon geom_line
#'    scale_x_continuous scale_y_continuous ggtitle facet_wrap
#' @importFrom scales percent
gg_index <- function(
  index,
  baseline,
  backtransform = TRUE,
  breaks,
  labels,
  title
){
  assert_that(is.flag(backtransform))
  assert_that(noNA(backtransform))
  if (!missing(title)) {
    assert_that(is.string(title))
  }

  if (backtransform) {
    index$Estimate <- exp(index$Estimate)
    index$LCL <- exp(index$LCL)
    index$UCL <- exp(index$UCL)
  }
  index$ShortFingerprint <- factor(
    substring(index$Fingerprint, 1, 10)
  )
  p <- ggplot(
    index,
    aes_string(x = "Period", y = "Estimate", ymin = "LCL", ymax = "UCL")
  )
  if (!missing(baseline)) {
    assert_that(is.number(baseline))
    p <- p + geom_hline(yintercept = baseline, linetype = 2)
  }
  p <- p +
    geom_ribbon(alpha = 0.2) +
    geom_line()
  if (length(unique(index$Fingerprint)) > 1) {
    p <- p + facet_wrap(~ShortFingerprint, scales = "free_y")
  }
  if (missing(breaks)) {
    p <- p + scale_x_continuous("")
  } else {
    if (missing(labels)) {
      p <- p + scale_x_continuous("", breaks = breaks)
    } else {
      p <- p + scale_x_continuous("", breaks = breaks, labels = labels)
    }
  }
  if (backtransform) {
    p <- p + scale_y_continuous("Index", label = percent)
  } else {
    p <- p + scale_y_continuous("Index")
  }
  if (!missing(title)) {
    p <- p + ggtitle(title)
  }
  return(p)
}
