require(n2kreport)

shinyServer(function(input, output) {
  local.db <- connect_local()

  comp.species <- read_species(
    connection = local.db,
    table = "CompositeIndex",
    variable = "SpeciesGroup"
  )
  output$comp.ui <- renderUI({
    list(
      selectInput(
        inputId = "comp.SpeciesGroup",
        label = "Species group",
        choices = comp.species$SpeciesGroup,
        selected = comp.species$Species[1]
      ),
      radioButtons(
        inputId = "comp.YearCycle",
        label = "Frequency",
        choices = c(Year = "fYear", Cycle = "fCycle"),
        selected = "fYear"
      )
    )
  })

  comp.index <- reactive({
    comp.species.group <- ifelse(
      is.null(input$comp.SpeciesGroup),
      comp.species$Species[1],
      input$comp.SpeciesGroup
    )
    comp.year.cycle <- ifelse(
      is.null(input$comp.YearCycle),
      "fYear",
      input$comp.YearCycle
    )
    read_index(
      connection = local.db,
      species = comp.species.group,
      frequency = comp.year.cycle
    )
  })

  comp.analysis <- reactive({
    paste(
      substring(unique(comp.index()$Fingerprint), 1, 10),
      collapse = "-"
    )
  })

  output$comp.analysisID <- renderText({
    paste(
      "<b>Analysis ID:</b>",
      comp.analysis()
    )
  })


  output$comp.plotIndex <- renderUI({
    plotOutput(
      "comp.plot",
      width = sprintf(
        "%.fpx",
        input$comp.imageSize * input$comp.plotWidth / input$comp.plotHeight
      ),
      height = sprintf(
        "%.fpx",
        input$comp.imageSize * input$comp.plotHeight / input$comp.plotWidth
      )
    )
  })

  output$comp.plot <- renderPlot({
    plot_index(
      to.plot = comp.index(),
      base_size = input$comp.baseSize
    )
  })

  output$comp.downloadData <- downloadHandler(
    filename = function() {
      paste0(
        "comp_index_",
        input$comp.SpeciesGroup, "_",
        input$comp.YearCycle, "_",
        comp.analysis(),
        ".txt"
      )
    },
    content = function(file) {
      write.table(comp.index(), file, sep = "\t", row.names = FALSE)
    }
  )

  output$comp.downloadDataAll <- downloadHandler(
    filename = function() {
      "comp_index_all.txt"
    },
    content = function(file) {
      write.table(export_index(local.db), file, sep = "\t", row.names = FALSE)
    }
  )

  output$comp.downloadImage <- downloadHandler(
    filename = function() {
      paste0(
        "comp_index_",
        input$comp.SpeciesGroup, "_",
        input$comp.YearCycle, "_",
        comp.analysis(),
        ".png"
      )
    },
    content = function(file) {
      export_plot(
        file = file,
        plot = plot_index(index(), base_size = input$comp.baseSize),
        width = input$comp.plotWidth,
        height = input$comp.plotHeight
      )
    }
  )

  output$comp.downloadImageAll <- downloadHandler(
    filename = function() {
      sha1 <- get_sha1(export_index(local.db))
      paste0("comp_index_",  sha1, ".zip")
    },
    content = function(file) {
      export_plot_zip(
        zipfile = file,
        connection = local.db,
        base_size = input$comp.baseSize,
        width = input$comp.plotWidth,
        height = input$plotHeight
      )
    }
  )
}
)
