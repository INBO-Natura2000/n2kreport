sql <- "
WITH cteAnalysis
AS
(
  SELECT
    sg.Scheme,
    sg.SpeciesGroup,
    an.ModelType,
    an.AnalysisID
  FROM
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
  ) AS sg
  INNER JOIN
  (
    SELECT
      ModelType.Description AS ModelType,
      Analysis.ID AS AnalysisID,
      Analysis.SpeciesGroupID AS SpeciesGroupID
    FROM
      (
        ModelType
      INNER JOIN
        ModelSet
      ON
        ModelType.ID = ModelSet.ModelTypeID
      )
    INNER JOIN
      Analysis
    ON 
      ModelSet.ID = Analysis.ModelSetID
    WHERE
      ModelType.Description LIKE 'composite index:%'
  ) AS an 
  ON
    sg.SpeciesGroupID = an.SpeciesGroupID
)

SELECT
  cteAnalysis.*,
  Parameter.Description AS Period,
  ParameterEstimate.Estimate,
  ParameterEstimate.LCL,
  ParameterEstimate.UCL
FROM 
  (
    cteAnalysis
  INNER JOIN
    ParameterEstimate
  ON
    cteAnalysis.AnalysisID = ParameterEstimate.AnalysisID
  )
INNER JOIN
  Parameter
ON 
  ParameterEstimate.ParameterID = Parameter.ID
"
index <- sqlQuery(channel = result.channel, query = sql, stringsAsFactors = TRUE)
  if (is.character(index)) {
    cat(index)
  } else {
    print(index %>% as.tbl())
  }
