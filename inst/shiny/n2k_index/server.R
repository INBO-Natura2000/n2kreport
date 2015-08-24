require(n2kreport)
function(input, output) {
  local.db <- connect_local()

  species <- read_species(connection = local.db)
  output$ui <- renderUI({
    list(
        selectInput(
        "SpeciesGroup",
        "Species group",
        choices = species$SpeciesGroup,
        selected = species$Species[1]
      ),
      radioButtons(
        "YearCycle",
        "Frequency",
        choices = c(Year = "fYear", Cycle = "fCycle"),
        selected = "fYear"
      )
    )
  })

  output$composite <- renderPlot({
    species.group <- ifelse(
      is.null(input$SpeciesGroup),
      species$Species[1],
      input$SpeciesGroup
    )
    year.cycle <- ifelse(
      is.null(input$YearCycle),
      "fYear",
      input$YearCycle
    )
    index <- read_index(
      connection = local.db,
      species = species.group,
      frequency = year.cycle
    )
    if (nrow(index) == 0 | all(is.na(index$Estimate))) {
      return(gg_not_available(title = species.group))
    }
    if (year.cycle == "fYear") {
      index$Period <- as.numeric(index$Period)
      return(
        gg_index(index = index, baseline = 1, title = species.group)
      )
    }

    index$Period <- factor(index$Period)
    labels <- levels(index$Period)
    breaks <- seq_along(labels)
    index$Period <- as.integer(index$Period)
    gg_index(
      index = index,
      baseline = 1,
      breaks = breaks,
      labels = labels,
      title = species.group
    )
  })
}
