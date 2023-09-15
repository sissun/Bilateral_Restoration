
library(Morpho)
library(rgl)
library(Arothron)
library(shapes)
library(geomorph)
library(ggplot2)
library(ggrepel)

rm(list=ls())
myfree<-theme_set(theme_bw())
windowsFonts(HEL=windowsFont("Helvetica CE 55 Roman"),
             RMN=windowsFont("Times New Roman"),
             ARL=windowsFont("Arial"))
old_theme <- theme_update(
  plot.title=element_text(family="ARL", size=8, face="bold", colour="black"),
  axis.title.x=element_text(family="HEL", size=8,face="bold", colour="black"),
  axis.title.y=element_text(family="HEL", size=8, face="bold",angle=90, colour="black"),
  axis.text.x=element_text(family="RMN", size=8, colour="black"),
  axis.text.y=element_text(family="RMN", size=8, colour="black"),
  axis.ticks=element_line(colour="black"),
  panel.grid.major=element_blank(),
  panel.grid.minor=element_blank(),
  panel.background=element_blank(),
  axis.line=element_line(size=1)
) 


readset<-function(folder)
{
  files<-length(list.files(folder))
  seti<-as.matrix(read.table(paste(folder,list.files(folder)[1],sep="/")))
  Array<-array(NA,dim=c(dim(seti)[1],dim(seti)[2],files))
  for(i in 1:dim(Array)[3]){
    Array[,,i]<-as.matrix(read.table(paste(folder,list.files(folder)[i],sep="/")))
  }
  return(Array)
}


#Load landmarks
lm<-readset("D:/Landmarks")
gpa<- gpagen(lm) #GPA-alignment

PCA<- gm.prcomp(gpa$coords)
score<-PCA$x[,1:2]


df <- data.frame(x =PCA$x[,1], y = PCA$x[,2])
names(df)=c("PC1","PC2")
head(df)
tiff(file = paste("D:/PCA.tiff",sep=""), res = 300, width = 2000, height = 2000, compression = "lzw")
pca_plot <- ggplot(df, aes(x=PC1, y=PC2))+geom_point(size=2,shape=19)

pca_plot+ggtitle(label =" PC1 & PC2")+
  theme(plot.title = element_text(lineheight=.8, size=8, face="bold",hjust = 0.5)) +
  theme(legend.title=element_text(face="bold",size=8)) +
  theme(legend.text=element_text(face="bold",size=8))+
  theme(legend.position = "bottom")+
  theme(axis.title.x =element_text(face="bold",size=8), axis.title.y=element_text(face="bold",size=8))+
  theme(axis.title.x =element_text(face="bold",size=8), axis.title.y=element_text(face="bold",size=8))+scale_colour_discrete("Data",breaks=c("1", "2","3"),labels=c("Sliding","ICP","NICP"))+
  scale_x_continuous(breaks=seq( -0.06, 0.34,0.05))+
  scale_y_continuous(breaks=seq( -0.06, 0.06,0.01))
dev.off()

 