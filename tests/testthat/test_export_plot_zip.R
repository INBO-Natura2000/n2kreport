context("export_plot_all")
connection <- connect_local(dummy.path)
zipfile <- tempfile(fileext = ".zip")
expect_false(file.exists(zipfile))
export_plot_zip(
  zipfile = zipfile,
  connection = connection,
  table = "CompositeIndex",
  variable = "SpeciesGroup"
)
expect_true(file.exists(zipfile))
file.remove(zipfile)
