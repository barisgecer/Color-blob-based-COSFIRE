function [trainingSet testingSet] = getImgList(conf)
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

names= {'adm','swa','mch','mnc','mno','pea','zeb'};
numbers = [111,42,83,74,84,134,91];
load([conf.datasetdir '/training'])
trainingPath=char([]);
trainingClasses=[];
testingPath=char([]);
testingClasses=[];
for class=1:7
    for i =1:numbers(class)
        if any(ismember(c(class,:),i))
            trainingPath(end+1,:)=[conf.datasetdir  '/' num2str(class),'/',names{class}, num2str(i, '%03d'),'.jpg'];
            trainingClasses(end+1) = class;
        else
            testingPath(end+1,:)=[conf.datasetdir  '/' num2str(class),'/',names{class}, num2str(i, '%03d'),'.jpg'];
            testingClasses(end+1) = class;
        end
    end
end
trainingSet.Paths = trainingPath;
trainingSet.Classes = trainingClasses;
testingSet.Paths = testingPath;
testingSet.Classes = testingClasses;


idx = ismember(trainingSet.Classes,conf.classes);
trainingSet.Paths = trainingSet.Paths(idx,:);
trainingSet.Classes = trainingSet.Classes(idx)';

idx = ismember(testingSet.Classes,conf.classes);
testingSet.Paths = testingSet.Paths(idx,:);
testingSet.Classes = testingSet.Classes(idx)';