#' helper function to generate boxplot split_by colData.
#' @param sce SingleCellExperiment object
#' @param cell_class colData entry with celltype information stored
#' @param celltype_subset subset entry of `cell_class` for plotting
#' @param split_by split plots by variable

#' @return ggplot objects
#' @export

plotCellFracGroupsSubset <- function(sce,
                                     CellClass,
                                     split_by,
                                     celltype_subset,
                                     cluster_col) {
  # check if x is SingleCellExperiment
  .sceCheck(sce)

  if (is.null(CellClass)) {
    stop("Provide Cell class from column metadata")
  }
  if (is.null(celltype_subset)) {
    stop("Provide the celltype subset of which you want to display clusters")
  }
  if (is.null(cluster_col)) {
    stop("Provide the name of the celltype cluster column from the object")
  }
  if (is.null(split_by)) {
    stop("Provide the name of the celltype cluster column from the object")
  }



  # check if selected variables exist
  entries <- colnames(colData(sce))
  if (! is.null(CellClass)) {
    if (! CellClass %in% entries) {
      stop("The entry for CellClass is not a colData slot of the object.")
    }
  }
  if (! is.null(split_by)) {
    if (! split_by %in% entries) {
      stop("The entry for spllit_by is not a colData slot of the object.")
    }
  }




  cur_df <- data.frame(ImageNumber = (colData(sce)[,"ImageNumber"]))

  cur_df$split_by <- (colData(sce)[,split_by])

  #cur_df$colour_by <- as.factor(colData(sce)[,colour_by])

  cur_df$cluster <- (colData(sce)[,cluster_col])

  cur_df <- reshape2::dcast(cur_df,formula = " ImageNumber + split_by ~ cluster",fun.aggregate = length)

  cur_df <- reshape2::melt(cur_df,id.vars = c("ImageNumber","split_by"))

  cur_df <- cur_df %>%
    group_by(ImageNumber) %>%
    mutate(total = sum(value), frac = value/total) %>%
    separate(col = variable, into = c("celltype","cluster"),remove = FALSE,sep = "_")

  if(! celltype_subset %in% cur_df$celltype){
    stop("provide a celltype subset which is a valid split of the clusters")
  }

    cur_df %>%
      group_by(ImageNumber) %>%
      filter(celltype == celltype_subset) %>%
      ggplot(aes(x=variable,y=frac,fill=split_by))+
      geom_boxplot(outlier.shape = NA,position=position_dodge(width=1))+
      geom_jitter(position = position_jitterdodge(dodge.width = 1, jitter.width = 0.05),lwd=0.4)+
      theme_bw()+
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      ylab("Fraction of celltype per Image")+
      scale_fill_discrete(name = split_by)

}
