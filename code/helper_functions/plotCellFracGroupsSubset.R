# function to plot (boxplot) the fraction of each celltype for all images in an single cell experiment.
# fractions can be colored according to Image level colData in the single cell experiment

plotCellFracGroupsSubset <- function(x,CellClass,color_by, celltype_subset,cluster_col) {
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


  # create the data for plotting
  cur_df <- data.frame( "ImageNumber" = as.factor(colData(x)[,"ImageNumber"]))

  cur_df$CellClass <- as.factor(colData(x)[,CellClass])

  cur_df$color_by <- as.factor(colData(x)[,color_by])

  cur_df$cluster <- as.factor(colData(x)[,cluster_col])

  cur_df %>%
    group_by(ImageNumber) %>%
    add_count(cluster,name="n") %>%
    unique() %>%
    mutate(total = sum(n), frac = n/total) %>%
    filter(CellClass==celltype_subset) %>%
    ggplot(aes(x=cluster,y=frac,fill=color_by))+
    geom_boxplot(outlier.shape = NA,position=position_dodge(width=1)) +
    geom_jitter(position = position_jitterdodge(dodge.width = 1, jitter.width = 0.05),lwd=0.4) +
    theme_bw()+
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    ylab("Fraction of celltype per Image")
}
