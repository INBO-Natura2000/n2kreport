context("refresh persistent storage")
describe("refresh persistent storage()", {
  remote.db <- n2khelper::connect_result()
  local.db <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  junk <- "junk"
  it("tests if the channel in an ODBC connection", {
    expect_error(
      refresh_persisent(remote.db = junk),
      "remote.db does not inherit from class RODBC"
    )
  })
  it("it stores the data localy", {
    skip_on_cran()
    refresh_persisent(remote.db = remote.db, local.db = local.db)

    expect_identical(
      DBI::dbListTables(local.db),
      c("CompositeIndex", "SpeciesIndex")
    )
  })
  if (class(remote.db) == "RODBC") {
    RODBC::odbcClose(remote.db)
  }
  DBI::dbDisconnect(local.db)
})
