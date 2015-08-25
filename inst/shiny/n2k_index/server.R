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


  output$plotIndex <- renderUI({
    plotOutput(
      "composite",
      width = sprintf(
        "%.fpx",
        input$imageSize * pmin(input$plotWidth / input$plotHeight)
      ),
      height = sprintf(
        "%.fpx",
        input$imageSize * pmin(input$plotHeight / input$plotWidth)
      )
    )
  })

  output$composite <- renderPlot({
    plot_index(
      to.plot = index(),
      base_size = input$baseSize
    )
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("index_", input$SpeciesGroup, "_", input$YearCycle, ".txt")
    },
    content = function(file) {
      write.table(index(), file, sep = "\t", row.names = FALSE)
    }
  )

  output$downloadDataAll <- downloadHandler(
    filename = function() {
      "index_all.txt"
    },
    content = function(file) {
      write.table(export_index(local.db), file, sep = "\t", row.names = FALSE)
    }
  )

  output$downloadImage <- downloadHandler(
    filename = function() {
      paste0("index_", input$SpeciesGroup, "_", input$YearCycle, ".png")
    },
    content = function(file) {
      export_plot(
        file = file,
        plot = plot_index(index(), base_size = input$baseSize),
        width = input$plotWidth,
        height = input$plotHeight
      )
    }
  )
}
)
