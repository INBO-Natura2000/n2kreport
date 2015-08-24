context("read_species")
expect_error(
  read_species("junk"),
  "connection does not inherit from class DBIConnection"
)
connection <- connect_local(dummy.path)
expect_is(
  read_species(connection),
  "data.frame"
)
DBI::dbDisconnect(connection)
