library(dplyr)

read_Data <- function(data,
                      metadata_file,
                      name,
                      sorting){

  dat <- Seurat::Read10X_h5(data)

  seurat <- CreateSeuratObject(counts = dat, project = name)
  sce <- as.SingleCellExperiment(seurat)

  metadata <- read.delim(metadata_file)
  # add the metadata to the sce object
  colData(sce) <- cbind(colData(sce),metadata)

  sce$UMAP_1 <- NULL
  sce$UMAP_2 <- NULL

  UMAP_dat <- metadata[,c("UMAP_1","UMAP_2")]
  rownames(UMAP_dat) <- metadata$Cell

  reducedDim(sce, "UMAP",) <- UMAP_dat

  targets <- rownames(sce)[grepl("CCL2$|CCL4$|CCL8|CCL18|CCL19|CCL22|CXCL8|CXCL9|CXCL10|CXCL12|CXCL13",rownames(sce))]

  for (i in targets) {
    colData(sce)[i] <- as.numeric(counts(sce)[i,] > 1)
  }

  chem_dat <- as.data.table(colData(sce))
  chem_dat$CellID <- sapply(chem_dat$Cell,FUN = function(x){strsplit(x,"_")[[1]][1]})

  out_dat <- chem_dat[,c("Celltype..major.lineage.", "CellID",..targets)]
  out_dat$celltype <- out_dat$Celltype..major.lineage.
  out_dat$Celltype..major.lineage. <- NULL
  # in some of the dataset there are cell types which we will merge:
  # CD8Tex and CD8T cells will be named CD8+ T cell
  out_dat[which(out_dat$celltype == "CD8T"),]$celltype <- "CD8+ T cell"
  out_dat[which(out_dat$celltype == "CD8Tex"),]$celltype <- "CD8+ T cell"
  # CD4Tconv and Treg will be named CD8- T cell
  out_dat[which(out_dat$celltype == "CD4Tconv"),]$celltype <- "CD8- T cell"
  out_dat[which(out_dat$celltype == "Treg"),]$celltype <- "CD8- T cell"

  out_dat$sorting <- sorting
  out_dat$dataset <- name

  out <- out_dat %>%
    group_by(celltype,dataset,.drop = FALSE) %>%
    add_count(name = "total_celltype_count") %>%
    ungroup() %>%
    pivot_longer(cols = targets,names_to = "chemokine") %>%
    group_by(chemokine,.drop = FALSE) %>%
    mutate(total_chem_count = sum(value)) %>%
    ungroup() %>%
    group_by(celltype,chemokine,dataset,.drop = FALSE) %>%
    mutate(celltype_chemokine_sum = sum(value)) %>%
    dplyr::select(celltype,chemokine,celltype_chemokine_sum,total_chem_count,total_celltype_count,dataset,sorting) %>%
    distinct() %>%
    mutate(frac_of_chemokine_pos = celltype_chemokine_sum/total_chem_count,
           frac_of_celltype = celltype_chemokine_sum/total_celltype_count) %>%
    ungroup()

  return(out)

}
