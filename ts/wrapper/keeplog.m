function keeplog( conf , message )
% Keep logs of what is happening in the cluster
%
% VERSION 27/01/2017
%
% If you use this script please cite the following paper:
%   B. Gecer, G. Azzopardi, and N. Petkov, “Color-blob-based 
%	COSFIRE filters for Object Recognition” Image and Vision 
%	Computing, vol. 57, pp. 165-174, 2017.

    fileId = fopen(conf.log, 'a');
    fprintf(fileId, [message ' - ' num2str(etime(clock,conf.c)/60) ' min \n']);
    fclose(fileId);
end

