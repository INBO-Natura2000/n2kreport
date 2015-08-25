require(n2kreport)
fluidPage(
  fluidRow(
    column(
      2,
      uiOutput("ui"),
      sliderInput(
        "imageSize",
        "plot size",
        min = 100,
        max = 1000,
        value = 600
      ),
      sliderInput(
        "baseSize",
        "font size",
        min = 1,
        max = 30,
        value = 16
      ),
      wellPanel(
        p(strong("Download data")),
        downloadButton("downloadData", "This index"),
        downloadButton("downloadDataAll", "All indices")
      ),
      wellPanel(
        p(strong("Download image")),
        downloadButton("downloadImage", "This index"),
        downloadButton("downloadImageAll", "All indices"),
        sliderInput(
          "plotWidth",
          "image width (cm)",
          min = 1,
          max = 50,
          value = 10
        ),
        sliderInput(
          "plotHeight",
          "image height (cm)",
          min = 1,
          max = 50,
          value = 10
        )
      )
    ),
    column(
      10,
      htmlOutput("analysisID"),
      uiOutput("plotIndex")
    )
  )
)
