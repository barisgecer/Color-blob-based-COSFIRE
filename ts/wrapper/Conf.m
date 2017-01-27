function conf = Conf(resolution)
% Parameters specific for traffic sign experiment including COSFIRE parameter choices
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

if nargin > 0 % Set the resolution to speed up

   conf.params = Parameters(resolution);
else
    conf.params = Parameters(1);
end

%% Changes in the parameters of CCOSFIRE
conf.params.DOG.sigmalist = (conf.params.resolution*(0.5:0.25:15)); 
conf.params.COSFIRE.eps = 1e-8;
conf.params.COSFIRE.b = [0.3 1.1 1.1]*conf.params.resolution;
conf.params.COSFIRE.lambda = 0; %0.45;
conf.params.COSFIRE.mintupleweight = 0.05;
conf.params.partial.Sz =  [12 12 12 12 12];
conf.params.partial.N = 5 ;
conf.params.partial.T = 'together' ; %['partial','full','together'];
conf.params.conc = 0:1;
conf.params.COSFIRE.minNTuples = 10; % [0:Inf]

%% New application-specific configurations

conf.szv = 50;
conf.sz = [conf.szv conf.szv];
conf.nConf = 100000;
conf.pcaThr = 0.025;
%conf.classes = [12,20,26];
conf.classes = 0:42;

conf.gausWeSigma = 8;
conf.splitGrid = [2, 2];

conf.svmconf = '-s 0 -t 0 -b 0 -h 0 -c 1e+6';

%setup.frames =1:2:30;%1:30;%[5,15,25,30]; %[5,15,25,30];
conf.frames =1:30;
%setup.framessvm =[1:3:15 15:2:25 26:30];%1:30;%[1:6:29, 30];
conf.framessvm =1:30;%[1:6:29, 30];
conf.nNodes = 480;
%setup.nNodes = 45;

conf.c=clock;
conf.expName =[ date '_' num2str(conf.c(4),'%02d') '-' num2str(conf.c(5),'%02d')];
conf.queue = 'nodes';
conf.datasetdir = '/home/s2365596/datasets/GTSRB/';
conf.homedir = '/home/s2365596/v7/ts/';
conf.datadir = '/data/s2365596/';