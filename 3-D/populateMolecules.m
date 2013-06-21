function imgdata=populateMolecules(imgdata,varargin)


    %Extract data about image
    img=imgdata{1};
 
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

%     for i=1:length(cells)
    for n=1:num
        x=randi([1 (len-1)]);
        y=randi([1 (r-1)]);
        z=randi([1 (r-1)]);
        
%         cell=cells{i};
        while img{z}(x,y)==0
            x=randi([1 (len-1)]);
            y=randi([1 (r-1)]);
        end
        xy=[x,y];
        rna=rnaodna(x,y,len,r,sz,img,z);%,cells{i});
        for m=1:length(img)
            img{m}(rna{m}>0)=rna{m}(rna{m}>0);
        end
    end
    for m=1:length(img)
        img{m}(img{m}==1)=0;
    end
    


%     end
    
    imgdata={img,dim};
end
function pts=rnaodna(x,y,len,height,size,cell,z)
    ls{length(cell)}=[];
    u(1:len,1:height)=0;
    for i=1:size
        if z==1
            z=z+1;
        elseif z==height
            z=z-1;
        end
        
        while cell{z}(x,y)==0 && y>height/2
            y=y-1;
        end
        while cell{z}(x,y)==0 && y<height/2
            y=y+1;
        end
        
        if  x==1
            x=x+1;
        elseif y==1
            y=y+1;

        elseif y==height-1
            y=y-1;
        elseif x==len-1
            x=x-1;
        end
        
        o=randi([1 6]);
        if  o==1 
            x=x+1;
        elseif o==2
            y=y+1;
        elseif o==3
            z=z+1;
            
        elseif o==4 
            y=y-1;
        elseif o==5
            x=x-1;
        elseif o==6
            z=z-1;
            
        end
        u(x,y)=u(x,y)+10;
        ls{z}=u;
    end
    pts=ls;
end 