function [predictions, accuracy, confusionMatrix, svmTrainingTime, svmTestingTime] = SVMClassifier(xTrain,yTrain,xTest,yTest,conf)
% Run SVM
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

if ~isdeployed
	addpath(genpath('../../../libsvm-3.17'));
end
xTrainLog = log(xTrain);
xTestLog = log(xTest);

tic
model = svmtrain(yTrain,xTrainLog, conf.svmconf);
svmTrainingTime = toc;
tic
predictions = svmpredict(yTest, xTestLog, model, '-b 0 -q');
svmTestingTime = toc;
accuracy = sum(yTest==predictions)/length(yTest);
confusionMatrix = confusionmat(yTest,predictions);
