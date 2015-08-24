context("plot_index")
connection <- connect_local(dummy.path)
index <- read_index(
  connection = connection,
  species = "A",
  frequency = "fYear"
)
index$Period <- as.numeric(index$Period)
expect_is(plot_index(index), "ggplot")
expect_is(plot_index(index[integer(0), ]), "ggplot")
expect_is(plot_index(index, base_size = 20), "ggplot")

expect_error(
  plot_index("junk"),
  "to.plot does not inherit from class data.frame"
)
expect_error(
  plot_index(index[, -2]),
  "to.plot does not have name ModelType"
)
expect_error(
  plot_index(index[, -3]),
  "to.plot does not have name SpeciesGroup"
)
expect_error(
  plot_index(index[, -4]),
  "to.plot does not have name Period"
)
expect_error(
  plot_index(index[, -5]),
  "to.plot does not have name Estimate"
)
expect_error(
  plot_index(index[, -7]),
  "to.plot does not have name LCL"
)
expect_error(
  plot_index(index[, -8]),
  "to.plot does not have name UCL"
)

expect_error(
  plot_index(index, base_size = "20"),
  "base_size is not a number \\(a length one numeric vector\\)"
)
expect_error(
  plot_index(index, base_size = c(20, 30)),
  "base_size is not a number \\(a length one numeric vector\\)"
)
expect_error(
  plot_index(index, base_size = -20),
  "base_size not greater than 0"
)

DBI::dbDisconnect(connection)
