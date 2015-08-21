fluidPage(
  titlePanel("Composite indices"),

  sidebarPanel(
    selectInput(
      inputId = "SpeciesGroup",
      label = "Species group",
      choices = c("Bos", "Generalist"),
      selected = "Bos"
    )
  ),
  mainPanel(
    plotOutput("composite")
  )
)
