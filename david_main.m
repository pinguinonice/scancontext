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

pcCopys(nGridY).pc = ptCloud.Location;

n_ref = 10000;

usePointAsRef = rand(ptCloud.Count,1) < n_ref/ptCloud.Count;



D = cell(ptCloud.Count,1);


parfor  n= 1:ptCloud.Count


    if usePointAsRef(n) == 0
        continue;
    end


    D{n} = histGradDescriptor(ptCloud.Location, ptCloud.Location(n,1:3) );


    n / ptCloud.Count
end


%% calc descriptor for random "scan"
rndPt=[X(10) Y(60) 0 ];

RandID = 150000;
rndD = histGradDescriptor(ptCloud.Location,ptCloud.Location(RandID,:));

[~,idX]=min(abs(X-rndPt(1))) ;
[~,idY]=min(abs(Y-rndPt(2))) ;

%calculate closest sample point deom D
similarityMap = nan(ptCloud.Count,3);


for n =1:ptCloud.Count
        
    if isempty(D{n})
        continue;
    end

    similarityMap(n,:) = [ptCloud.Location(n,1:2), similarityScore(rndD,D{n} )];

    n/ptCloud.Count
end

similarityMap=similarityMap(~isnan(similarityMap(:,1)) ,:);

scatter(similarityMap(:,1),similarityMap(:,2), 12,(similarityMap(:,3)+0.0001),'filled');
hold on
colorbar
plot(ptCloud.Location(RandID,1),ptCloud.Location(RandID,2),'or','MarkerSize',15);
hold on
[val,id] = max(similarityMap(:,3));
plot(similarityMap(id,1),similarityMap(id,2),'+k','MarkerSize',15);
% figure
% imagesc(dist)
% 
% hold on
% 
% plot(idY,idX,'or','MarkerSize',20)

