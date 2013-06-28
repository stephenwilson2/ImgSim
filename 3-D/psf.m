function imgdata=psf(imgdata,varargin)
%% Applies psf in cells
%fluorescence inputs:  1)image matrix
%                      2)size of varience (in Gaussian varience)*
%                      3)matrix of the spread of the gaussian filter (make
%                      big enough to encompass the image)
%                      * denotes optional input
%             output: 
%                      1)image matrix
    %Default values
    s=.1; % size of fluorescence (in terms of gaussian varience)
    s2=80;
    img=imgdata{1};
    h=size(img{1},1);
    l=size(img{2},2);
    
    
    % Sets defaults for optional inputs
    optargs = {s,s2};
    
    % Checks to ensure  2 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 2
        error('Takes at most 2 optional inputs');
    end
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    s = cell2mat(optargs(1));
    s2= cell2mat(optargs(2));
    

    n=0;
 
    
    for i=1:length(img)
    %matrix of the gaussian filter's kernal
        if sum(sum(img{i}))>0
            su=ceil(sum(sum(img{i}))/10);
            if h<l
                p=zeros(su,h);
            else
                p=zeros(su,l);
            end
            
            if h<l
                ms=[su,h*2];
            else
                ms=[su, l*2];
            end
            
            f=fspecial('gaussian',ms,s2);
            
            
            [row,col,v]=find(img{i});
            for o=1:su
                p(o,i)=v(o)*1000;
            end          
            img2=imfilter(p,f);

            for o=1:length(img)
                tmp{o}(row, col)=round(img2(o));%% adjust for multiple mol
            end
        end
    end
    for m3=1:length(img)
        [row,col,v]=find(tmp{m3});
        if v>0
            img{m3}(row,col)=v;
        end
    end   
    

    
%     % Z PSF
%     for m1=1:length(img)
%         if sum(sum(img{m1}))>0
%             val=img{m1}(img{m1}>0);
%             for m2=1:length(img)
%                 y=gaussDistribution(m2,m1,s2);
%                 tmp{m2}(img{m1}>0)=y*val*100;
% %                 tmp{m2}(img{m1}>0)
%             end
%         end
%     end
%     
%     for m3=1:length(img)
%         [row,col,v]=find(tmp{m3});
%         if v>0
%             img{m3}(row,col)=round(v);
%         end
%     end   

%     for o=1:length(img)
%         o
%         if sum(sum(img{o}))>0
%             [row col v]=find(img{o});
%             for r=1:length(row)
%                 for o2=1:size(img{o},1)
%                     y=gaussDistribution(o2,row(r),s);
%                     tmp{m2}(o2,col(r))=y*v(r)*100;
%                 end
%                 for o2=1:size(img{o},1)
%                     o2
%                     for o3=1:size(img{o},2)
%                        y=gaussDistribution(o3,col(r),s);
%                        tmp{m2}(row(r),o2)=y*v(r)*100;
%                     end
%                 end
%                 r
%             end
% %                 tmp{m2}(img{m1}>0)
%         end
%     end
%    
%     for m3=1:length(img)
%         [row,col,v]=find(tmp{m3});
%         if v>0
%             img{m3}(row,col)=round(v);
%         end
%     end   
    
    
%     NUM=0;
%     for o=1:length(img)
%         if sum(sum(img{o}))>0
%             NUM=NUM+1;
%         end
%     end
%     NUM

    %matrix of the gaussian filter's kernal    
%     h=size(img{1},1);
%     l=size(img{1},2);
    if h>l
        ms=[h h];
    else
        ms=[l l];
    end
    f=fspecial('gaussian',ms,s);

    for i=1:length(img)
        if sum(sum(img{i}))>0
            n=n+1
            p=img{i};
            tic
            img2=imfilter(full(p),f);
            toc
            img{i}=img2*1000;
        end
    end
    
    
    
    imgdata={img, imgdata{2}};
end