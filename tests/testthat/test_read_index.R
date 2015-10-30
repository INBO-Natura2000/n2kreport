context("read_index")
connection <- connect_local(dummy.path)
expect_error(
  read_index(connection = "junk"),
  "connection does not inherit from class DBIConnection"
)
expect_error(
  read_species(connection, "junk", "junk"),
  "dbExistsTable\\(conn = connection, name = table\\) is not TRUE"
)
expect_error(
  read_species(connection, "CompositeIndex", "junk"),
  "`%in%`\\(x = variable, table = dbListFields\\(connection, table\\)\\) is not TRUE" #nolint
)
expect_error(
  read_index(
    connection = connection,
    table = "CompositeIndex",
    variable = "SpeciesGroup",
    species = 1
  ),
  "species is not a string \\(a length one character vector\\)"
)
expect_error(
  read_index(
    connection = connection,
    table = "CompositeIndex",
    variable = "SpeciesGroup",
    species = c("A", "B")
  ),
  "species is not a string \\(a length one character vector\\)"
)
expect_error(
  read_index(
    connection = connection,
    table = "CompositeIndex",
    variable = "SpeciesGroup",
    species = "A",
    frequency = 1
  ),
  "frequency is not a string \\(a length one character vector\\)"
)
expect_error(
  read_index(
    connection = connection,
    table = "CompositeIndex",
    variable = "SpeciesGroup",
    species = "A",
    frequency = c("a", "")
  ),
  "frequency is not a string \\(a length one character vector\\)"
)
expect_is(
  read_index(
    connection = connection,
    table = "CompositeIndex",
    variable = "SpeciesGroup",
    species = "A",
    frequency = "fYear"
  ),
  "data.frame"
)
expect_is(
  read_index(
    connection = connection,
    table = "CompositeIndex",
    variable = "SpeciesGroup",
    species = "A",
    frequency = "fCycle"
  ),
  "data.frame"
)
DBI::dbDisconnect(connection)
