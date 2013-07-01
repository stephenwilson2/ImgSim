function imgdata=populateMolecules(imgdata,varargin)


    %Extract data about image
    img=imgdata{1};
    mask=img;
 
    dim=imgdata{2};
        len=dim{1}*2;
        r=dim{2}*2;
        
        
    %Default values
    num = 5; % copies of molecules
    sz=100;

    
    % Sets defaults for optional inputs
    optargs = {num,sz};
    
    % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 2
        error('Takes at most 2 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    num = cell2mat(optargs(1));
    sz = cell2mat(optargs(2));

    ls_xy=[];
    ls_z=[];
    for n=1:num
        x=randi([1 (len-1)]);
        y=randi([1 (r-1)]);
        z=randi([1 (r-1)]);
        
        while img{z}(x,y)==0
            [row, col]=find(img{z});
            x=randi([1 (length(row))]);
            y=randi([1 (length(col))]);
            x=row(x);
            y=col(y);
        end
        xy=[x,y];
        ls_xy=[ls_xy; xy];
        ls_z=[ls_z; z];
        rna=rnaodna(x,y,len,r,sz,img,z);
        for m=1:length(img)
            if sum(sum(rna{m}))>0
                img{m}(rna{m}>0)=rna{m}(rna{m}>0);
            end
        end
    end
    for m=1:length(img) % gets rid of the cell mask
        img{m}(img{m}==1)=0;
    end

    imgdata={img,mask,dim,ls_xy,ls_z};
end
function pts=rnaodna(x,y,len,height,siz,cell,z)
    ls{length(cell)}=[];
    u(1:size(cell{1},1),1:size(cell{1},2))=0;

    for i=1:siz
        
        while cell{z}(x,y)==0 && y>height/2
            y=y-1;
        end
        while cell{z}(x,y)==0 && y<height/2
            y=y+1;
        end
        
        in=0;
        while in==0
            in=1;
            o=randi([1 6]);
            if  o==1 && x~=len
                x=x+1;
            elseif o==2 && y~=height
                y=y+1;
            elseif o==3 && z~=height
                z=z+1;
                
            elseif o==4 && y~=1
                y=y-1;
            elseif o==5 && x~=1
                x=x-1;
            elseif o==6 && z~=1
                z=z-1;
            else
                in=0;
            end
        end
        
        u(x,y)=u(x,y)+10;
        ls{z}=u;
    end
    pts=ls;
end 