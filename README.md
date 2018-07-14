# ismb2018: Poster I presented at [ISMB2018](https://www.iscb.org/ismb2018)

To generate the .html and .pdf renders, run `Rscript render.R` in the main directory. The final .html render can be viewed at https://artemsokolov.github.io/ismb2018/. The final .pdf is available as [ismb2018.pdf](https://github.com/ArtemSokolov/ismb2018/blob/master/ismb2018.pdf).

## Dependencies

### .html render
The .html render is performed [R Markdown](https://rmarkdown.rstudio.com) and requires the following R packages: `flexdashboard`, `tidyverse`, `kableExtra`, `formattable`, `ggrepel`, `ggridges`, `ggforce`, `gtable`, and of course `rmarkdown`. Most of these can be installed directly from [CRAN](https://cran.r-project.org/) via `install.packages()`. However, certain features might require more recent package versions available on GitHub. An example of this is the zoom panel in the mined-vs-DGE plot; to get it to render properly, you will likely need to install `ggforce` from https://github.com/thomasp85/ggforce.

### .pdf render
Rendering to .pdf is done by [Puppeteer](https://developers.google.com/web/tools/puppeteer/), a node library for headless Chrome. Most of the guides for Rmarkdown-based posters I looked at use PhantomJS, but I've had many problems with PhantomJS output not matching what I was viewing in my Chrome browser while building the poster. To avoid headaches, I switched to Puppeteer.

Unfortunately, [knitr](https://yihui.name/knitr/) (the engine behind R markdown) inserts a bunch of `!important` CSS tags that [override custom color styles](https://stackoverflow.com/questions/50971866/puppeteer-doesnt-respect-colors-when-exporting-rmarkdown-render-to-pdf). A colleague of mine came up with a [vim](https://www.vim.org/) macro that removes all these tags. The macro is executed by `render.R` before running Puppeteer and requires that vim is installed on your system.
