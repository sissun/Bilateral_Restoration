clear

%1. Load landmarks
numFullLm=18;    
Files = dir(fullfile('D:\Landmarks\','*.txt')); 
LengthFiles = length(Files);
for i=1:LengthFiles
    [a,FileName,c]=fileparts(Files(i).name);
    FullSets{i}= load(strcat('D:\Landmarks\',FileName,'.txt'));    
end

%2. GPA 
% arbitray
for k = 1:LengthFiles 
    center= mean(FullSets{k});  
    GPAFullSets{k}= FullSets{k}-center; %translation
    GPAFullSets{k}= GPAFullSets{k}./sqrt(sum(sum( GPAFullSets{k}.^2, 2), 1)); %scaling
    [error,Alignedsource,transform] = procrustes( GPAFullSets{1}, GPAFullSets{k},'scaling',false); %rotation
    GPAFullSets{k}= Alignedsource;
end
[m,n]=size(GPAFullSets{1});

for iter=1:5 
  meanshape=zeros(m,n);
  for k = 1:LengthFiles  
    meanshape= meanshape+ GPAFullSets{k};
  end
  meanshape= meanshape./(LengthFiles); 
  meanshape= meanshape./sqrt(sum(sum(meanshape.^2, 2), 1));
  % meanshape
  for k = 1:LengthFiles 
    center= mean(GPAFullSets{k});  
    GPAFullSets{k}= GPAFullSets{k}-center; %%translation
    GPAFullSets{k}= GPAFullSets{k}./sqrt(sum(sum( GPAFullSets{k}.^2, 2), 1)); %scaling
    [error,Alignedsource,transform] = procrustes(meanshape,GPAFullSets{k},'scaling',false);%rotation
    GPAFullSets{k}= Alignedsource;
  end  
end


%3. PCA
Data=zeros(LengthFiles,numFullLm*3);
for k = 1:LengthFiles
    Data(k,1:numFullLm)=GPAFullSets{k}(:,1);
    Data(k,(numFullLm+1):numFullLm*2)=GPAFullSets{k}(:,2);
    Data(k,(2*numFullLm+1):numFullLm*3)=GPAFullSets{k}(:,3);
end
[coeff,score,latent,tsquared,explained,mu] = pca(Data);

t = score*coeff' + repmat(mu,LengthFiles,1);
error=Data-t;
[m,n]=size(score);

for i=1:n
   ratio=sum(explained(1:i))/sum(explained);
   if ratio>0.98
       id=i;
       break;
   end
end

Train.coeff=coeff(:,1:id);
Train.score=score(:,1:id);
Train.mean=mu;
%show
plot(Train.score(:,1),Train.score(:,2),'*');

