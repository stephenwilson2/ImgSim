function imgdata=fluorescence(imgdata,varargin)
%% Draws fluorescence in cells
%fluorescence inputs:  1)16-bit image matrix
%                      2)size of varience (in Gaussian varience)*
%                      3)matrix of the spread of the gaussian filter (make
%                      big enough to encompass the fluorescence)
%                      * denotes optional input
%             output: 
%                      1)the cell mask, 16-bit image matrix
%                      2)angles of the cells
%                      3)origins of the cells
%                      4)dimensions of the cell (in a cell type: len, height)
%                      5)the molecules channel (in a cell type)
%                      6)The fluorescence channel (in a cell type)

    %Extract data about image
    img=imgdata{1};
    angles=imgdata{2};
    ori=imgdata{3};
    dim=imgdata{4};
    cells=imgdata{5};
     
    %Default values
    sof=.1; % size of fluorescence (in terms of gaussian varience)
    ms=[10 10]; %matrix of the spread of the gaussian filter
    bi=1;
    
    % Sets defaults for optional inputs
    optargs = {sof,ms,bi};
    
    % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 3
        error('Takes at most 3 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    sof = cell2mat(optargs(1));
    ms = cell2mat(optargs(2));
    bi = cell2mat(optargs(3));
    
    fc{length(cells)}=0;
    for i=1:length(cells)
        fc{i}=fluoro(cells{i}>0,cells{i},dim);
        fc{i}=psf(fc{i},sof);
    end
    
    imgdata={img,angles,ori,dim,cells,fc};
end 
 function fl2=fluoro(pts,cell,dm)
    l=dm{1};
    h=dm{2};
    fl2(l,h)=0;
    fl2(pts==1)=cell(pts==1);
 end
    



