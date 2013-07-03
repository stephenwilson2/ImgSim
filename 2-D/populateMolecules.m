function imgdata=populateMolecules(imgdata,varargin)
%% Populates cells with molecules of some shape
%populateMolecules inputs:  1)imagedata
%                           2)copies of molecules*
%                           3)size of molecules*
%                           4)type (EVENTUALLY!)*
%                           * denotes optional input
%                  output: 
%                           1)the cell mask, 16-bit image matrix
%                           2)angles of the cells
%                           3)origins of the cells
%                           4)dimensions of the cell (in a cell type: len, height)
%                           5)the molecules channel (in a cell type)


    %Extract data about image
    img=imgdata{1};
    angles=imgdata{2};
    ori=imgdata{3};
    dim=imgdata{4};
        len=dim{1};
        height=dim{2};
    cells=imgdata{5};
        
    %Default values
    num = 5; % copies of molecules
    sz=100;
    shape='s';


    
    % Sets defaults for optional inputs
    optargs = {num,sz,shape};
    
    % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 3
        error('Takes at most 3 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    num = cell2mat(optargs(1));
    sz = cell2mat(optargs(2));
    shape = cell2mat(optargs(3));
    molori{length(cells)}=[];


    for i=1:length(cells)
        for n=1:num
            x=randi([1 (len-1)]);
            y=randi([1 (height-1)]);
            if ~strcmp(shape,'b')
                while cells{i}(x,y)==0
                    x=randi([1 (len-1)]);
                    y=randi([1 (height-1)]);
                end
            end
            xy=[x,y];
            molori{i}=xy;
            if ~strcmp(shape,'b')
                rna=rnaodna(xy,len,height,sz,cells{i});
                cells{i}(rna>0)=rna(rna>0);
            else
                cell{i}(x,y)=100;
            end
        end
        tmp=zeros(size(cells{i}));
        tmp(cells{i}>1)=cells{i}(cells{i}>1)*2;
        cells{i}=tmp;
    end
    imgdata={img,angles,ori,dim,cells,molori};
end
function pts=rnaodna(ori,len,height,size,cell)
    u(1:len,1:height)=0;
    for i=1:size
        %brings the pt back into cell if it gets out
        while cell(ori(1),ori(2))==0 && ori(2)>height/2
            ori(2)=ori(2)-1;
        end
        while cell(ori(1),ori(2))==0 && ori(2)<height/2
            ori(2)=ori(2)+1;
        end

        z=1;
        while z==1
            z=0;
            x=randi([1 4]);
            if  x==1 && ori(1)~=len-1
                ori(1)=ori(1)+1;
            elseif x==2 && ori(2)~=height-1
                ori(2)=ori(2)+1;
            elseif x==3 && ori(2)~=1
                ori(2)=ori(2)-1;
            elseif x==4 && ori(1)~=1
                ori(1)=ori(1)-1;
            else
                z=1;
            end 
        end
        u(ori(1),ori(2))=u(ori(1),ori(2))+100;
    end
    pts=u;
end 

