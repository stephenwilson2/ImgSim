function imgdata=coarsen(id,varargin)
%% Draws fluorescence in cells
%coarsen inputs:  1)16-bit image matrix
%                 2)the current number of nm per pixel
%                 3)the target number of nm per pixel
%                 * denotes optional input
%        output: 
%                 1)the cell mask, 16-bit image matrix
%                 2)angles of the cells
%                 3)origins of the cells
%                 4)dimensions of the cell (in a cell type: len, height)
%                 5)the molecules channel (in a cell type)
%                 6)The fluorescence channel (in a cell type)

    %Extract data about image
    img=id{1};
    angles=id{2};
    ori=id{3};
    dim=id{4};
    cells=id{5};
    flcells=id{6};
    
    %Default values
    nmperpixel=1;
    target=2;
    
    % Sets defaults for optional inputs
    optargs = {nmperpixel,target};
    
    % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 2
        error('Takes at most 1 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    nmperpixel = cell2mat(optargs(1));
    target = cell2mat(optargs(2));
    
    ats=target/nmperpixel;
    
    for i=1:length(flcells)
        flcells{i}=accu(flcells{i},ats);
    end
        
    imgdata={img,angles,ori,dim,cells,flcells};
end


function C=accu(img,factor)
    subs={};
    s=size(img);
    w=s(1);
    h=s(2);
    m=0;
    
    
    for i=1:w
        for n=1:h
            m=m+1;
            subs{m}=[round(i/factor)+1; round(n/factor)+1];
        end
    end
    
    subs=cell2mat(subs);
    
    subs=subs';

    
    
    bl=[];
    for i=1:w
        bl=[bl img(i,:)];
    end

    C=accumarray(subs,bl,[],@mean);
end