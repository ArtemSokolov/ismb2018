## Draft of DGE results plot
##
## by Artem Sokolov

library( tidyverse )
library( ggforce )
library( ggrepel )

main <- function()
{
  etxt <- function(s) {element_text( size = s, face="bold")}
  
  RR <- read_csv( "data/dge-res.csv.gz") %>% mutate( zoom=ifelse(Task=="AC", NA, FALSE))
  LL <- RR %>% filter(Task == "AC") %>% mutate(zoom=TRUE)
  
  ggplot( RR, aes( x = Nienke, y = DGE, col=Task ) ) + theme_bw() +
    geom_point( size = 2 ) + geom_abline( slope = 1, lty="dashed", lwd=1.2 ) +
    xlab( "AUC based on mined sets" ) + ylab( "AUC based on DGE sets" ) +
    theme( aspect.ratio = 1, strip.text=etxt(12),
           legend.title = element_blank(), legend.text = etxt(12),
           axis.title = etxt(14), axis.text = etxt(12),
           legend.position = c(0.05,0.85), 
           legend.background = element_rect(fill="transparent") ) +
    facet_zoom(y = Task == "AC", zoom.data=zoom) +
    geom_text_repel( data=LL, aes(label=Drug), color = "Black", fontface="bold")
}
