# function to plot (boxplot) the fraction of each celltype for all images in an single cell experiment.
# fractions can be colored according to Image level colData in the single cell experiment

plotCellFracGroupsSubset <- function(x,CellClass,colour_by, celltype_subset,cluster_col) {
  # check if x is SingleCellExperiment
  .sceCheck(x)

  if (is.null(CellClass)) {
    stop("Provide Cell class from column metadata")
  }
  if (is.null(celltype_subset)) {
    stop("Provide the celltype subset of which you want to display clusters")
  }
  if (is.null(cluster_col)) {
    stop("Provide the name of the celltype cluster column from the object")
  }
  if (is.null(color_by)) {
    stop("Provide metadata entry from the colData which you want to group by")
  }


  # check if selected variables exist
  entries <- colnames(colData(x))
  if (! is.null(CellClass)) {
    if (! CellClass %in% entries) {
      stop("The entry for CellClass is not a colData slot of the object.")
    }
  }

  # check if color_by does not exceed the number of images
  if (! is.null(color_by)) {
    if (! color_by %in% entries) {
      stop("The entry for color_by is not a colData slot of the object.")
    }
    if (length(unique(colData(x)[,color_by])) > length(unique(x$ImageNumber))) {
      stop("Number of colors selected not supported")
      }
  }


  cur_df <- data.frame(ImageNumber = (colData(x)[,"ImageNumber"]))

  cur_df$split_by <- (colData(x)[,split_by])

  #cur_df$colour_by <- as.factor(colData(x)[,colour_by])

  cur_df$cluster <- (colData(x)[,celltype_cluster_col])

  cur_df <- dcast(cur_df,formula = " ImageNumber + split_by ~ cluster",fun.aggregate = length)

  cur_df <- melt(cur_df,id.vars = c("ImageNumber","split_by"))

  if(scale == "count"){
    cur_df %>%
      group_by(ImageNumber) %>%
      mutate(total = sum(value), frac = value/total) %>%
      separate(col = variable, into = c("celltype","cluster"),remove = FALSE,sep = "_") %>%
      filter(celltype == celltype_subset) %>%
      ggplot(aes(x=variable,y=frac,fill=split_by))+
      geom_boxplot(outlier.shape = NA,position=position_dodge(width=1))+
      geom_jitter(position = position_jitterdodge(dodge.width = 1, jitter.width = 0.05),lwd=0.4)+
      theme_bw()+
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      ylab("Fraction of celltype per Image")+
      scale_fill_discrete(name = colour_by)
  }

}
