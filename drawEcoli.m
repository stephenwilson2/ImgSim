function imgdata=drawEcoli (img,varargin)
%% Draws shapes that represent cells


    %Default values
    num = 5;
    l = 10;
    r = 30;
    steps = 1000;
    fix='no';
    imsize=size(img{1},1);
    
    % Sets defaults for optional inputs
    optargs = {num,r,l,steps,fix};
    
    %Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 5
        error('Takes at most 5 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    num = cell2mat(optargs(1));
    l = cell2mat(optargs(3));
    r = cell2mat(optargs(2));
    steps = cell2mat(optargs(4));
    fix = cell2mat(optargs(5));
    
    % Fixes or randomizes the locations of the cells
    
    if l<r
        tmp=r;
        r=l;
        l=tmp;
    end
%     
%     if strcmp(fix, 'no')== 1
%         n=[0 0];
%         while n(1)<num
%             randpair=randi([r imsize-r],1,2); %gets a random origin for a cell
%             ang = random('normal',180,90,1,1);
%             q={randpair, ang};
            q={}; %remove before uncommenting
            imgls=draw(img,q,l,r,steps);
            img=imgls{1};
%             if imgls{2}~=1 && n(1)==0
%                 w=randpair;
%                 a=ang;
%                 n=size(w);
%             elseif imgls{2}~=1
%                 w=[w;randpair];
%                 a=[a;ang];
%                 n=size(w);
%             elseif imgls{2}==1
%                 %'TAKE NOTE!'
%             end
%         end
%     else % Linearly spaces the cells on a diagnol in predicable places
%         f=num/5+3;
%         l=linspace(r,imsize-r,num+f);
%         l2=linspace(imsize-r,r,num+f);
%         randpair=[l2;l];
%         randpair=randpair';
%         ang(1:uint16(num+f))=30;
%         n=[0 0]; 
%         i=0;
%         while n(1)<num && i<floor(num+f)
%             i=i+1;
%             q={randpair(i,:), ang(i)};
%             imgls=draw(img,q,l,r,steps);
%             img=imgls{1};
%             if imgls{2}~=1 && n(1)==0
%                 w=randpair(i,:);
%                 a=ang(i);
%                 n=size(w);
%             elseif imgls{2}~=1
%                 w=[w;randpair(i,:)];
%                 a=[a;ang(i)];
%                 n=size(w);
%             elseif imgls{2}==1
%                 %'TAKE NOTE!'
%             end
%         end
% 
%     end
%     %imagesc(img);
%     imgdata=true;
%     if strcmp(fix, 'no')== 0
%         if i>=floor(num+f)
%             'could not draw'
%             imgdata=false;
%         end
%     end
%     if imgdata~=false
%         %Create individual cells in a cell list
         dim={l,r};
%         u(l,r)=0;
%         calc2 = uint32(calculateEllipse(l/2, r/2, l/2, r/2, 0, steps));
%         calc2(calc2==0)=1;
%         calc2=calc2';
%         for calc =calc2
%             u(calc(1),calc(2))=1;
%         end
%         u=imfill(u,'holes');
%         for i=(1:length(a))
%             cells(i)={u};
%         end
%         cells=cells';
        %Pass all information the the form of a cell list
        imgdata={img,dim};%,cells};
%     end
    

end

function imgls=draw(img,num,l,r,s)
%%Draws the cells. Takes the image and num, a cell with the coordinate pair 
%%in the first cell and the angles in the second. If redraw needed, it
%%returns a 1.
    xc=l;
    yc=r;
    zc=r;
    [x,y,z]=ellipsoid(xc,yc,zc,l,r,r,s);
    
    x=round(x);
    y=round(y);
    z=round(z);

    bi=img;
    redo=0;
    img=checkShape(img,{x,y,z});
    if img{1}==0
        redo=1;
        img=bi;
    else
        for p=1:length(img)
            img{p}=sparse(imfill(full(img{p}),'holes'));
            p
        end
    end
    imgls={img,redo};
end

function img=checkShape(img, pts)
%%Checks to make sure the cell is not outside the bounds of the img or 
%%overlapping with another cell. If it is, it returns 0. Takes the image 
%%and pts, coordinate pairs about the location of the cells

    n=0;
    imsize=size(img{1},1);
    x=pts{1};
    y=pts{2};
    z=pts{3};
%     for i=1:size(x,1)
%         for j=1:size(x,1)
%             if x(i,j)+1 == 0 || y(i,j)+1 == 0 || z(i,j)+1==0 %exceeds the bounds of the image
%                 n=n+1;
%             elseif x(i,j)+1 >= imsize || y(i,j)+1 >= imsize || z(i,j)+1>=imsize %exceeds the bounds of the image
%                 n=n+1;
%             end
%         end
%     end

    
    %funtion that transfers coord over for 3d
    for j=1:size(z,1)
        for e=1:size(z,1)
            img{z(j,e)+1}(x(j,e)+1,y(j,e)+1)=1;
        end
    end 
    
%     if n==0
%         A = uint16(zeros(imsize,imsize));
%         for pair = pts'
%             if pair(1)~=0 && pair(2)~=0 && pair(1)<imsize && pair(2)<imsize
%                 A(pair(1),pair(2)) = 1;
%             end
%         end
%         b = img(A==1);
%         s= sum(b);
%         if s>0
%             'There is overlap!';
%         end
%         
%         img(A==1) = 1;
% 
%     end
%     
    if n>0
        img{1}=0;
    end
end