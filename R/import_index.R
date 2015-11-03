#' import indices per species
#' @export
#' @inheritParams import_composite_index
#' @importFrom RODBC sqlQuery
#' @importFrom dplyr %>% mutate_ filter_ bind_rows select_
import_index <- function(channel){
  sql <- "
  with cteBaseAnalysis AS (
    SELECT
      Analysis.ID AS AnalysisID,
      SpeciesGroupID,
      ModelType.Description AS ModelType,
      Analysis.LastYear,
      StatusID,
      Fingerprint AS Analysis,
      StatusFingerprint
    FROM
      (
        Analysis
      INNER JOIN
        ModelSet
      ON
        Analysis.ModelSetID = ModelSet.ID
      )
    INNER JOIN
      ModelType
    ON
      ModelSet.ModelTypeID = ModelType.ID
    WHERE
      ModelType.Description LIKE 'inla nbinomial: %'
  ),
  cteAnalysis AS
  (
    SELECT
      AnalysisID,
      SpeciesGroup.Description AS SpeciesGroup,
      ModelType,
      LastYear,
      AnalysisStatus.Description AS Status,
      Analysis,
      StatusFingerprint
    FROM
      (
        cteBaseAnalysis
      INNER JOIN
        AnalysisStatus
      ON
        cteBaseAnalysis.StatusID = AnalysisStatus.ID
      )
    INNER JOIN
      SpeciesGroup
    ON
      cteBaseAnalysis.SpeciesGroupID = SpeciesGroup.ID
  )

  SELECT
    SpeciesGroup,
    ModelType,
    LastYear,
    Contrast.Description AS Period,
    Estimate,
    LCL,
    UCL,
    Analysis AS Fingerprint,
    Status,
    StatusFingerprint
  FROM
    (
      ContrastEstimate
    INNER JOIN
      Contrast
    ON
      ContrastEstimate.ContrastID = Contrast.ID
    )
  RIGHT JOIN
    cteAnalysis
  ON
    Contrast.AnalysisID = cteAnalysis.AnalysisID
  WHERE
    Contrast.Description <> 'Trend'
  "
  result <- sqlQuery(channel = channel, query = sql, stringsAsFactors = FALSE)
  result <-
    result %>%
    mutate_(
      ModelType = ~gsub("^inla nbinomial: ", "", ModelType) %>%
        gsub(pattern = " +.*$", replacement = "")
    )
  result %>%
    filter_(~ModelType == "cYear") %>%
    mutate_(Period = ~as.character(as.integer(Period) + LastYear)) %>%
    bind_rows(
      result %>%
        filter_(~ModelType != "cYear")
    ) %>%
    select_(~-LastYear) %>%
    as.data.frame()
}
