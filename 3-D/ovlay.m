function composite=ovlay(bi,oi)
%%ovlay inputs:  1)base image
%                2)overlay image
%      output: 
%               1)the composite image

    mask=bi;
    img=oi;

    tmp=zeros(size(img,1),size(img,2));
    tmp(img>0)=img(img>0);

    tmp(mask>0)=img(mask>0)+mask(mask>0)*10;

    composite=tmp;
end