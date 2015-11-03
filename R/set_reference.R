#' Use the first value of Period as a reference
#' @export
#' @param index a data.frame
#' @importFrom dplyr %>% mutate_ summarise_ inner_join select_
#' @importFrom assertthat has_name
set_reference <- function(index){
  assert_that(inherits(index, "data.frame"))
  assert_that(has_name(index, "Period"))
  assert_that(has_name(index, "Estimate"))
  assert_that(has_name(index, "LCL"))
  assert_that(has_name(index, "UCL"))
  assert_that(has_name(index, "Fingerprint"))

  index2 <- index %>%
    mutate_(Ref = ~as.integer(factor(Period)))
  reference <- index2 %>%
    group_by_(~Fingerprint) %>%
    summarise_(Ref = ~min(Ref)) %>%
    inner_join(
      index2 %>%
        select_(~Fingerprint, ~Ref, ~Estimate),
      by = c("Fingerprint", "Ref")
    ) %>%
    select_(~Fingerprint, Reference = ~Estimate)
  index %>%
    inner_join(reference, by = "Fingerprint") %>%
    mutate_(
      Estimate = ~Estimate - Reference,
      LCL = ~LCL - Reference,
      UCL = ~UCL - Reference
    )
}
