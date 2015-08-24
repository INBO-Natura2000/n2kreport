require(n2kreport)
fluidPage(
  fluidRow(
    column(
      2,
      uiOutput("ui"),
      wellPanel(
        p(strong("Download data")),
        downloadButton("downloadData", "This index"),
        downloadButton("downloadDataAll", "All indices")
      )
    ),
    column(
      10,
      plotOutput("composite")
    )
  )
)
