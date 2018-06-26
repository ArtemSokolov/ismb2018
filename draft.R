## Draft of DGE results plot
##
## by Artem Sokolov

library( tidyverse )
library( ggforce )
library( ggrepel )

etxt <- function(s) {element_text( size = s, face="bold")}

dgeres <- function()
{
  
  RR <- read_csv( "data/dge-res.csv.gz", col_types=cols()) %>% mutate(zoom=FALSE)
  LL <- RR %>% filter(Task == "AC") %>% mutate(zoom=TRUE)
  
  ggplot( RR, aes( x = Nienke, y = DGE, col=Task ) ) + theme_bw() +
    geom_point( size = 2 ) + geom_abline( slope = 1, lty="dashed", lwd=1.2, color="#999999" ) +
    geom_point( data=LL, aes(size=Size), alpha=0.7 ) +
    xlab( "AUC based on mined sets" ) + ylab( "AUC based on DGE sets" ) +
    scale_size_continuous( range = c(1,5), breaks = c(10, 25, 50, 100, 200 ), name="Gene Set Size" ) +
    theme( aspect.ratio = 1, strip.text=etxt(12),
           legend.title = etxt(14), legend.text = etxt(12),
           axis.title = etxt(14), axis.text = etxt(12),
           legend.background = element_rect(fill="transparent") ) +
    facet_zoom(y = Task == "AC", zoom.data=zoom) +
    geom_text_repel( data=LL, aes(label=Drug), color = "Black", fontface="bold", size=4 )
}

main <- function()
{
  gg1 <- dgeres() + guides(size=FALSE) + theme( legend.position = c(0.95, 0.15) )
  gg2 <- dgeres() + guides(color=FALSE)  + theme( legend.position = c(0.075, 0.8) )
  
  lg <- gtable_filter( ggplotGrob(gg2), "guide-box" )$grobs[[1]]
  gg <- ggplotGrob(gg1) %>% gtable_add_grob(lg, 7, 5, 7, 9)
  
  grid.newpage()
  grid.draw(gg)
}