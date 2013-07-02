function imgdata=psfz(imgdata,varargin)
%% Applies psf in cells
%fluorescence inputs:  1)image matrix
%                      2)size of varience (in Gaussian varience)*
%                      3)matrix of the spread of the gaussian filter (make
%                      big enough to encompass the image)
%                      * denotes optional input
%             output: 
%                      1)image matrix
    %Default values
    s=80; % size of fluorescence (in terms of gaussian varience)


    img=imgdata{1};
    h=size(img{1},1);
    l=size(img{2},2);
    
    
    % Sets defaults for optional inputs
    optargs = {s};
    
    % Checks to ensure  1 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 1
        error('Takes at most 1 optional input');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    s = cell2mat(optargs(1));
 
    if h<l
        ms=[h*4,1];
    else
        ms=[l*4,1];
    end
    
    f=fspecial('gaussian',ms,s);
    size(f)
    for e=1:length(img)
        tmp{e}=zeros(size(img{e}));
    end
    
    for i=1:length(img) % per z plane

    %matrix of the gaussian filter's kernal
        if sum(sum(img{i}))>0
            su=ceil(sum(sum(img{i}))/10);
 
            if h<l
                p=zeros(su,h);
  
            else
                p=zeros(su,l);
            end
            
            [row,col,v]=find(img{i});
            for o=1:length(v)
                p(o,i)=v(o)*1000;
                size(p),size(v)
                i
                img2=imfilter(p(o,:),f);
                size (img2)
                for m=1:length(p)
                    tmp{m}(row, col)=round(img2(m));
                end
                
            end
        end
    end
    for m3=1:length(img)
        img{m3}(tmp{m3}>0)=tmp{m3}(tmp{m3}>0);
%         [row,col,v]=find(tmp{m3});
%         if v>0
%             img{m3}(row,col)=v(;
%         end
    end   


    
    imgdata={img, imgdata{2},imgdata{3},imgdata{4}};
end