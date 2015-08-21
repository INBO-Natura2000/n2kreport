function(input, output) {
  local.db <- dbConnect(RSQLite::SQLite(), "~/analysis/n2kreport.sqlite")

  output$composite <- renderPlot({
    sql <- paste0(
"
SELECT
  *
FROM
  CompositeIndex
WHERE
  ModelType = 'fYear' AND
  SpeciesGroup = '", input$SpeciesGroup, "'
"
    )
    index <- dbGetQuery(conn = local.db, statement = sql)
    index$Period <- as.numeric(index$Period)
    gg_index(index = index, baseline = 1)
  })
}
