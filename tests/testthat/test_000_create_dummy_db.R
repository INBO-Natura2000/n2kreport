context("create_dummy_db")
assign("dummy.path", tempfile(fileext = ".db"), envir  = .GlobalEnv)
connection <- connect_local(dummy.path)
expect_error(
  create_dummy_db("junk"),
  "connection does not inherit from class DBIConnection"
)
expect_true(create_dummy_db(connection))
DBI::dbDisconnect(connection)
