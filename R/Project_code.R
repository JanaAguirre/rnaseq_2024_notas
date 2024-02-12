library(recount3)
human_projects <- available_projects()
rse_jana <- create_rse( subset(human_projects, project== "SRP113338" & project_type == "data_sources"))
assay(rse_jana, "raw_counts") <- compute_read_counts(rse_jana)
rse_jana$sra.sample_attributes[1:3]
write.table(rse_jana$sra.sample_attributes, file=namee, row.names = TRUE)
rse_jana$sra.sample_attributes[7:8] <- "source_name;;normal liver tissue|tissue;;normal liver| NA"
rse_jana$sra.sample_attributes[9] <- "cell type;;primary hepatocytes|source_name;;primary human hepatocyte| NA"
rse_jana <- expand_sra_attributes(rse_jana)

colData(rse_jana)[
  ,
  grepl("^sra.sample_attributes", colnames(colData(rse_jana)))
]

rse_jana$sra_attribute.cell_type<- factor(rse_jana$sra_attribute.cell_type)
rse_jana$sra_attribute.day <- gsub("day", "", rse_jana$sra_attribute.day)
rse_jana$sra_attribute.day <- gsub("[^0-9.]+", "0", rse_jana$sra_attribute.day)
rse_jana$sra_attribute.day <- as.factor (rse_jana$sra_attribute.day)
rse_jana$sra_attribute.source_name<- factor(rse_jana$sra_attribute.source_name)

summary(as.data.frame(colData(rse_jana)[
  ,
  grepl("^sra_attribute.[cell_type|day|source_name]", colnames(colData(rse_jana)))
]))

