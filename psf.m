function img2=psf(img,varargin)
%% Applies psf in cells
%fluorescence inputs:  1)image matrix
%                      2)size of varience (in Gaussian varience)*
%                      3)matrix of the spread of the gaussian filter (make
%                      big enough to encompass the image)
%                      * denotes optional input
%             output: 
%                      1)image matrix
    %Default values
    s=.1; % size of fluorescence (in terms of gaussian varience)
    
    %matrix of the gaussian filter's kernal
    h=size(img,1);
    l=size(img,2);
    if h>l  
        ms=[h h];
    else
        ms=[l l];
    end 
    
    % Sets defaults for optional inputs
    optargs = {s,ms};
    
    % Checks to ensure  2 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 2
        error('Takes at most 2 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    s = cell2mat(optargs(1));
    ms = cell2mat(optargs(2));

    f=fspecial('gaussian',ms,s);
    img2=imfilter(img,f);
end