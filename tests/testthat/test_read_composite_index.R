context("read_composite_index")
describe("read_composite_index()", {
  channel <- n2khelper::connect_result()
  junk <- "junk"
  it("tests if the channel in an ODBC connection", {
    expect_error(
      read_composite_index(channel = junk),
      "channel does not inherit from class RODBC"
    )
  })
  it("it returns a data.frame", {
    skip_on_cran()
    expect_is(
      read_composite_index(channel = channel),
      "data.frame"
    )
  })
  if (class(channel) == "RODBC") {
    RODBC::odbcClose(channel)
  }
})
