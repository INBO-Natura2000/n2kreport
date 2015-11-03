require(n2kreport)

shinyServer(function(input, output) {
  local.db <- connect_local()

  species <- read_species(
    connection = local.db,
    table = "SpeciesIndex",
    variable = "SpeciesGroup"
  )
  output$ui <- renderUI({
    list(
      selectInput(
        inputId = "SpeciesGroup",
        label = "Species group",
        choices = species$SpeciesGroup,
        selected = species$Species[1]
      ),
      radioButtons(
        inputId = "YearCycle",
        label = "Frequency",
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
    index <- read_index(
      connection = local.db,
      table = "SpeciesIndex",
      variable = "SpeciesGroup",
      species = species.group,
      frequency = year.cycle
    )
    set_reference(index)
  })

  analysis <- reactive({
    paste(
      substring(unique(index()$Fingerprint), 1, 10),
      collapse = "-"
    )
  })

  output$analysisID <- renderText({
    paste(
      "<b>Analysis ID:</b>",
      analysis()
    )
  })


  output$plotIndex <- renderUI({
    plotOutput(
      "plot",
      width = sprintf(
        "%.fpx",
        input$imageSize * input$plotWidth / input$plotHeight
      ),
      height = sprintf(
        "%.fpx",
        input$imageSize * input$plotHeight / input$plotWidth
      )
    )
  })

  output$plot <- renderPlot({
    plot_index(
      to.plot = index(),
      base_size = input$baseSize
    )
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0(
        "index_",
        input$SpeciesGroup, "_",
        input$YearCycle, "_",
        analysis(),
        ".txt"
      )
    },
    content = function(file) {
      write.table(x = index(), file = file, sep = "\t", row.names = FALSE)
    }
  )

  output$downloadDataAll <- downloadHandler(
    filename = function() {
      "index_all.txt"
    },
    content = function(file) {
      write.table(
        x = export_index(local.db, table = "SpeciesIndex") %>%
          set_reference(),
        file = file,
        sep = "\t",
        row.names = FALSE
      )
    }
  )

  output$downloadImage <- downloadHandler(
    filename = function() {
      paste0(
        "index_",
        input$SpeciesGroup, "_",
        input$YearCycle, "_",
        analysis(),
        ".png"
      )
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

  output$downloadImageAll <- downloadHandler(
    filename = function() {
      sha1 <- export_index(local.db, table = "SpeciesIndex") %>%
        set_reference() %>%
        get_sha1()
      paste0("index_",  sha1, ".zip")
    },
    content = function(file) {
      export_plot_zip(
        zipfile = file,
        connection = local.db,
        table = "SpeciesIndex",
        variable = "SpeciesGroup",
        base_size = input$baseSize,
        width = input$plotWidth,
        height = input$plotHeight,
        reference = TRUE
      )
    }
  )
}
)
