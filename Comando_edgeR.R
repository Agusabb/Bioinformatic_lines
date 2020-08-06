library(edgeR)
#Creación de la variable data que contiene al Archivo input
data <- as.matrix(read.table('PKvsRR.tab'))

#Este vector forma grupos según la cantidad de muestras en la library de origen
g <- c(0,0,1,1)

#Preparo la lista
d <- DGEList(counts=data,group=g)

#Normalización
d <- calcNormFactors(d)

#Estimación de la dispersión
d <- estimateCommonDisp(d)
d <- estimateTagwiseDisp(d)

#Evaluación de la diferencia de medias entre counts con distribución binomial negativa
de.com <- exactTest(d)

#Generación de los resultados
results <- topTags(de.com,n = length(data[,1]))

#Creación del archivo Output con los resultados
write.table(as.matrix(results$table),file="PKvsRR_phasis_resultado.tab",sep="\t")

#Creación del archivo output con las libraries normalizadas (Counts per million)
write.table(d$pseudo.counts, file="PKvsRR_Normalizadas.tab", row.names = TRUE, col.names = TRUE, sep = "\t" )
