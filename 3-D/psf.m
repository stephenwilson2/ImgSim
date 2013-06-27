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
    
    RO{5}=0;
    n=0;
     

    
  % Z PSF
  for m1=1:length(img)
        if sum(sum(img{m1}))>0
            val=img{m1}(img{m1}>0);
            for m2=1:length(img)
                y=gaussDistribution(m2,m1,s2);
                tmp{m2}(img{m1}>0)=y*val;
                tmp{m2}(img{m1}>0)
            end
        end
  end
    
  for m3=1:length(img)
      img{m3}(tmp{m3}>0)=tmp{3}(tmp{3}>0);
  end
  
    
%     for i=1:length(img)
%     %matrix of the gaussian filter's kernal
%         if sum(sum(img{i}))>0
%             n=n+1;
%             h=size(img{i},1);
%             l=size(img{i},2);
%             if h>l
%                 ms=[h*2,h*2];
%             else
%                 ms=[l*2 l*2];
%             end
%             p=img{i};
%             RO{n}=i;
%             
%             f=fspecial('gaussian',ms,s);
%             img2=imfilter(full(p),f);
% 
%             img{i}=img2*10000;
%         end
%     end
    imgdata={img, imgdata{2},RO};
end