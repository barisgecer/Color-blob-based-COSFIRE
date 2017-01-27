function callTraining()
% Some prior steps before distributing computation over the cluster 
% including training filters and arranging the data
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

load('workspace');
keeplog(conf,'training:started!');

[trainingSet testingSet] = getImgList(conf);
[operators,prototypes,traintime] = trainFilters(trainingSet,conf);

save('prototypes','prototypes');
clear prototypes;

save('workspace');
keeplog(conf,'training:done!');
end

