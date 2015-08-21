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
cteAnalysis
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
  cteParameter.BottomParameter AS Period,
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
  cteParameter
ON 
  ParameterEstimate.ParameterID = cteParameter.ID
"
index <- sqlQuery(channel = result.channel, query = sql, stringsAsFactors = TRUE)
  if (is.character(index)) {
    cat(index)
  } else {
    print(index %>% as.tbl())
    print(
      ggplot(
        index, 
        aes(
          x = Period, 
          y = exp(Estimate), 
          ymin = exp(LCL), 
          ymax = exp(UCL)
        )
      ) + 
        geom_hline(yintercept = 1, linetype = 3) +
        geom_errorbar() + 
        geom_point() + 
        facet_grid(SpeciesGroup~ModelType, scales = "free_x") + 
        scale_y_continuous("Index", labels = percent)
    )
  }
