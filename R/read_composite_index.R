sql <- "
WITH cteParameter
AS (
  SELECT
    P1.ID AS ParameterID,
    P1.Description AS Period
  FROM
    Parameter AS P0
  INNER JOIN
    Parameter AS P1
  ON
    P0.ID = P1.ParentParameterID
  WHERE
    P0.Description = 'Composite index'
)

SELECT
  cteParameter.Period,
  ParameterEstimate.Estimate,
  ParameterEstimate.LCL,
  ParameterEstimate.UCL,
  ParameterEstimate.AnalysisID
FROM
  cteParameter
INNER JOIN
  ParameterEstimate
ON
  cteParameter.ParameterID = ParameterEstimate.ParameterID
"
sql <- "
"
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
  *
FROM 
  cteAnalysis
"
  index <- sqlQuery(channel = result.channel, query = sql, stringsAsFactors = TRUE)
  if (is.character(index)) {
    cat(index)
  } else {
    print(index %>% as.tbl())
  }
