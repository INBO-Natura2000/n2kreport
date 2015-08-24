require(n2kreport)
function(input, output) {
  local.db <- connect_local()

  species <- read_species(connection = local.db)
  output$ui <- renderUI({
    selectInput(
      "SpeciesGroup",
      "Species group",
      choices = species$SpeciesGroup,
      selected = species$Species[1]
    )
  })

  output$composite <- renderPlot({
    species.group <- ifelse(
      is.null(input$SpeciesGroup),
      species$Species[1],
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
