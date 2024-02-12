library(recount3)
human_projects <- available_projects()
rse_jana <- create_rse( subset(human_projects, project== "SRP113338" & project_type == "data_sources"))

assay(rse_jana, "raw_counts") <- compute_read_counts(rse_jana)
#rse_jana$sra.sample_attributes[1:3]
#write.table(rse_jana$sra.sample_attributes, file=namee, row.names = TRUE)
rse_jana$sra.sample_attributes[7:8] <- "source_name;;normal liver tissue|tissue;;normal liver| NA"
rse_jana$sra.sample_attributes[9] <- "cell type;;primary hepatocytes|source_name;;primary human hepatocyte| NA"

rse_jana <- expand_sra_attributes(rse_jana)

rse_jana$sra_attribute.cell_type<- factor(rse_jana$sra_attribute.cell_type)
rse_jana$sra_attribute.day <- gsub("day", "", rse_jana$sra_attribute.day)
rse_jana$sra_attribute.day <- gsub("[^0-9.]+", "0", rse_jana$sra_attribute.day)
rse_jana$sra_attribute.day <- as.factor (rse_jana$sra_attribute.day)
rse_jana$sra_attribute.source_name<- factor(rse_jana$sra_attribute.source_name)

colData(rse_jana)[ , grepl("^sra_attribute", colnames(colData(rse_jana)))
]

summary(as.data.frame(colData(rse_jana)[
  ,
  grepl("^sra_attribute.[cell_type|day|source_name|mitorate]", colnames(colData(rse_jana)))
]))

# Evaluando el estado de mi rse
rse_jana$assigned_gene_prop <- rse_jana$recount_qc.gene_fc_count_all.assigned / rse_jana$recount_qc.gene_fc_count_all.total
summary(rse_jana$assigned_gene_prop)
# Evaluando las muestras con la variable assigned_gene_prop

hist(rse_jana$assigned_gene_prop)
table(rse_jana$assigned_gene_prop < 0.4)

#Evaluando la expresión de los genes
gene_means <- rowMeans(assay(rse_jana,"raw_counts"))
summary(gene_means)
rse_jana <- rse_jana [gene_means> 0.1, ] # Quedan 19708 genes después del filtrado
# Normalizando los datos
library("edgeR") # BiocManager::install("edgeR", update = FALSE)
dge <- DGEList(
  counts = assay(rse_jana, "raw_counts"),
  genes = rowData(rse_jana)
)
dge <- calcNormFactors(dge)
# Comparando iPSC y normal liver tissue

rse_jana$PHO <-
PHO <- colData(rse_jana)['SRR5859746', ]
NL <- colData(rse_jana)[ 7:8, ]
## Encontraremos diferencias entre muestra prenatalas vs postnatales
rse_jana$PHO
factor(ifelse(rse_gene_SRP045638$sra_attribute.age < 0, "prenatal

PHO$assigned_gene_prop <- PHO$recount_qc.gene_fc_count_all.assigned / PHO$recount_qc.gene_fc_count_all.total
PHO$assigned_gene_prop
NL$assigned_gene_prop <- NL$recount_qc.gene_fc_count_all.assigned / NL$recount_qc.gene_fc_count_all.total
NL$assigned_gene_prop

mod <- model.matrix(~ sra_attribute.cell_type + assigned_gene_prop,
data= colData(rse_jana)
)

colnames(mod)

library("limma")
vGene <- voom(dge, mod, plot = TRUE)

eb_results <- eBayes(lmFit(vGene))

de_results <- topTable(
    eb_results,
    coef = 2,
    number = nrow(rse_jana),
    sort.by = "none"
)

dim(de_results)
head(de_results)

#Heatmap
df <- as.data.frame(colData(rse_jana)[, c("sra_attribute.cell_type")])
exprs_heatmap <- vGene$E[rank(de_results$adj.P.Val) <= 50, ]

library("pheatmap")
pheatmap(
    exprs_heatmap,
    cluster_rows = TRUE,
    cluster_cols = TRUE,
    show_rownames = FALSE,
    show_colnames = FALSE,
    annotation_col = df
)
#Visualización del assay
temp <- assay(rse_jana)
temp <- as.matrix(temp)
View(temp)

volcanoplot(eb_results, coef = 2, highlight = 3, names = de_results$gene_name)

