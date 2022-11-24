clc
clear all
close all

% load las

path = fullfile(toolboxdir("lidar"),"lidardata", ...
"las","aerialLidarData.laz");
lasReader = lasFileReader(path);
ptCloud = readPointCloud(lasReader);


% calc descriptor
minPt= min(ptCloud.Location);
maxPt=max(ptCloud.Location);

nGridX=100
nGridY=100

maxRad= [0 10]

n=1
m=1
X=linspace(minPt(1),maxPt(1),nGridX);
Y=linspace(minPt(2),maxPt(2),nGridY);
parfor  n= 1:nGridX
    for m = 1:nGridY


        D{n,m} = histGradDescriptor(ptCloud.Location,[X(n),Y(m),0]);

%         figure(1)
%         image(D{n,m})
% 
%         
% 
% 
%         figure(2)
%         pcshow(ptCloud)
%         hold on
%         plot(i,j,'o', 'MarkerSize',15)
% 
%         waitforbuttonpress
        

    end
n
end


%calc descriptor for random "scan"
rndPt=[X(10) Y(60) 0 ];
        rndD = histGradDescriptor(ptCloud.Location,[rndPt(1:2) 0]);

 [~,idX]=min(abs(X-rndPt(1))) ;   
  [~,idY]=min(abs(Y-rndPt(2))) ;      

%calculate closest sample point deom D
dist=nan(nGridX,nGridY);
parfor n =1:nGridX
    for m =1:nGridY
    dist(n,m) = similarityScore(rndD,D{n,m} );

    end
    n
end

figure
imagesc(dist)

hold on

plot(idY,idX,'or','MarkerSize',20)

