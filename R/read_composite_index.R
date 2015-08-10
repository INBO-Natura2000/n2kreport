  sql <- "
    SELECT
      Fingerprint,
      SpeciesGroupID,
      LocationGroupID,
      AnalysisDate,
      Description,
      Estimate,
      LCL,
      UCL
    FROM
        Analysis
      INNER JOIN
        (
          SELECT
            AnalysisID,
            Description,
            Estimate,
            LCL,
            UCL
          FROM
              ParameterEstimate
            INNER JOIN
              (
                SELECT
                  Parameter.ID AS ID,
                  Description
                FROM
                    Parameter
                  INNER JOIN
                    (
                      SELECT
                        ID
                      FROM
                        Parameter
                      WHERE
                        Description = 'Composite index'
                    ) AS CompositeIndex
                  ON
                    parameter.ParentParameterID = CompositeIndex.ID
              ) AS SelectedParameter
            ON
              ParameterEstimate.ParameterID = SelectedParameter.ID
        ) AS SelectedEstimate
      ON
        Analysis.ID = SelectedEstimate.AnalysisID
  "
  index <- sqlQuery(channel = result.channel, query = sql, stringsAsFactors = TRUE)
  summary(index)
  head(index, 20)
