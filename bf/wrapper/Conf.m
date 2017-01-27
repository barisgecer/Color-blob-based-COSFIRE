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
conf.params.DOG.sigmalist = (conf.params.resolution*([2.^(5:0.3:8)/50])); 
conf.params.COSFIRE.eps = 1e-8;
conf.params.COSFIRE.b = [0 0 0]*conf.params.resolution; %0.3 1.1 1.1]*conf.params.resolution;
conf.params.COSFIRE.lambda = 0; %0.45;
conf.params.COSFIRE.mintupleweight = 0.05;
conf.params.partial.Sz =  [5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.5]*conf.params.resolution;
conf.params.partial.N = 2 ;
conf.params.partial.T = 'partial' ; %['partial','full','together'];
conf.params.COSFIRE.minNTuples = 10; % [0:Inf]
conf.params.invariance.rotation.psilist    = (0:22.5:179)*pi/180;
conf.params.invariance.scale.upsilonlist   = 2.^(-1.5:0.6:1.5);
conf.params.invariance.reflection          = 0; % Reflection invariance about the y-axis. 0 = do not use, 1 = use.

%% New application-specific configurations
conf.totalPixel = 4000;
conf.classes = 1:7;

conf.svmconf = '-s 0 -t 0 -b 0 -h 0 -c 1e+6';

conf.frames =30;
conf.nNodes = 96;
%setup.nNodes = 45;

conf.c=clock;
conf.expName =[ date '_' num2str(conf.c(4),'%02d') '-' num2str(conf.c(5),'%02d')];
conf.queue = 'quads';
conf.datasetdir = '/home/s2365596/datasets/butterfly/';
conf.homedir = '/home/s2365596/v7/bf/';
conf.datadir = '/data/s2365596/';

%% Gray-scale
%conf.params.ColorSpace.name = 'gray';
%conf.params.ColorSpace.channels = 1;
%conf.params.ColorSpace.color = [];
