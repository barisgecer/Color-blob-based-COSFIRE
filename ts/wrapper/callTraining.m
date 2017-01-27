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

CCOSFIREtrainingSet = getImgList(conf);
[operators,prototypes,traintime] = trainFilters(CCOSFIREtrainingSet,conf);

save('prototypes','prototypes');
clear prototypes;

%% Prepare Training and Testing sets for the SVM from the CCOSFIRE responses
temp = conf; temp.frames = temp.framessvm;
SVMtrainingSet = getImgList(temp);

[SVMtestingSet.Paths, SVMtestingSet.Crops, SVMtestingSet.Classes] = readSignData([conf.datasetdir,'Final_Test/Images/GT-final_test.csv']);
SVMtestingSet.Paths = [repmat([conf.datasetdir,'Final_Test/Images/'],length(SVMtestingSet.Paths),1) char(SVMtestingSet.Paths)];
idx = ismember(SVMtestingSet.Classes,conf.classes);
SVMtestingSet.Paths = SVMtestingSet.Paths(idx,:);
SVMtestingSet.Crops = SVMtestingSet.Crops(idx,:);
SVMtestingSet.Classes = SVMtestingSet.Classes(idx,:);

save('workspace');
keeplog(conf,'training:done!');

end

