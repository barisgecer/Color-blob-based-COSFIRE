function  displ(operator,resolution,fig)
% Visualize a given filter
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

if nargin == 1
    resolution  = 1;
end

if nargin == 3
     figure(fig);
 else
     fig = figure;
end
center  = operator.center;
sz = round(operator.size(1:2).*(1/resolution));
im = zeros([sz 3] );
%im(:,:,1) = im(:,:,1)+50;
[~,IX] = sort(abs(operator.tuples(:,3)),'descend');
[alpha,mu,sigma,rho,phi] = loadTuple( operator.tuples(IX,:) );
[c, r] = pol2cart(phi,rho);
r = round((-r).*(1/resolution)+sz(1)/2);
c = round((c).*(1/resolution)+sz(2)/2);
radius = abs( sigma*0.96.*(1/resolution));%+rand*0.6-0.3;

for j=operator.params.ColorSpace.channels
    for i=find(alpha==j)'     
        centreKernel = fspecial('gaussian',sz,abs(sigma(i))*0.5.*(1/resolution));
        blob = (centreKernel./(max(centreKernel(:))))./2;
        blob = blob.*sign(mu(i));
        if mu(i)==-1 & j==1
            blob = blob/3;
        end
        [r_ , c_] = pol2cart(phi(i),rho(i));r_ = round(r_.*(1/resolution));c_ = round(c_.*(1/resolution));
        sblob = imshift(blob ,-c_,r_);
        im(:,:,alpha(i)) =im(:,:,alpha(i))+ sblob;
    end
    temp = im(:,:,j)+0.5;
    temp(temp>1) = 1;
    temp(temp<0) = 0;
    im(:,:,j) = temp;
end

im(:,:,1) = im(:,:,1) * 100;
im(:,:,2) = (im(:,:,2)*255 - 128);
im(:,:,3) = (im(:,:,3)*255 - 128) ;

for i=find(alpha==operator.params.ColorSpace.illumination)'
    %val =(sigma(i)>0)*80 + (sigma(i)<0)*20; %operator.Centroids{alpha(i)}(omega(i));
    %im(:,:,alpha(i)) =createDisk(im(:,:,alpha(i)),r(i),c(i),radius(i),val); 
end
%output=colorSpaceTransformT(im,operator.params)
C = makecform('lab2srgb');
output = applycform(double(im),C);
imshow(output);
for i=1:size(alpha,1) 
    linestyle='-';
    switch alpha(i)*sign(mu(i))
        case -1
            renk = 'k';
        case 1
            renk = 'w';
        case -2
            renk = 'c';
            %linestyle='--';
        case 2
            renk = 'm';
        case -3
            renk = 'b';
        case 3
            renk = 'y';
            %linestyle ='--';
    end
     rectangle('Position',[c(i)-radius(i) r(i)-radius(i) radius(i)*2 radius(i)*2],'Curvature',[1,1],'EdgeColor',renk,'LineWidth',1,'LineStyle',linestyle);
     daspect([1,1,1]);
end
%imshow(output);
%export_fig(['../conf/structure.png'],'-native');