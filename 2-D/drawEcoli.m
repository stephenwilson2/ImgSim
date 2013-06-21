function imgdata=drawEcoli (img,varargin)
%% Draws shapes that represent cells
% %drawEcoli inputs:1)16-bit image matrix
%                   2)number of cells to try and put in*
%                   3)height of cell*
%                   4)length of cell*
%                   5)number of points in shape (keep high ~200 for small 
%                     cells and ~2000 for large cells)*
%                   6)use random origins keep blank or fix the origins:
%                     'fix'*
%                   * denotes optional input
%          output: 
%                   1)the cell mask, 16-bit image matrix
%                   2)angles of the cells
%                   3)origins of the cells
%                   4)dimensions of the cell (in a cell type: len, height)
%                   5)the cells

    %Default values
    num = 5;
    len = 10;
    height = 30;
    steps = 1000;
    fix='no';
    t=size(img);
    imsize=t(1);
    
    % Sets defaults for optional inputs
    optargs = {num,height,len,steps,fix};
    
    %Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 5
        error('Takes at most 5 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    num = cell2mat(optargs(1));
    len = cell2mat(optargs(3));
    height = cell2mat(optargs(2));
    steps = cell2mat(optargs(4));
    fix = cell2mat(optargs(5));
    
    % Fixes or randomizes the locations of the cells
    
    if len<height
        tmp=height;
        height=len;
        len=tmp;
    end
    
    if strcmp(fix, 'no')== 1
        n=[0 0];
        while n(1)<num
            randpair=randi([1 imsize],1,2); %gets a random origin for a cell
            ang = random('normal',180,90,1,1);
            q={randpair, ang};
            imgls=draw(img,q,len,height,steps);
            img=imgls{1};
            if imgls{2}~=1 && n(1)==0
                w=randpair;
                a=ang;
                n=size(w);
            elseif imgls{2}~=1
                w=[w;randpair];
                a=[a;ang];
                n=size(w);
            elseif imgls{2}==1
                %'TAKE NOTE!'
            end
        end
    else % Linearly spaces the cells on a diagnol in predicable places
        f=num/5+3;
        l=linspace(height,imsize-height,num+f);
        l2=linspace(imsize-height,height,num+f);
        randpair=[l2;l];
        randpair=randpair';
        ang(1:uint16(num+f))=30;
        n=[0 0]; 
        i=0;
        while n(1)<num && i<floor(num+f)
            i=i+1;
            q={randpair(i,:), ang(i)};
            imgls=draw(img,q,len,height,steps);
            img=imgls{1};
            if imgls{2}~=1 && n(1)==0
                w=randpair(i,:);
                a=ang(i);
                n=size(w);
            elseif imgls{2}~=1
                w=[w;randpair(i,:)];
                a=[a;ang(i)];
                n=size(w);
            elseif imgls{2}==1
                %'TAKE NOTE!'
            end
        end

    end
    %imagesc(img);
    imgdata=true;
    if strcmp(fix, 'no')== 0
        if i>=floor(num+f)
            'could not draw'
            imgdata=false;
        end
    end
    if imgdata~=false
        %Create individual cells in a cell list
        dim={len,height};
        u(len,height)=0;
        calc2 = round(spherocylinder(len/2+1, height/2, len/2, height/2, 0, steps));
        calc2(calc2==0)=1;
        calc2=calc2';
        for calc =calc2
            u(calc(1),calc(2))=1;
        end
        u=imfill(u,'holes');
        for i=(1:length(a))
            cells(i)={u};
        end
        cells=cells';
        %Pass all information the the form of a cell list
        
        imgdata={img,a,w,dim,cells};
    end
    

end

function imgls=draw(img,num,l,h,s)
%%Draws the cells. Takes the image and num, a cell with the coordinate pair 
%%in the first cell and the angles in the second. If redraw needed, it
%%returns a 1.
    calc = spherocylinder(num{1}(1)+1, num{1}(2), l/2, h/2, num{2}, ...
        s);
    calc=round(calc);
    bi=img;
    redo=0;
    img=checkShape(img,calc);
    if img==0
        redo=1;
        img=bi;
    else
        img=imfill(img,'holes');
    end
    imgls={img,redo};
end

function img=checkShape(img, pts)
%%Checks to make sure the cell is not outside the bounds of the img or 
%%overlapping with another cell. If it is, it returns 0. Takes the image 
%%and pts, coordinate pairs about the location of the cells

    n=0;
    t=size(img);
    imsize=t(1);
    for pt = pts'
        x=pt(1);
        y=pt(2);
        if x == 0 || y == 0 %exceeds the bounds of the image
            n=n+1;
        elseif x >= imsize || y >= imsize %exceeds the bounds of the image
            n=n+1;
        end
    end
    
    if n==0
        A = uint16(zeros(imsize,imsize));
        for pair = pts'
            if pair(1)~=0 && pair(2)~=0 && pair(1)<imsize && pair(2)<imsize
                A(pair(1),pair(2)) = 1;
            end
        end
        b = img(A==1);
        s= sum(b);
        if s>0
            'There is overlap!';
        end
        
        img(A==1) = 1;

    end

    if n>0 || s>0
        img=0;
    end
end