require(n2kreport)
require(ggplot2)

plot_index <- function(to.plot, base_size = 12){
  if (nrow(to.plot) == 0 | all(is.na(to.plot$Estimate))) {
    return(
      gg_not_available(title = to.plot$SpeciesGroup[1]) +
        theme_gray(base_size = base_size)
    )
  }
  if (to.plot$ModelType[1] == "fYear") {
    to.plot$Period <- as.numeric(to.plot$Period)
    return(
      gg_index(index = to.plot, baseline = 1, title = to.plot$SpeciesGroup[1]) +
        theme_gray(base_size = base_size)
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
  ) +
    theme_gray(base_size = base_size)
}

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

  output$table <- renderDataTable({
    index()
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
      ggsave(
        filename = file,
        plot = plot_index(index(), base_size = input$baseSize),
        units = "cm",
        scale = 2,
        width = input$plotWidth,
        height = input$plotHeight
      )
    }
  )
}
)
