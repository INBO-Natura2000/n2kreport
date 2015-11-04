context("connect_remote")
expect_error(
  connect_remote(develop = 1),
  "develop is not a flag \\(a length one logical vector\\)."
)
expect_error(
  connect_remote(develop = c(TRUE, FALSE)),
  "develop is not a flag \\(a length one logical vector\\)."
)
expect_error(
  connect_remote(develop = c(NA, NA)),
  "develop is not a flag \\(a length one logical vector\\)."
)
expect_error(
  connect_remote(develop = NA),
  "develop contains 1 missing values"
)
expect_error(
  connect_remote(develop = FALSE),
  "Production database not yet defined"
)
describe("connect_remote", {
  it("connect_remote opens the ODBC connection", {
    skip_on_cran()
    expect_is(channel <- connect_remote(develop = TRUE), "RODBC")
    expect_is(
      RODBC::sqlTables(channel = channel),
      "data.frame"
    )
  })
  if (class(channel) == "RODBC") {
    RODBC::odbcClose(channel)
  }
})
