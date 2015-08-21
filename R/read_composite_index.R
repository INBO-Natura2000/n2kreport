#' Read the results for the composite indices
#' @param channel An open ODBC connection to the database
#' @return a \code{tbl_df} object with the data
#' @export
#' @importFrom RODBC sqlQuery
#' @importFrom dplyr %>% as.tbl
#' @importFrom assertthat assert_that
read_composite_index <- function(channel){
  assert_that(inherits(channel, "RODBC"))
  
  # nocov start
  sql <- "
WITH cteParameter
AS (
    SELECT
      ID,
      Description AS TopParameter,
      Description AS BottomParameter,
      ParentParameterID
    FROM
      Parameter
    WHERE
      Description = 'Composite index' AND
      ParentParameterID IS NULL
  UNION ALL
    SELECT
      Parameter.ID,
      cteParameter.TopParameter AS TopParameter,
      Parameter.Description AS BottomParameter,
      Parameter.ParentParameterID
    FROM
      Parameter
    INNER JOIN
      cteParameter
    ON
      Parameter.ParentParameterID = cteParameter.ID
),
cteSpeciesGroup
AS 
(
  SELECT
    Scheme.Description AS Scheme,
    SpeciesGroup.Description AS SpeciesGroup,
    SpeciesGroup.ID AS SpeciesGroupID
  FROM
    Scheme
  INNER JOIN
    SpeciesGroup
  ON
    Scheme.ID = SpeciesGroup.SchemeID
),
cteBaseAnalysis
AS
(
  SELECT
    ModelType.Description AS ModelType,
    Analysis.ID,
    Analysis.Fingerprint,
    Analysis.AnalysisDate,
    AnalysisStatus.Description AS Status,
    Analysis.SpeciesGroupID
  FROM
    (
        ModelType
      INNER JOIN
        ModelSet
      ON
        ModelType.ID = ModelSet.ModelTypeID
    )
  INNER JOIN
    (
      Analysis
    INNER JOIN
      AnalysisStatus
    On
      Analysis.StatusID = AnalysisStatus.ID
    )
  ON 
    ModelSet.ID = Analysis.ModelSetID
  WHERE
    ModelType.Description LIKE 'composite index:%'
),
cteAnalysis
AS
(
  SELECT
    Scheme,
    SpeciesGroup,
    ModelType,
    Fingerprint,
    AnalysisDate,
    Status,
    ID
  FROM
    cteSpeciesGroup
  INNER JOIN
    cteBaseAnalysis
  ON
    cteSpeciesGroup.SpeciesGroupID = cteBaseAnalysis.SpeciesGroupID
)

SELECT
  cteAnalysis.*,
  cteParameter.BottomParameter AS Period,
  ParameterEstimate.Estimate,
  ParameterEstimate.LCL,
  ParameterEstimate.UCL
FROM 
  cteAnalysis
LEFT JOIN
  (
    cteParameter
  INNER JOIN
    ParameterEstimate
  ON
    ParameterEstimate.ParameterID = cteParameter.ID
  )
  ON 
cteAnalysis.ID = ParameterEstimate.AnalysisID
  "
  sqlQuery(
    channel = channel, 
    query = sql, 
    stringsAsFactors = FALSE
  ) %>% as.tbl()
  # nocov end
}
