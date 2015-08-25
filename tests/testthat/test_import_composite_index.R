context("import_composite_index")
describe("import_composite_index()", {
  channel <- connect_remote()
  junk <- "junk"
  it("tests if the channel in an ODBC connection", {
    expect_error(
      import_composite_index(channel = junk),
      "channel does not inherit from class RODBC"
    )
  })
  it("it returns a data.frame", {
    skip_on_cran()
    expect_is(
      import_composite_index(channel = channel),
      "data.frame"
    )
  })
  if (class(channel) == "RODBC") {
    RODBC::odbcClose(channel)
  }
})
