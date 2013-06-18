%% Main
ip = 'C:/Users/sw5/ImgSim/old'; % make less specific later
addpath(ip);
%% If wanting to read in background
I=imread('Exmask.tif');
%%
k(538,472,3) = 0;
k= uint8(k);

imagesc(flipdim(k,1));
imshow(k);
hold on;

drawEcoli(10);


%bl(538,472,3)= 0;
%for p = img'
%    bl(uint16(p(1)),uint16(p(2)),:)=255;
%end
%se = strel('disk',5,0);
%for k=(1:50)
%    bl = imclose(bl,se);
%end
%imshow(bl);
%hold off;
