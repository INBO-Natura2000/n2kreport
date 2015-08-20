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
WITH cteSpeciesGroup
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
)

SELECT
  cteSpeciesGroup.Scheme AS Scheme,
  cteSpeciesGroup.SpeciesGroup AS SpeciesGroup,
  ModelType.Description AS ModelType,
  Analysis.ID AS AnalysisID
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
    cteSpeciesGroup
  ON
    Analysis.SpeciesGroupID = cteSpeciesGroup.SpeciesGroupID
  )
ON 
  ModelSet.ID = Analysis.ModelSetID
WHERE
  ModelType.Description LIKE 'composite index:%'
"
  index <- sqlQuery(channel = result.channel, query = sql, stringsAsFactors = TRUE)
  if (is.character(index)) {
    cat(index)
  } else {
    print(index %>% as.tbl())
  }
