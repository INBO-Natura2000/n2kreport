fluidPage(
  titlePanel("Composite indices"),

  sidebarPanel(
    uiOutput("ui")
  ),
  mainPanel(
    plotOutput("composite")
  )
)
