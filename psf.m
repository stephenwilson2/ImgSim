function imgdata=psf(imgdata,varargin)
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
    img=imgdata{1};
    
    % Sets defaults for optional inputs
    optargs = {s};
    
    % Checks to ensure  2 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 1
        error('Takes at most 1 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    s = cell2mat(optargs(1));

    
    for i=1:length(img)
    %matrix of the gaussian filter's kernal
        h=size(img{i},1);
        l=size(img{i},2);
        ms=[h,l];
        p=img{i};
        f=fspecial('gaussian',ms,s);
        img2=imfilter(full(p),f);
        img{i}=sparse(img2);
    end
    imgdata{1}=img;
end