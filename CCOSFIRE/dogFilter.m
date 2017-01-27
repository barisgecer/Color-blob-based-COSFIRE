function [ DoG_Resp, dogKernel] = dogFilter( im, sigma, params)
%Difference of Gaussian
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.


centreoff=false;
if sigma<0
    centreoff=true;
    sigma = sigma*-1;
end
n = 2*ceil(2.5*sigma)+1;
gamma = params.DOG.gamma;
centreKernel = fspecial('gaussian',n,sigma*gamma);
surroundKernel =fspecial('gaussian',n,sigma);

dogKernel = centreKernel - surroundKernel;

posidx = dogKernel > 0 ;
negidx = dogKernel < 0 ;
dogKernel(posidx) = (dogKernel(posidx) ./ sum(dogKernel(posidx))).*1 ;
dogKernel(negidx) = (dogKernel(negidx) ./ abs(sum(dogKernel(negidx)))).*1 ;

if centreoff
    dogKernel = dogKernel*-1;
end

DoG_Resp = convolution(im,dogKernel);
DoG_Resp(DoG_Resp<0) = 0;

end

