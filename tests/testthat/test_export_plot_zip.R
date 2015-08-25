context("export_plot_all")
connection <- connect_local(dummy.path)
zipfile <- tempfile(fileext = ".zip")
expect_true(
  file.exists(export_plot_zip(zipfile = zipfile, connection = connection))
)
expect_true(
  file.exists(export_plot_zip(zipfile = zipfile, connection = connection))
)
