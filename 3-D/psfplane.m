function imgdata=psfplane(imgdata,plane,varargin)
% Applies psf in cells
%fluorescence inputs:  1)image matrix
%                      2)size of varience (in Gaussian varience)*
%                      3)matrix of the spread of the gaussian filter (make
%                      big enough to encompass the image)
%                      * denotes optional input
%             output: 
%                      1)image matrix
    %Default values
    s=50; % size of fluorescence (in terms of gaussian varience)
    img=imgdata{1};
    h=size(img{1},1);
    l=size(img{2},2);
    
    
    % Sets defaults for optional inputs
    optargs = {s};
    
    % Checks to ensure  1 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 1
        error('Takes at most 1 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    s = cell2mat(optargs(1));
    
    
        %matrix of the gaussian filter's kernal    
    if h>l
        ms=[h h];
    else
        ms=[l l];
    end
    f=fspecial('gaussian',ms,s);

    if sum(sum(img{plane}))>0
        p=img{plane};
        tic
        img2=imfilter(full(p),f);
        toc
        img{plane}=img2*1000;
    end
    imgdata={img, imgdata{2}};
end
    