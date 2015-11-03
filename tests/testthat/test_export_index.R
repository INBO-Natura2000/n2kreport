context("export_index")
expect_error(
  export_index(1),
  "connection does not inherit from class DBIConnection"
)
connection <- connect_local(dummy.path)
expect_is(
  export_index(connection, "CompositeIndex"),
  "data.frame"
)
