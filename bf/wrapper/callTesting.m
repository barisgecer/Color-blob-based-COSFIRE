function callTesting( node )
% Apply filters on the training and test images
% This code is run on different computers simultaneously where 
% node index to the computer
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

node =str2num(node);
load('workspace');
keeplog(conf,['node(' num2str(node) '):started!']);
% Make sure training is done before start this
while ~exist('testingSet','var')
    keeplog(conf,['node(' num2str(node) '):waiting for training']);
    pause(30); % Wait for 30 seconds
    try
        load('workspace');
    catch err
        continue;
    end
end

%% enable test mode
nImg = length(trainingSet.Classes);
from = floor((node-1)*(nImg/conf.nNodes)+1);
to = floor((node)*(nImg/conf.nNodes));

trainingSet.Paths = trainingSet.Paths(from:to,:);
trainingSet.Classes = trainingSet.Classes(from:to,:);

nImg = length(testingSet.Classes);
from = floor((node-1)*(nImg/conf.nNodes)+1);
to = floor((node)*(nImg/conf.nNodes));

testingSet.Paths = testingSet.Paths(from:to,:);
testingSet.Classes = testingSet.Classes(from:to,:);

if(exist([conf.tempfolder 'jobs/ot',num2str(node),'.mat']))
    load([conf.tempfolder 'jobs/ot',num2str(node),'.mat'])
    keeplog(conf,['node(' num2str(node) '):trainingSet is loading!']);
else
    [xTrain yTrain timeTrain] = filterImages(trainingSet,operators,conf.totalPixel);
    save([conf.tempfolder 'jobs/ot',num2str(node),'.mat'],'xTrain','yTrain','timeTrain');
    keeplog(conf,['node(' num2str(node) '):trainingSet is done!']);
end

[xTest yTest timeTest] = filterImages(testingSet,operators,conf.totalPixel);
keeplog(conf,['node(' num2str(node) '):testingSet is done!']);

totalTime = timeTrain + timeTest;
testingSetPaths = testingSet.Paths;
save([conf.tempfolder 'jobs/job',num2str(node),'.mat'],'xTrain','yTrain','xTest','yTest','testingSetPaths','totalTime');
delete([conf.tempfolder 'jobs/ot',num2str(node),'.mat']);
keeplog(conf,['node(' num2str(node) '):saved!']);

if conf.nNodes == node
    callMerge();
end
end

