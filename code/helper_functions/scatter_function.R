
# scatterplot function to generate a scatterplot for two specified markers
scatter_x_y <- function(input_data,x,y,imagenumber,xlim,ylim, select_assay ="asinh"){
  if (is.null(select_assay)) {
    heatscatter(as.vector(t(assay(input_data[rownames(input_data) == x,input_data$ImageNumber == imagenumber],"asinh"))),as.vector(t(assay(input_data[rownames(input_data) == y,input_data$ImageNumber == imagenumber],"asinh"))),
                xlab = paste("Imagenumber:",imagenumber , "Marker:" , x, sep = " "),
                ylab = y,
                xlim = xlim,
                ylim = ylim,
                main=(paste("Image number:", imagenumber,sep =" ")),
                cor = TRUE,
                method = "spearman")
  } else {heatscatter(as.vector(t(assay(input_data[rownames(input_data) == x,input_data$ImageNumber == imagenumber],select_assay))),as.vector(t(assay(input_data[rownames(input_data) == y,input_data$ImageNumber == imagenumber],select_assay))),
                        xlab = paste("Imagenumber:",imagenumber , "Marker:" , x, sep = " "),
                        ylab = y,
                        xlim = xlim,
                        ylim = ylim,
                        main=(paste("Image number:", imagenumber,sep =" ")),
                        cor = TRUE,
                        method = "spearman")
      }

}
