rmarkdown::render(
  input = "ismb2018.Rmd",
  output_file = "docs/index.html"
)

## Remove all !important tags from the output .html
setwd("docs")
system('echo "%s/%21important// | w!" | vim -e index.html')
setwd("..")

## Render the .html to .pdf using headless Chrome
system("node render.js")
