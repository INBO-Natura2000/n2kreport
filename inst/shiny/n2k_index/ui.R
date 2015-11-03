require(n2kreport)
fluidPage(
  fluidRow(
    column(
      2,
      uiOutput("ui"),
      sliderInput(
        inputId = "imageSize",
        label = "plot size",
        min = 100,
        max = 1000,
        value = 600
      ),
      sliderInput(
        inputId = "baseSize",
        label = "font size",
        min = 1,
        max = 30,
        value = 16
      ),
      wellPanel(
        p(strong("Download data")),
        downloadButton(outputId = "downloadData", label = "This index"),
        downloadButton(outputId = "downloadDataAll", label = "All indices")
      ),
      wellPanel(
        p(strong("Download image")),
        downloadButton("downloadImage", "This index"),
        downloadButton("downloadImageAll", "All indices"),
        sliderInput(
          inputId = "plotWidth",
          label = "image width (cm)",
          min = 1,
          max = 50,
          value = 10
        ),
        sliderInput(
          inputId = "plotHeight",
          label = "image height (cm)",
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
