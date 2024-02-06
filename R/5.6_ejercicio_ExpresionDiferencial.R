## Tenemos que usar gene_id y gene_name
rowRanges(rse_gene_SRP045638)

## Alternativamente, podriamos haber usado de_results
head(de_results, n = 3)

## Es la misma información
identical(rowRanges(rse_gene_SRP045638)$gene_id, de_results$gene_id)

identical(rowRanges(rse_gene_SRP045638)$gene_name, de_results$gene_name)

## Guardemos los IDs de nuestros 50 genes
nombres_originales <- rownames(exprs_heatmap)

## Con match() podemos encontrar cual es cual
rownames(exprs_heatmap) <- rowRanges(rse_gene_SRP045638)$gene_name[
  match(rownames(exprs_heatmap), rowRanges(rse_gene_SRP045638)$gene_id)
]

## Vean que tambien podriamos haber usado rank()
identical(
  which(rank(de_results$adj.P.Val) <= 50),
  match(nombres_originales, rowRanges(rse_gene_SRP045638)$gene_id)
)

## Por último podemos cambiar el valor de show_rownames de FALSE a TRUE
pheatmap(
  exprs_heatmap,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = TRUE,
  show_colnames = FALSE,
  annotation_col = df
)

## Guardar la imagen en un PDF largo para poder ver los nombres de los genes
pdf("pheatmap_con_nombres.pdf", height = 14, useDingbats = FALSE)
pheatmap(
  exprs_heatmap,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = TRUE,
  show_colnames = FALSE,
  annotation_col = df
)
dev.off()

## Versión con centering y scaling en los renglones (los genes)
pheatmap::pheatmap(
  exprs_heatmap,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = TRUE,
  show_colnames = FALSE,
  annotation_col = df,
  scale = "row"
)
## Misma versión pero ahora con ComplexHeatmap en vez del paquete pheatmap
ComplexHeatmap::pheatmap(
  exprs_heatmap,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = TRUE,
  show_colnames = FALSE,
  annotation_col = df,
  scale = "row"
)


