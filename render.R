# Set parameters
fnHTML <- "output/ismb2018.html"

# Render document
rmarkdown::render(
  input = "ismb2018.Rmd",
  output_file = fnHTML
)

# Render preview
## webshot::webshot(
##   url = fnHTML,
##   file = "output/ismb2018.png",
##   zoom = 1,
##   vwidth = 5760,
##   vheight = 3600
## )

# End of script
