context("connect_local")
expect_error(
  connect_local(1),
  "path is not a string \\(a length one character vector\\)"
)
expect_error(
  connect_local(c("abc", "junk")),
  "path is not a string \\(a length one character vector\\)"
)
expect_is(
  tmp.connection <- connect_local(":memory:"),
  "SQLiteConnection"
)
DBI::dbDisconnect(tmp.connection)
