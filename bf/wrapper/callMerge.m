function callMerge()
% Merging results of the cluster
% Run SVM and collect the experiment results (i.e. accuracy, confusion matrix)
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

load('workspace');

conf.savefile = [conf.tempfolder ,['xy.mat']];
status = 'complete';
try
    load(conf.savefile);
    keeplog(conf,['merge:loaded']);
catch
    paths = []; times = [];
    xTrainA = []; yTrainA = [];
    xTestA = []; yTestA = [];
    node = 1;
    while node <= conf.nNodes
        try % Try to load the file, if can't wait for a while then try again
            load([conf.tempfolder 'jobs/job',num2str(node),'.mat']);
            paths = [paths;testingSetPaths];
            xTrainA = [xTrainA;xTrain];
            yTrainA = [yTrainA;yTrain];
            xTestA = [xTestA;xTest];
            yTestA = [yTestA;yTest];
            times(end+1) = totalTime;
            keeplog(conf,['merge:done for node(' num2str(node) ')']);
            node = node + 1; % if loaded, carry forward
        catch err
            keeplog(conf,['merge:waiting for node(' num2str(node) ')']);
            undonelist = [];
            for node2=1:conf.nNodes
                try % Try to load the file, if can't wait for a while then try again
                    load([conf.tempfolder 'jobs/job',num2str(node2),'.mat']);
                catch err
                    status = 'incomplete';
                    undonelist(end+1)=node2;
                end
            end
            undone = [conf.tempfolder,'jobs/','undone.sh'];
            undoneId = fopen(undone, 'w');
            for i=undonelist
                fprintf(undoneId, ['qsub -q ',conf.queue,' job%d.sh\n'],i);
            end
            fclose(undoneId);
            
            pause(30); % Wait for 30 seconds
        end
    end
    status = 'complete';
    %% Save Results
    try
        save(conf.savefile,'xTrainA','xTestA','paths','yTrainA','yTestA','times','-v7.3');
        keeplog(conf,['merge:saved!']);
    catch err
        keeplog(conf,['merge:' err.message ]);
    end
end

[predictions, accuracy, confusionMatrix, svmTrainingTime, svmTestingTime]  = SVMClassifier(xTrainA,yTrainA,xTestA,yTestA,conf);
keeplog(conf,['merge: svm done! Accuracy ' num2str(accuracy)]);


%%
nFullFilter = 0; nPartialFilter = 0;
for op = operators
    if op{1}.partial
        nPartialFilter = nPartialFilter + 1;
    else
        nFullFilter = nFullFilter + 1;
    end
end
nOfFilter = nPartialFilter + nFullFilter;

%% TS Group accuracies
groups = {[1],[2],[3],[4],[5],[6],[7]};
grAccuracy = zeros(1,length(groups));
for i=1:length(groups) 
    ind = ismember(yTestA,groups{i});
    grAccuracy(i) = sum(yTestA(ind)==predictions(ind))/length(yTestA(ind));
end

%% Save Results
conf.ResultFile = [conf.folder 'overall' '.txt'];
conf.fID = fopen(conf.ResultFile, 'w');
fprintf(conf.fID, ['%s \nAccuracy(SVM):%f \nMax Time:%f \nMean Time:%f*%d \nTrain Time:%f \nSVM Time:%f \nnum.Filters:%d(%d+%d)\nAdmiral:%f\nBlackSwallowtail:%f\nMachaon:%f\nMonarchClosed:%f\nMonarchOpen:%f\nPeacock:%f\nZebra:%f \n%s%s%s%s%s \n%s '],...
    status,accuracy, max(times)/60, mean(times)/60,conf.nNodes,traintime/60,(svmTrainingTime+svmTestingTime)/60,nOfFilter,nFullFilter,nPartialFilter ,...
    grAccuracy(1), grAccuracy(2), grAccuracy(3), grAccuracy(4), grAccuracy(5), grAccuracy(6), grAccuracy(7),... 
    evalc(['disp(conf)']), evalc(['disp(conf.params.COSFIRE)']), evalc(['disp(conf.params.DOG.sigmalist)']),...
    evalc(['disp(conf.params.ColorSpace)']), evalc(['disp(conf.params.partial)']), [char(13),char(10)]);
fclose(conf.fID);
xlswrite([conf.folder 'confusionMatrix.xls'],confusionMatrix);
xlswrite([conf.folder 'truthTable.xls'],[str2num(paths(:,end-8:end-4)),yTestA,predictions,yTestA==predictions]);

save(conf.savefile,'-v7.3');

keeplog(conf,['merge: Experiment is Done!']);

