function(input, output) {
  local.db <- dbConnect(RSQLite::SQLite(), "~/analysis/n2kreport.sqlite")

  sql <- paste0("
SELECT DISTINCT
  SpeciesGroup
FROM
  CompositeIndex
ORDER BY
  SpeciesGroup
  ")
  species.groups <- dbGetQuery(conn = local.db, statement = sql)

  output$ui <- renderUI({
    selectInput(
      "SpeciesGroup",
      "Species group",
      choices = species.groups$SpeciesGroup,
      selected = species.groups$SpeciesGroup[1]
    )
  })

  output$composite <- renderPlot({
    species.group <- ifelse(
      is.null(input$SpeciesGroup),
      species.groups$SpeciesGroup[1],
      input$SpeciesGroup
    )
    sql <- paste0(
"
SELECT
  *
FROM
  CompositeIndex
WHERE
  ModelType = 'fYear' AND
  SpeciesGroup = '", species.group, "'
"
    )
    index <- dbGetQuery(conn = local.db, statement = sql)
    index$Period <- as.numeric(index$Period)
    gg_index(index = index, baseline = 1)
  })
}
