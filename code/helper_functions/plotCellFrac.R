# function to plot (boxplot) the fraction of each celltype for all images in an single cell experiment.
# fractions can be colored according to Image level colData in the single cell experiment

plotCellFrac <- function(x,CellClass,color_by = "ImageNumber") {
  # check if x is SingleCellExperiment
  .sceCheck(x)

  if (is.null(CellClass)) {
    stop("Provide Cell class from column metadata")
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

  if (color_by == "ImageNumber") {
    cur_df$color_by <- NULL

    sum_df <- table(cur_df)/rowSums(table(cur_df))

    frac_df <- melt(sum_df)

    # plot the data
    ggplot(frac_df) +
      geom_boxplot(aes(x=CellClass,y=value)) +
      geom_jitter(aes(x=CellClass,y=value, color = as.factor(ImageNumber)),position = position_jitter( width = .1),lwd =1) +
      theme_bw()+
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      ylab("Fraction of celltype per Image")

  }

  else {
    cur_df$color_by <- as.factor(colData(x)[,color_by])

    sum_df <- dcast(cur_df, ImageNumber + color_by ~ CellClass, length)

    # calculate the fractions for each cell type if color_by is not given
    sum_df <- cbind(sum_df[c("ImageNumber", "color_by")],sum_df[-which(colnames(sum_df) %in% c("ImageNumber", "color_by"))]/rowSums(sum_df[-which(colnames(sum_df) %in% c("ImageNumber", "color_by"))]))

    # melt data for plotting
    frac_df <- melt(sum_df,id.vars = c("ImageNumber", "color_by"),variable.name = CellClass)

    colnames(frac_df) <- c("ImageNumber", color_by , CellClass , "value")

    # plot data
    ggplot(frac_df) +
      geom_boxplot(aes_string(x=CellClass,y="value")) +
      geom_jitter(aes_string(x=CellClass,y="value", color = color_by),position = position_jitter( width = .1),lwd =1) +
      theme_bw()+
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      ylab("Fraction of celltype per Image")

  }

}
