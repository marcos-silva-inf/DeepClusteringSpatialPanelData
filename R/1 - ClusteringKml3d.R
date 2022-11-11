################################################################
#
#   Clustering normalized min-max transformed raw data
#   Author: Marcos Silva marcossilva.inf@gmail.com
#   date: 11-11-2022
#
################################################################




################################################################
#
#   Working dir
#
################################################################
setwd("D:/2022/PUBLICACOES/PAPER2023/R")


################################################################
#
#   Spatial panel data
#
################################################################
data <- read.csv(file="../data/raw-data-min-max-normalized", header=TRUE, sep=",")

data["X"] <- NULL

var.clust <- c(3:198)

data.clust <- data
data.clust <- replace(data.clust,is.na(data.clust),0)



library(reshape2)
melt.data.clust <- melt(data, id = c("CODIBGE", "Ano"), measure = var.clust)
m.data.clust <- acast(melt.data.clust, CODIBGE ~ Ano ~ variable)

ids <- unique(data.clust$CODIBGE)

library(kml3d)
data.3d <- cld3d(
  traj=m.data.clust,
  idAll=ids,
  time=1999:2018,
  varNames=colnames(data.clust[var.clust]))



kml3d(data.3d, nbClusters = 8, nbRedrawing = 20  )

numC8 <- getClusters(data.3d, 8)


BR.clusters <- data.frame(ids,numC8)

data.clust <- merge(data.clust, BR.clusters, by.x = "CODIBGE", by.y = "ids", all.x = TRUE )

write.csv(data.clust, file = "../csv/kmeans_clustering.csv", row.names = FALSE) 


################################################################
#
#   Salvando os dados na base geográfica
#   
#
################################################################
library(rgdal)
#Lendo o shapefile da area de estudo shapefile
area.estudo <- readOGR("../shapefile", "BR_Municipios_2020" )

#Merge
area.estudo@data <- merge(area.estudo@data, BR.clusters, by.x = "CD_MUN", by.y = "ids", all.x = TRUE )

writePolyShape( area.estudo, "../shapefile/BR_Clustering_kml3d" )

data.3d@c3[[20]]
data.3d@c4[[20]]
data.3d@c5[[20]]
data.3d@c6[[20]]
data.3d@c7[[20]]
data.3d@c8[[20]]
data.3d@c9[[20]]
data.3d@c10[[20]]