% A small experiment on GTSRB data set
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.
clear;
addpath('../../CCOSFIRE');
conf = Conf();
conf.datasetdir = '../../../datasets/GTSRB/';
conf.classes = [12,20,26];
conf.frames =30;
conf.framessvm =30;
CCOSFIREtrainingSet = getImgList(conf);
operators = trainFilters(CCOSFIREtrainingSet,conf);

%% Prepare Training and Testing sets for the SVM from the CCOSFIRE responses
temp = conf; temp.frames = temp.framessvm;
SVMtrainingSet = getImgList(temp);

[SVMtestingSet.Paths, SVMtestingSet.Crops, SVMtestingSet.Classes] = readSignData([conf.datasetdir,'Final_Test/Images/GT-final_test.csv']);
SVMtestingSet.Paths = [repmat([conf.datasetdir,'Final_Test/Images/'],length(SVMtestingSet.Paths),1) char(SVMtestingSet.Paths)];
idx = ismember(SVMtestingSet.Classes,conf.classes);
SVMtestingSet.Paths = SVMtestingSet.Paths(idx,:);
SVMtestingSet.Crops = SVMtestingSet.Crops(idx,:);
SVMtestingSet.Classes = SVMtestingSet.Classes(idx,:);

%% enable test mode
idx = 1:10;
SVMtrainingSet.Paths = SVMtrainingSet.Paths(idx,:);
SVMtrainingSet.Crops = SVMtrainingSet.Crops(idx,:);
SVMtrainingSet.Classes = SVMtrainingSet.Classes(idx,:);
SVMtestingSet.Paths = SVMtestingSet.Paths(idx,:);
SVMtestingSet.Crops = SVMtestingSet.Crops(idx,:);
SVMtestingSet.Classes = SVMtestingSet.Classes(idx,:);


[xTrain yTrain] = filterTS(SVMtrainingSet,operators,conf);
[xTest yTest] = filterTS(SVMtestingSet,operators,conf);

[predictions, accuracy, confusionMatrix] = SVMClassifier(xTrain,yTrain,xTest,yTest,conf);

save('Results','-v7.3');