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
    gg_index(
      index = read_index(connection = local.db, species = species.group),
      baseline = 1
    )
  })
}
