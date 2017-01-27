function [ Masks ] = createMasks( LabSpace, params )
% Create masks to consider only regions where there is significant color information
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

%rng('default'); % random sayilari almaya bastan basla
ratio = 0.4;
dis = 0.02;
minC = 0.5 - max(abs(min((min(LabSpace)))-0.5)*ratio,dis);
maxC = 0.5 + max(abs(max((max(LabSpace)))-0.5)*ratio,dis);

for ch = params.ColorSpace.color
    Masks(:,:,ch) = (LabSpace(:,:,ch) < minC(ch) | LabSpace(:,:,ch) > maxC(ch) );
    Masks(:,:,ch) = (LabSpace(:,:,ch) < minC(ch) | LabSpace(:,:,ch) > maxC(ch) );
end
for ch = params.ColorSpace.illumination
    Masks(:,:,ch) = ones(size(LabSpace,1),size(LabSpace,2));
    for chc = params.ColorSpace.color
        Masks(:,:,ch) = Masks(:,:,ch) & ~Masks(:,:,chc);
    end
end

end

