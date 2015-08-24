require(n2kreport)
shinyServer(function(input, output) {
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

  index <- reactive({
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
    read_index(
      connection = local.db,
      species = species.group,
      frequency = year.cycle
    )
  })

  output$composite <- renderPlot({
    to.plot <- index()
    if (nrow(to.plot) == 0 | all(is.na(to.plot$Estimate))) {
      return(gg_not_available(title = to.plot$SpeciesGroup[1]))
    }
    if (to.plot$ModelType[1] == "fYear") {
      to.plot$Period <- as.numeric(to.plot$Period)
      return(
        gg_index(index = to.plot, baseline = 1, title = to.plot$SpeciesGroup[1])
      )
    }

    to.plot$Period <- factor(to.plot$Period)
    labels <- levels(to.plot$Period)
    breaks <- seq_along(labels)
    to.plot$Period <- as.integer(to.plot$Period)
    gg_index(
      index = to.plot,
      baseline = 1,
      breaks = breaks,
      labels = labels,
      title = to.plot$SpeciesGroup[1]
    )
  })
  output$table <- renderDataTable({
    index()
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0(input$SpeciesGroup, "_", input$YearCycle, ".txt")
    },
    content = function(file) {
      write.table(index(), file, sep = "\t", row.names = FALSE)
    }
  )
}
)
