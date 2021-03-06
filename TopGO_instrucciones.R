##El archivo de referencia debe tener en una columna los ID y en otra los GO correspondientes separados por comas
##Hice la prueba con IDs repetidos y los GO diferentes para cada uno y funciona igual

##setwd("/media/sf_Compartida/Frutilla_GO/Intento_GO_R")
library("topGO")

##cargo el archivo de referencia
geneID2GO <- readMappings(file = "Genome_with_GO_short.tab")  
##creo "geneUniverse" con las referencias cargadas
geneUniverse <- names(geneID2GO) 
##El archivo que quiero analizar debe tener 2 columnas: ID y pvalue o log2FC
genesOfInterest <- read.table("Green.txt",header=FALSE)
genesOfInterest <- as.character(genesOfInterest$V1) 
##Ahora tengo que indicarle a topGO que busque los ID de un vector en el otro, es decir, que genes dentro del "universo" me interesan
geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
names(geneList) <- geneUniverse

##Hay que armar un objeto del tipo "TopGOdata" que contenga los genes de interes, 
##las anotaciones GO y la jerarquia GO (esto ultimo lo trae topGO en el paquete y se actualizan en conjunto)

myGOdata <- new("topGOdata", description="My project", ontology="BP", allGenes=geneList,  annot = annFUN.gene2GO, gene2GO = geneID2GO) 
##Ontology hay que cambiarlo segun cual de las 3 quiero analizar (BP, MF o CC)
##en description puedo poner lo que quiera para describir el trabajo
##allGenes tiene que tener todos los genes del "universo" y cuales de ellos son de interes para el analisis
##'annot'=annFUN.gene2GO indica que le paso una lista de anotaciones de IDs a GOs, y que se encuentra en el objeto geneID2GO
##Argumento opcional: 'nodeSize'. Sirve para eliminar genes que aparezcan menos de X veces. 
##nodeSize = 10 elimina aquellos GOterms presentes en menos de 10 genes anotados

##para ver un resumen de lo que se hizo hasta ahora:
myGOdata 
##TopGO hace una lista con genes "de interes" dentro de los que le pedimos que analice, comparando los 2 archivos y el tipo de
##ontologia que seleccionamos.

##para poder acceder a la lista de genes de interes:
sg <- sigGenes(myGOdata)
str(sg)
numSigGenes(myGOdata) 

##Test de Fisher:
resultFisher <- runTest(myGOdata, algorithm="classic", statistic="fisher")
##algorithm="classic" implica que no se va a tener en cuenta la jerarquia de los genes, entonces cada GO se testea de forma independiente
##Si quisiera considerar la jerarquia, reemplazo por algorithm='weight01'.

##Para obtener un resumen del test de Fisher:
resultFisher

##en este caso no se corrigen los p-value para testeo multiple, pero no se si eso es necesario

##se puede hacer una lista del top 10 de resultados significativos
allRes <- GenTable(myGOdata, classicFisher = resultFisher, orderBy = "resultFisher", ranksOf = "classicFisher", topNodes = 10)

##Se puede ver la posicion de los terminos GO significativos dentro de la jerarquia GO:
showSigOfNodes(myGOdata, score(resultFisher), firstSigNodes = 5, useInfo ='all')
##Puedo guardar en formato pdf el grafico. Los GO terms significativos se muestran en rectangulos. Los mas significativos son rojos
##y los menos significativos, amarillos
printGraph(myGOdata, resultFisher, firstSigNodes = 5, fn.prefix = "tGO", useInfo = "all", pdfSW = TRUE)



##Si por ejemplo quiero ver que genes tienen un GO especifico puedo hacer algo asi:

##myterms = c("GO:0006807", "GO:0009056", "GO:1901564")
##mygenes <- genesInTerm(myGOdata, myterms)
##for (i in 1:length(myterms))
##{
##    myterm <- myterms[i]
##    mygenesforterm <- mygenes[myterm][[1]]
##    mygenesforterm <- paste(mygenesforterm, collapse=',')
##    print(paste("Term",myterm,"genes:",mygenesforterm))
##}





##PLOT que adapte de una pregunta del foro biostars, donde enrichment score es el -log base 10 del p-value del enrichment


goEnrichment <- GenTable(myGOdata, KS=resultFisher, orderBy="KS", topNodes=20)
goEnrichment <- goEnrichment[goEnrichment$KS<0.05,]
goEnrichment <- goEnrichment[,c("GO.ID","Term","KS")]
goEnrichment$Term <- gsub(" [a-z]*\\.\\.\\.$", "", goEnrichment$Term)
goEnrichment$Term <- gsub("\\.\\.\\.$", "", goEnrichment$Term)
goEnrichment$Term <- paste(goEnrichment$GO.ID, goEnrichment$Term, sep=", ")
goEnrichment$Term <- factor(goEnrichment$Term, levels=rev(goEnrichment$Term))
goEnrichment$KS <- as.numeric(goEnrichment$KS)

require(ggplot2)
ggplot(goEnrichment, aes(x=Term, y=-log10(KS))) +
     stat_summary(geom = "bar", fun.y = mean, position = "dodge") +
     xlab("Biological process") +
     ylab("Enrichment") +
     ggtitle("Title") +
     scale_y_continuous(breaks = round(seq(0, max(-log10(goEnrichment$KS)), by = 2), 1)) +
     theme_bw(base_size=18) +
     theme(
         legend.position='none',
         legend.background=element_rect(),
         plot.title=element_text(angle=0, size=16, face="bold", vjust=1),
         axis.text.x=element_text(angle=0, size=10, face="bold", hjust=1.10),
         axis.text.y=element_text(angle=0, size=10, face="bold", vjust=0.5),
         axis.title=element_text(size=16, face="bold"),
         legend.key=element_blank(),     #removes the border
         legend.key.size=unit(1, "cm"),      #Sets overall area/size of the legend
         legend.text=element_text(size=10),  #Text size
         title=element_text(size=16)) +
     guides(colour=guide_legend(override.aes=list(size=2.5))) +
     coord_flip()
