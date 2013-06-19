function img2=psf(img,varargin)
%% Applies psf in cells
%fluorescence inputs:  1)image matrix
%                      2)size of varience (in Gaussian varience)*
%                      3)matrix of the spread of the gaussian filter (make
%                      big enough to encompass the fluorescence)
%                      * denotes optional input
%             output: 
%                      1)spread image matrix
    %Default values
    s=.1; % size of fluorescence (in terms of gaussian varience)
    ms=[1000 1000]; %matrix of the spread of the gaussian filter
    
    % Sets defaults for optional inputs
    optargs = {s,ms};
    
    % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 3
        error('Takes at most 3 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    s = cell2mat(optargs(1));
    ms = cell2mat(optargs(2));
    sum(sum(img>1))

    f=fspecial('gaussian',ms,s);
    img2=imfilter(img,f);
end