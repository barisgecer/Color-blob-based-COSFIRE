% A small experiment on the butterfly data set
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.clear;
addpath('../../../CCOSFIRE');
conf = Conf(0.1);
conf.datasetdir = '../dataset';
conf.classes = 1:7;
conf.testN = Inf;
conf.frames =5;
%%
% conf.testN = 10;
% conf.classes = 1:2;
% conf.frames =1;


[trainingSet testingSet] = getImgList(conf);
[operators,Allprototypes,traintime] = trainFilters(trainingSet,conf);


%% enable test mode
idxTrain = [];
idxTest = [];
for class = conf.classes
    temp = find(trainingSet.Classes == class);
    idxTrain = [idxTrain temp(1:conf.testN)];
    temp = find(testingSet.Classes == class);
    idxTest = [idxTest temp(1:conf.testN)];
end
trainingSet.Paths = trainingSet.Paths(idxTrain,:);
trainingSet.Classes = trainingSet.Classes(idxTrain,:);
testingSet.Paths = testingSet.Paths(idxTest,:);
testingSet.Classes = testingSet.Classes(idxTest,:);

% testingSet.Paths = testingSet.Paths([7,11],:);
% testingSet.Classes = testingSet.Classes([7,11],:);


[xTrain yTrain tTrain] = filterTS(trainingSet,operators);
[xTest yTest tTest] = filterTS(testingSet,operators);

[predictions, accuracy, confusionMatrix, svmTrainingTime, svmTestingTime] = SVMClassifier(xTrain,yTrain,xTest,yTest,conf);

totalTime = (traintime + tTrain+tTest+svmTrainingTime+svmTestingTime)/60

save('Results','-v7.3');