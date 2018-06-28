## Figures for the poster
##
## by Artem Sokolov

## Produces bold element_text of desired size
etxt <- function(s, ...) element_text(size=s, face="bold", ...)

## A diagram showing the interplay between the three R56 aims
figJointEffort <- function() DiagrammeR::grViz('
digraph G {
graph [ranksep="0.2" compound=true]
node [style="rounded,filled", fontname="Sans-Serif", shape=box]
edge [arrowhead="none"]

subgraph cluster_0 {
graph [margin=2, style=invisible]
A [label="EHR", fillcolor="#F7F0C2"]
}

subgraph cluster_1 {
graph [margin=2, style=invisible]
B [label="Omics", fillcolor="#BBD1E3"]
}

subgraph cluster_2 {
graph [margin=2, style=invisible]
C [label=<<i>In vitro</i>>, fillcolor="#FFC6BC"]
}

A -> B [ltail=cluster_0, lhead=cluster_1]
A -> C [ltail=cluster_0, lhead=cluster_2]
B -> C [ltail=cluster_1, lhead=cluster_2]
C -> B [style=invisible]
}')

## Function creates and returns a table containing ROSMAP statistics
ROSMAP_stats <- function()
{
    pfx <- '![](img/Tau'
    sfx <- '.png){width=100%}'
    tauPal <- c("A","B","C") %>% setNames( str_c(pfx, ., sfx), . )
    data_frame( Braak = 0:6, `#Samples` = as.integer(c(7,51,54,176,210,133,7)),
               Category = c("A","A","A","B","B","C","C") ) %>%
        mutate( Pathology = tauPal[Category] )
}

## Figure displays performance of background gene sets on ROSMAP
figBkPerf <- function()
{
    taskMap <- c( "AB"="A-vs-B ", "AC"="A-vs-C ", "BC"="B-vs-C ", "Ordinal"="Ordinal" )
    BK <- read_csv( "data/bk-perf.csv.gz" ) %>% mutate( Task = taskMap[Task] )
    ggplot( BK, aes(x=Size, y=AUC, color=Task) ) + theme_bw() +
        geom_smooth( lwd=1.5, span=2 ) + xlab( "Random Set Size" ) +
        ylim( c(0.5, 0.75) ) +
        scale_color_manual( values=c("tomato","steelblue","darkolivegreen","#6B2D5C")) +
        guides( color=guide_legend(override.aes=list(fill="white")) ) +
        theme( axis.text = etxt(12), axis.title = etxt(14), strip.text = etxt(14),
              legend.text = etxt(12), legend.title = element_blank(),
              legend.direction = "horizontal", legend.position = c(0.5,0.9),
              legend.background = element_rect(fill="transparent") )
}

## Figure shows the intuition of comparing gene set of interest against background performance
figGSBK <- function()
{
    GSBK_lbl <- data_frame( AUC = c(0.69, 0.55, 0.67), y = c(0.3, 2, 5),
                           lbl=c("p-value", "Random", "Gene Set\nOf Interest") )
    read_csv( "data/gs-bk.csv" ) %>%
        ggplot( aes(x=AUC) ) + theme_bw() + xlim( c(0.4,0.75) ) + 
        geom_density( fill="steelblue", alpha=0.3, lwd=1.5 ) + xlab("Performance") +
        geom_vline( xintercept = 0.67, color="tomato", lwd=1.5 ) +
        geom_text_repel( data=GSBK_lbl, aes(y=y, label=lbl), size=5, fontface="bold",
                        nudge_y = c(1.5,2.5,5), nudge_x = c(1, -0.1, 1),
                        color=c("black","black","tomato") ) +
        theme( axis.title.x = etxt(14), axis.title.y = element_blank(),
              axis.text = element_blank(), axis.ticks = element_blank(),
              panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.border = element_rect(colour="black", fill=NA, size=2) )
}

## Figure shows top drug candidates
figTopCand <- function()
{
    taskMap <- c( "AB"="A-vs-B", "AC"="A-vs-C", "BC"="B-vs-C", "Ordinal"="Ordinal" )
    X.cand <- read_csv( "data/cand-x.csv.gz", col_types = cols() ) %>% arrange(AUC) %>%
        mutate( Name = factor(Name,Name), hzj = as.integer(Name=="SB202190") ) %>%
        mutate( Lbl = ifelse(Name=="SB202190", str_c(Lbl, " "), str_c(" ", Lbl)) ) %>%
        mutate( Task = taskMap[Task] )
    BK.cand <- read_csv( "data/cand-bk.csv.gz", col_types = cols() ) %>%
        mutate( Drug = factor(Drug, levels(X.cand$Name)), Task = taskMap[Task] )
    ggplot(BK.cand, aes(x=AUC, y=Drug, fill=Task)) + 
        theme_ridges(center_axis_labels=TRUE) +
        geom_density_ridges2(scale=1.2, size=1, alpha=0.5) +
        geom_segment( aes(x=AUC, xend=AUC, y=as.numeric(Name), yend=as.numeric(Name)+0.9 ),
                     data=X.cand, color="red", lwd=2 ) +
        geom_text( data=X.cand, aes(x=AUC, y=as.numeric(Name) + 0.5, label=Lbl, hjust=hzj),
                  fontface="bold", size=4 ) +
        scale_fill_manual( values=c("tomato","darkolivegreen","#6b2d5c")) +
        scale_y_discrete(expand=c(0,0.95)) +
        theme( axis.text = etxt(12), axis.title = etxt(14),
              legend.position=c(0.96,0.22), legend.justification =c(1,0.5),
              legend.title=element_text(face="bold"), legend.text=element_text(face="bold"),
              legend.box.background = element_rect(color="gray40") )
}

## Figure shows a comparison of DGE-based gene sets against the original (mined) sets
figDGEres <- function()
{
    DGEres <- function()
    {
        taskMap <- c( "AB"="A-vs-B", "AC"="A-vs-C", "BC"="B-vs-C", "Ordinal"="Ordinal" )
        RR <- read_csv( "data/dge-res.csv.gz", col_types=cols()) %>%
            mutate( Task = taskMap[Task], zoom=FALSE )
        LL <- RR %>% filter(Task == "A-vs-C") %>% mutate(zoom=TRUE)
  
        ggplot( RR, aes( x = Nienke, y = DGE, col=Task ) ) + theme_bw() +
            geom_point( size = 2 ) + geom_abline( slope = 1, lty="dashed", lwd=1.2, color="#999999" ) +
            geom_point( data=LL, aes(size=Size), alpha=0.7 ) +
            xlab( "AUC based on mined sets" ) + ylab( "AUC based on DGE sets" ) +
            scale_color_manual( values=c("tomato","steelblue","darkolivegreen","#6B2D5C")) +
            scale_size_continuous( range=c(1,5), breaks=c(10, 25, 50, 100, 200),
                                  name="Gene Set Size" ) +
            theme( aspect.ratio = 1, strip.text=etxt(12),
                  legend.title = etxt(13), legend.text = etxt(11),
                  axis.title = etxt(14), axis.text = etxt(12),
                  legend.background = element_rect(fill="white", color="#999999") ) +
            facet_zoom(y = Task == "A-vs-C", zoom.data=zoom) +
            geom_text_repel( data=LL, aes(label=Drug), color = "Black", fontface="bold", size=4 )
    }

    ## Consider two versions, one for each of the legends
    gg1 <- DGEres() + guides(size=FALSE) + theme( legend.position = c(0.935, 0.16) )
    gg2 <- DGEres() + guides(color=FALSE)  + theme( legend.position = c(0.1, 0.8) )

    ## Transfer both legends into a common plot
    lg <- gtable_filter( ggplotGrob(gg2), "guide-box" )$grobs[[1]]
    gg <- ggplotGrob(gg1) %>% gtable_add_grob(lg, 7, 5, 7, 9)
  
    grid.newpage()
    grid.draw(gg)
}

