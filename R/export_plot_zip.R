#' Export all indices as plots
#' @export
#' @inheritParams utils::zip
#' @inheritParams read_species
#' @inheritParams plot_index
#' @inheritParams export_plot
#' @param reference Use the first index as reference. Default = FALSE
#' @importFrom dplyr %>% group_by_ do mutate_ arrange_ summarise_ inner_join transmute_ distinct_
#' @importFrom utils zip
export_plot_zip <- function(
  zipfile,
  connection,
  table,
  variable,
  base_size = 12,
  width = 10,
  height = 10,
  reference = FALSE
){
  ### Fooling R CMD Check ###
  . <- NULL
  rm(.)
  ### Fooling R CMD Check ###
  assert_that(is.flag(reference))
  assert_that(noNA(reference))

  current.wd <- getwd()
  setwd(tempdir())
  to.do <- export_index(connection, table = table)
  if (reference) {
    to.do <- set_reference(to.do)
  }
  fingerprint <- to.do %>%
    transmute_(
      ~ModelType,
      variable,
      Fingerprint = ~substr(Fingerprint, 1, 10)
    ) %>%
    distinct_() %>%
    group_by_(~ModelType, variable, ~SpeciesGroup) %>%
    arrange_(~Fingerprint) %>%
    summarise_(Fingerprint = ~paste(Fingerprint, collapse = "_"))
  to.do <- to.do %>%
    group_by_(~ModelType, variable, ~SpeciesGroup) %>%
    do(p = plot_index(., base_size = base_size)) %>%
    inner_join(fingerprint, by = c("ModelType", variable)) %>%
    mutate_(
      tmp = variable,
      file = ~paste0(tmp, "_",  ModelType, "_", Fingerprint, ".png")
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
