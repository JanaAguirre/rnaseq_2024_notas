library("sessioninfo") ##Da información sobre la sesión de R
library("here") ## Permite referenciar archivos que son relativas al directorio del proyecto
library("ggplot2") ## Esta librería permite hacer gráficos de alta calidad

## Hello world
print("Soy Leo")

## Directorios
dir_plots <- here::here("figuras")
dir_rdata <- here::here("processed-data") ## Las dos variables que se crearon contienen la ruta al nuevo directorio "figuras" y "processed-data"

## Crear directorio para las figuras y archivos
dir.create(dir_plots, showWarnings = FALSE) ## Se crean directorios en la dirección de las variables antes descritas.
dir.create(dir_rdata, showWarnings = FALSE) ## Yo le pondría showwarings= TRUE para poder detectar algún error

## Hacer una imagen de ejemplo
pdf(file.path(dir_plots, "mtcars_gear_vs_mpg.pdf"),
    useDingbats = FALSE
)
ggplot(mtcars, aes(group = gear, y = mpg)) +
  geom_boxplot()
dev.off()

## Para reproducir mi código
options(width = 120)
sessioninfo::session_info()
