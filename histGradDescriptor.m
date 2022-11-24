function [descriptor] = histGradDescriptor(XYZ_in,pos_xyz)

% settings
maxDist = 30;
increment = 0.4;
axisStep = 0.6;
ds_grid = 0.25;

% downsample
ptCloudOut = pcdownsample(pointCloud(XYZ_in),'gridAverage',ds_grid);
XYZ_ds = ptCloudOut.Location;

% check if position offset exists
if exist('pos_xyz','var')
    XYZ = XYZ_ds - ones(size(XYZ_ds,1),1)*pos_xyz;
else
    XYZ = XYZ_ds;
end


[rangeHist1] = getRangeHist(XYZ,maxDist,increment);
[rangeHist1X] = getRangeHist(XYZ+[axisStep,0,0],maxDist,increment);
[rangeHist1Y] = getRangeHist(XYZ+[0,axisStep,0],maxDist,increment);
[rangeHist1Z] = getRangeHist(XYZ+[0,0,axisStep],maxDist,increment);
descriptor = [rangeHist1X-rangeHist1,rangeHist1Y-rangeHist1,rangeHist1Z-rangeHist1]';

end

function [rangeHist] = getRangeHist(XYZ,maxDist,increment)

% init
xbins = 0 : increment : maxDist;

dists = sqrt( XYZ(:,1).^2 + XYZ(:,2).^2 + XYZ(:,3).^2 );

% rangeHist = hist(dists,xbins);
% 
% return;

%% accum histogram
rangeHist = int16(zeros(1,8*numel(xbins)) );


%% create two histograms
plusX = XYZ(:,1)>0;
plusY = XYZ(:,2)>0;
plusZ = XYZ(:,3)>0;

iterator = 1;

for x = -1 : 2 : 1
    for y = -1 : 2 : 1
        for z = -1 : 2 : 1
            
            baseline = true(size(plusX));
            
            if x < 0
                baseline = baseline & ~plusX;
            else
                baseline = baseline & plusX;
            end
            
            if y < 0
                baseline = baseline & ~plusY;
            else
                baseline = baseline & plusY;
            end
            
            if z < 0
                baseline = baseline & ~plusZ;
            else
                baseline = baseline & plusZ;
            end
            
            % histogram
            rangeHist_tmp = hist(dists(baseline),xbins);
            
            rangeHist(iterator : iterator + numel(xbins) - 1) = uint16( rangeHist_tmp);
            
            iterator = iterator + numel(xbins);
            
        end
    end
end
    



end

