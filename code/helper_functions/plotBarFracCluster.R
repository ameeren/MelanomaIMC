# this function generates a barplot from a sce object which can be celltype_subsetted to a specific celltype_subset. the fraction is then displayed as a fraction of all cells and not as a fraction of the celltype_subset

plotBarFracCluster <- function(x, colour_by = NULL, split_by = NULL, celltype_subset = NULL, celltype_cluster_col=NULL, scale=c("percent","count")){

  # Check if x is SingleCellExpriment
  .sceCheck(x)

  scale <- match.arg(scale)
  # Check if selected variable exists
  entries <- colnames(colData(x))

  if(is.null(colour_by)){
    stop("provide entry to color plot by from object")
  }

  if(is.null(split_by)){
    stop("provide entry to split plot by from object")
  }

  if(!is.null(colour_by)){
    if(!(colour_by %in% entries)){
      stop("The entry for colour_by is not a colData slot of the object.")
    }
  }
  if(!is.null(split_by)){
    if(!(split_by %in% entries)){
      stop("The entry for split_by is not a colData slot of the object.")
    }
  }

  cur_df <- data.frame(split_by = as.factor(colData(x)[,split_by]))

  cur_df$colour_by <- as.factor(colData(x)[,colour_by])

  cur_df <- reshape2::dcast(cur_df,formula = " split_by ~ colour_by",fun.aggregate = length)

  cur_df <- melt(cur_df)

  if(is.null(celltype_subset)){
    if(scale=="percent"){
      cur_df %>%
        group_by(split_by) %>%
        mutate(total = sum(value),frac= value/total) %>%
        ggplot(aes(x=split_by,y=frac,fill=variable))+
        geom_bar(stat="identity")+
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              axis.title.x = element_blank(),
              panel.background = element_blank(),
              panel.grid.minor=element_blank(),
              panel.grid.major.x=element_blank(),
              panel.grid.major.y=element_line(color="grey", size=.3)) +
        ylab("cell fraction per group") + scale_fill_discrete(name = colour_by)
    }
    else{
      if(scale == "count"){
        cur_df %>%
          group_by(split_by) %>%
          ggplot(aes(x=split_by,y=value,fill=variable))+
          geom_bar(stat="identity")+
          theme(axis.text.x = element_text(angle = 45, hjust = 1),
                axis.title.x = element_blank(),
                panel.background = element_blank(),
                panel.grid.minor=element_blank(),
                panel.grid.major.x=element_blank(),
                panel.grid.major.y=element_line(color="grey", size=.3)) +
          ylab("Cell count") + scale_fill_discrete(name = colour_by)
      }
    }
  }
  else{
    if (!is.null(celltype_subset)) {
      if (is.null(celltype_cluster_col)) {
        stop("provide the name of the colData entry with celltype clusters")
      }
      if(!is.null(celltype_cluster_col)){
        if(!(celltype_cluster_col %in% entries)){
          stop("The entry for celltype_cluster_col is not a colData slot of the object.")
        }
      }

      cur_df <- data.frame(split_by = as.factor(colData(x)[,split_by]))

      #cur_df$colour_by <- as.factor(colData(x)[,colour_by])

      cur_df$cluster <- as.factor(colData(x)[,celltype_cluster_col])

      cur_df <- reshape2::dcast(cur_df,formula = " split_by ~ cluster",fun.aggregate = length)

      cur_df <- melt(cur_df,id.vars = c("split_by"))

      if(scale == "count"){
        cur_df %>%
          group_by(split_by) %>%
          mutate(total = sum(value), frac = value/total) %>%
          separate(col = variable, into = c("celltype","cluster"),remove = FALSE,sep = "_") %>%
          filter(celltype == celltype_subset) %>%
          ggplot(aes(x=split_by,y=value,fill=variable))+
          geom_bar(stat="identity")+
          theme(axis.text.x = element_text(angle = 45, hjust = 1),
                axis.title.x = element_blank(),
                panel.background = element_blank(),
                panel.grid.minor=element_blank(),
                panel.grid.major.x=element_blank(),
                panel.grid.major.y=element_line(color="grey", size=.3)) +
          ylab("Cell count") + scale_fill_discrete(name = colour_by)
      } else {
        if(scale == "percent"){
          cur_df %>%
            group_by(split_by) %>%
            mutate(total = sum(value), frac = value/total) %>%
            separate(col = variable, into = c("celltype","cluster"),remove = FALSE,sep = "_") %>%
            filter(celltype == celltype_subset) %>%
            ggplot(aes(x=split_by,y=frac,fill=variable))+
            geom_bar(stat="identity")+
            theme(axis.text.x = element_text(angle = 45, hjust = 1),
                  axis.title.x = element_blank(),
                  panel.background = element_blank(),
                  panel.grid.minor=element_blank(),
                  panel.grid.major.x=element_blank(),
                  panel.grid.major.y=element_line(color="grey", size=.3)) +
            ylab("Cell fraction of all cells per group") + scale_fill_discrete(name = colour_by)
        }

      }
    }
  }
}



