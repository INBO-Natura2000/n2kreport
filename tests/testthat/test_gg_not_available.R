context("gg_not_available")
expect_is(gg_not_available(), "ggplot")
expect_is(gg_not_available(title = "my title"), "ggplot")
expect_error(
  gg_not_available(title = NA),
  "title is not a string \\(a length one character vector\\)"
)
expect_error(
  gg_not_available(title = c("a", "b")),
  "title is not a string \\(a length one character vector\\)"
)
