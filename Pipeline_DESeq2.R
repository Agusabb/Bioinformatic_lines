# Example with Green vs Red

countdata <- read.table("GreenvsRed.tab", header=TRUE, row.names=1)
countdata <- as.matrix(countdata)
head(countdata)
(condition <- factor(c(rep("Green", 2), rep("Red", 2))))
library(DESeq2)
(coldata <- data.frame(row.names=colnames(countdata), condition))
dds <- DESeqDataSetFromMatrix(countData=countdata, colData=coldata, design=~condition)
dds
dds <- DESeq(dds)
res <- results(dds)
table(res$padj<0.05)
res <- res[order(res$padj), ]
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)), by="row.names", sort=FALSE)
names(resdata)[1] <- "Gene"
head(resdata)
write.csv(resdata, file="GreenvsRed_resultados.tab")
View(resdata)
View(resdata)
table_counts_normalized <- counts(dds, normalized=TRUE)
write.table(table_counts_normalized, "Normalizadas.tab", sep="\t")
