#' Final preparation of dataset and plot
#' @export
#' @param to.plot the dataset to plot
#' @param base_size The base font size
#' @importFrom assertthat assert_that is.number has_name
plot_index <- function(to.plot, base_size = 12){
  assert_that(inherits(to.plot, "data.frame"))
  assert_that(has_name(to.plot, "SpeciesGroup"))
  assert_that(has_name(to.plot, "ModelType"))
  assert_that(has_name(to.plot, "Period"))
  assert_that(has_name(to.plot, "Estimate"))
  assert_that(has_name(to.plot, "LCL"))
  assert_that(has_name(to.plot, "UCL"))
  assert_that(is.number(base_size))
  assert_that(base_size > 0)

  if ("INBOtheme" %in% installed.packages()[, "Package"]) {
    theme_index <- INBOtheme::theme_inbo2015 # nocov
  } else {
    theme_index <- ggplot2::theme_gray
  }

  if (nrow(to.plot) == 0 | all(is.na(to.plot$Estimate))) {
    return(
      gg_not_available(title = to.plot$SpeciesGroup[1]) +
        theme_index(base_size = base_size)
    )
  }
  if (to.plot$ModelType[1] == "fYear") {
    to.plot$Period <- as.numeric(to.plot$Period)
    return(
      gg_index(index = to.plot, baseline = 1, title = to.plot$SpeciesGroup[1]) +
        theme_index(base_size = base_size)
    )
  }

  to.plot$Period <- factor(to.plot$Period)
  labels <- levels(to.plot$Period)
  breaks <- seq_along(labels)
  to.plot$Period <- as.integer(to.plot$Period)
  gg_index(
    index = to.plot,
    baseline = 1,
    breaks = breaks,
    labels = labels,
    title = to.plot$SpeciesGroup[1]
  ) +
    theme_index(base_size = base_size)
}
