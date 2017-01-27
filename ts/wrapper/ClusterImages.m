function [prototypes]= ClusterImages (Imgs,ImgsOrg,operator,conf)
% Clustering training images to average them
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

addpath('..')
points = operator.tuples;
center = operator.center;
chs = conf.params.ColorSpace.channels;

%% Number of clusters
[~, ~, latent] = princomp(double(Imgs'),'econ');    %Imgs(considerRR,:)
la = latent(latent>max(latent)*conf.pcaThr);
nClusters =floor(size(la,1));

%% Extract features
values= [];
for imId = 1:size(Imgs,2)
    vals = [];
    for i = 1:size(chs,2)
        p = points(points(:,1)==chs(i),:);
        [c ,r] = pol2cart(p(:,5),p(:,4));
        r = round(r*-1+center(1));
        c = round(c*-1+center(2));
        vals = [vals; Imgs(sub2ind([conf.sz size(chs,2)],r,c,repmat(i,size(p,1),1)),imId).*p(:,3).^3];
    end
    values(:,imId)=vals;
end

%% Group images and return averages of grouprs
[idx] = kmeans(values',nClusters,'emptyaction','singleton','replicates',100,'start','uniform');
for cluster =1:nClusters
    prototype(:,:,chs) = reshape(mean(Imgs(:,(idx==cluster)),2),conf.sz(1),conf.sz(2),size(chs,2));
    prototypes{cluster} = prototype;
end