function  initialize(name,subdate,subdate2,min,minSvm)
% Starting the experiment
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

tic
%% Options
temp_name = name;
temp_subdate = subdate;
temp_subdate2 = subdate2;
temp_min = min;
temp_minSvm = minSvm;
if exist('../workspace.mat')==2
    load('../workspace.mat');
end
name = temp_name;
subdate = temp_subdate;
subdate2 = temp_subdate2;
min = temp_min;
minSvm = temp_minSvm;
clear temp_name temp_subdate temp_subdate2 temp_min temp_minSvm;


conf = Conf();
conf.expName = name;
conf.folder = [conf.homedir 'exps/' conf.expName '/'];
conf.tempfolder = [conf.datadir 'exps/' conf.expName '/'];
conf.log = [conf.homedir 'exps/' conf.expName '/log.txt'];
mkdir([conf.homedir 'exps']);
mkdir(conf.folder);
mkdir(conf.tempfolder);
mkdir([conf.folder 'jobs/']);
mkdir([conf.tempfolder 'jobs/']);

%% Copy Run Files
mkdir([conf.folder 'CCOSFIRE']);
mkdir([conf.folder 'wrapper']);
copyfile([conf.homedir 'compile/*'],conf.folder);
copyfile([conf.homedir '../CCOSFIRE/*'],[conf.folder 'CCOSFIRE/']);
copyfile([conf.homedir 'wrapper/*'],[conf.folder 'wrapper/']);

%% Testing Initialization
fid = fopen([conf.homedir 'compile/job.sh']);
draft = fscanf(fid, '%c', [Inf]);
fclose(fid);
submitfile = [conf.folder,'jobs/','submitjobs.sh'];
submitfileID = fopen(submitfile, 'w');
for i=1:conf.nNodes
    temp = draft;
    temp = strrep(temp, '[NODE]', num2str(i));
    temp = strrep(temp, '[PATH]',conf.folder);
    if i==conf.nNodes
        temp = strrep(temp, '[MIN]',num2str(str2num(min)+str2num(minSvm)));
    else
        temp = strrep(temp, '[MIN]',min);
    end
    fid = fopen([conf.folder,'jobs/job',num2str(i),'.sh'], 'w');
    fprintf(fid, '%s', temp);
    fclose(fid);
    if i==conf.nNodes
        fprintf(submitfileID, ['qsub -q ',conf.queue,' -a ',subdate2,' job%d.sh\n'],i);
    else
        fprintf(submitfileID, ['qsub -q ',conf.queue,' -a ',subdate,' job%d.sh\n'],i);
    end
end
fclose(submitfileID);
save([conf.folder,'workspace.mat']);
toc