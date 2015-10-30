context("export_plot")
connection <- connect_local(dummy.path)
index <- read_index(
  connection = connection,
  table = "CompositeIndex",
  variable = "SpeciesGroup",
  species = "A",
  frequency = "fYear"
)
p <- plot_index(index)
file <- tempfile(fileext = ".png")

export_plot(file = file, plot = p)
expect_true(file.exists(file))
file.remove(file)

export_plot(file = file, plot = p, width = 5)
expect_true(file.exists(file))
file.remove(file)

export_plot(file = file, plot = p, height = 5)
expect_true(file.exists(file))
file.remove(file)

export_plot(file = file, plot = p, width = 5, height = 5)
expect_true(file.exists(file))
file.remove(file)

expect_error(
  export_plot(file = 1, plot = p),
  "file is not a string \\(a length one character vector\\)."
)
expect_error(
  export_plot(file = rep(file, 2), plot = p),
  "file is not a string \\(a length one character vector\\)."
)

expect_error(
  export_plot(file = file, plot = "junk"),
  "plot does not inherit from class ggplot"
)

expect_error(
  export_plot(file = file, plot = p, width = "20"),
  "width is not a number \\(a length one numeric vector\\)"
)
expect_error(
  export_plot(file = file, plot = p, width = c(20, 30)),
  "width is not a number \\(a length one numeric vector\\)"
)
expect_error(
  export_plot(file = file, plot = p, width = -20),
  "width not greater than 0"
)

expect_error(
  export_plot(file = file, plot = p, height = "20"),
  "height is not a number \\(a length one numeric vector\\)"
)
expect_error(
  export_plot(file = file, plot = p, height = c(20, 30)),
  "height is not a number \\(a length one numeric vector\\)"
)
expect_error(
  export_plot(file = file, plot = p, height = -20),
  "height not greater than 0"
)


DBI::dbDisconnect(connection)
