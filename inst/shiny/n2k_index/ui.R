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
      ),
      wellPanel(
        p(strong("Download image")),
        downloadButton("downloadImage", "This index")
      )
    ),
    column(
      10,
      plotOutput("composite")
    )
  )
)
