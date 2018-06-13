# Set parameters
fnHTML <- "output/ismb2018.html"

# Render document
rmarkdown::render(
  input = "ismb2018.Rmd",
  output_file = fnHTML
)

# Render preview
webshot::webshot(
  url = fnHTML,
  file = "output/ismb2018.png",
  vwidth = 4500,
  vheight = 3000,
  zoom = 3
)

# End of script