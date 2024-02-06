## Lets build our first SummarizedExperiment object
library("SummarizedExperiment")

## Creamos los datos para nuestro objeto de tipo SummarizedExperiment
## para 200 genes a lo largo de 6 muestras
nrows <- 200
ncols <- 6
## Números al azar de cuentas
set.seed(20210223) #Genera números aleatorios reproducibles, de manera que al ingresar la semilla "20210223" se generan los mismos números aleatorios.
counts <- matrix(runif(nrows * ncols, 1, 1e4), nrows) #Aquí se crea la variable counts, la cual es una matriz uniforme con la cantidad de columnas de las variables creadas con anterioridad
## Información de nuestros genes
rowRanges <- GRanges(
  rep(c("chr1", "chr2"), c(50, 150)), #rep para la reproducibilidad, hay 50 elementos del chr1 y 150 del chr2
  IRanges(floor(runif(200, 1e5, 1e6)), width = 100), #Se crea 200 números aleatorios del 1e5 al 1e6 con un ancho de 100 unidades y redondeados hacia abajo con floor
  strand = sample(c("+", "-"), 200, TRUE), #se piden 200 valores de strand con reposición (ej: pelotas en la bolsa)
  feature_id = sprintf("ID%03d", 1:200) # se determina el feature_id formateando el resultado con sprintf. En donde le dices que debe generar la palabra ID seguido de 3 digitos (%03d) y el vector debe tener 200 elementos
)

#Se definen las características de los genes (o las filas) de la matrix
names(rowRanges) <- paste0("gene_", seq_len(length(rowRanges)))
## Información de nuestras muestras
colData <- DataFrame(
  Treatment = rep(c("ChIP", "Input"), 3),
  row.names = LETTERS[1:6] #nombre de las muestras
)
## Juntamos ahora toda la información en un solo objeto de R
rse <- SummarizedExperiment(
  assays = SimpleList(counts = counts),
  rowRanges = rowRanges,
  colData = colData
)

## Información de los genes en un objeto de Bioconductor
rowRanges(rse)

## Tabla con información de los genes
rowData(rse) # es idéntico a 'mcols(rowRanges(rse))'

## Explora el objeto rse de forma interactiva
library("iSEE")
iSEE::iSEE(rse)

## Descarguemos unos datos de spatialLIBD
sce_layer <- spatialLIBD::fetch_data("sce_layer")
## Revisemos el tamaño de este objeto
lobstr::obj_size(sce_layer) #calcula el tamaño en bytes del objeto en memoria
iSEE::iSEE(sce_layer) ### Abriendo con ISEE el objeto de tipo SummerizeExperiments

