#' Export all indices as plots
#' @export
#' @inheritParams utils::zip
#' @inheritParams read_species
#' @inheritParams plot_index
#' @inheritParams export_plot
#' @importFrom dplyr %>% group_by_ do mutate_
#' @importFrom utils zip
export_plot_zip <- function(
  zipfile,
  connection,
  base_size = 12,
  width = 10,
  height = 10
){
  ### Fooling R CMD Check ###
  . <- NULL
  rm(.)
  ### Fooling R CMD Check ###

  current.wd <- getwd()
  setwd(tempdir())
  to.do <- export_index(connection) %>%
    group_by_(~ModelType, ~SpeciesGroup, ~Fingerprint) %>%
    do(p = plot_index(., base_size = base_size)) %>%
    mutate_(
      file = ~paste0(SpeciesGroup, "_",  ModelType, "_", Fingerprint, ".png")
    )
  for (i in seq_along(to.do$file)) {
    export_plot(
      file = to.do$file[i],
      plot = to.do$p[[i]],
      width = width,
      height = height
    )
  }
  zip(zipfile = zipfile, files = to.do$file, flags = "-q")
  setwd(current.wd)
  return(zipfile)
}
