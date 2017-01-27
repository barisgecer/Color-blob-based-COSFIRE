function [alpha,mu,sigma,rho,phi,weight] = loadTuple( tuples )

% tuple loading protocol
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

alpha = tuples(:,1);
mu = tuples(:,2);
sigma = tuples(:,3);
rho = tuples(:,4);
phi = tuples(:,5);
if size(tuples,2) >=6
weight = tuples(:,6);
end
end

