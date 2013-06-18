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
    
    ats=target;
    for i=1:length(flcells)
        flcells{i}=accu(flcells{i},ats);
    end
    for i=1:length(cells)
        cells{i}=accu(cells{i},ats);
    end
    figure(1)
    subplot(1,2,1)
    imagesc(img);
    img=accu(img,ats);
    subplot(1,2,2)
    imagesc(img);
    for m=1:length(angles)
        ori(m,:)=ori(m,:)/ats;
    end
    imgdata={img,angles,ori,dim,cells,flcells};
end


function final=accu(img,factor)
    s=size(img);
    w=s(1);
    h=s(2);
    if w>factor
        wp=ceil(w/factor);
    else
        'too big a factor for w'
    end
    if h>factor
        hp=ceil(h/factor);
    else
        'too big a factor for h'
    end
    y=zeros(factor,factor);
    x{wp,hp}=[];
    n=0;
    for i=1:wp
        for j=1:hp
            n=n+1;
            y(:,:)=n;
            x{i,j}=y;
        end
    end
    y=cell2mat(x);
    y
    y=y(1:w,1:h);
    img
    y
    v1 = reshape(img,numel(img),1);
    s1 = reshape(y,numel(y),1);
    
    C=accumarray(s1,v1,[max(s1) 1],@mean);
    f{wp,hp}=[];
    n=0;
    for i=1:wp
        for j=1:hp
            n=n+1;
            f{i,j}=C(n);
        end
    end
    
    final=cell2mat(f);
    final

end