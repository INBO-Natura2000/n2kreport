context("read_species")
expect_error(
  read_species("junk", "junk", "junk"),
  "connection does not inherit from class DBIConnection"
)
connection <- connect_local(dummy.path)
expect_error(
  read_species(connection, "junk", "junk"),
  "dbExistsTable\\(conn = connection, name = table\\) is not TRUE"
)
expect_error(
  read_species(connection, "CompositeIndex", "junk"),
  "`%in%`\\(x = variable, table = dbListFields\\(connection, table\\)\\) is not TRUE" #nolint
)
expect_is(
  read_species(connection, "CompositeIndex", "SpeciesGroup"),
  "data.frame"
)
DBI::dbDisconnect(connection)
