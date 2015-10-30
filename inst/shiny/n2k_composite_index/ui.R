require(n2kreport)
fluidPage(
  fluidRow(
    column(
      2,
      uiOutput("comp.ui"),
      sliderInput(
        inputId = "comp.imageSize",
        label = "plot size",
        min = 100,
        max = 1000,
        value = 600
      ),
      sliderInput(
        inputId = "comp.baseSize",
        label = "font size",
        min = 1,
        max = 30,
        value = 16
      ),
      wellPanel(
        p(strong("Download data")),
        downloadButton(outputId = "comp.downloadData", label = "This index"),
        downloadButton(outputId = "comp.downloadDataAll", label = "All indices")
      ),
      wellPanel(
        p(strong("Download image")),
        downloadButton("downloadImage", "This index"),
        downloadButton("downloadImageAll", "All indices"),
        sliderInput(
          inputId = "comp.plotWidth",
          label = "image width (cm)",
          min = 1,
          max = 50,
          value = 10
        ),
        sliderInput(
          inputId = "comp.plotHeight",
          label = "image height (cm)",
          min = 1,
          max = 50,
          value = 10
        )
      )
    ),
    column(
      10,
      htmlOutput("comp.analysisID"),
      uiOutput("comp.plotIndex")
    )
  )
)
