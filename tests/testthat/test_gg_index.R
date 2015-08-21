context("gg_index")
requireNamespace("dplyr", quitely = TRUE)
n <- 10
junk <- "abc"
index <- data.frame(
  Period = seq_len(n),
  Estimate = runif(n),
  Error = runif(n)
) %>%
  dplyr::mutate_(LCL = ~Estimate - Error, UCL = ~Estimate + Error)

# works with the defaults
expect_is(gg_index(index), "ggplot")

# tests the baseline
expect_error(
  gg_index(index, baseline = junk),
  "baseline is not a number \\(a length one numeric vector\\)"
)
# requires a single baseline
expect_error(
  gg_index(index, baseline = 1:2),
  "baseline is not a number \\(a length one numeric vector\\)"
)
# adds a layer when a baseline is set
with.baseline <- gg_index(index, baseline = 1)
no.baseline <- gg_index(index)
expect_identical(
  length(with.baseline$layers),
  length(no.baseline$layers) + 1L
)
