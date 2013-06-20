%% main
clear all
close all
ip = 'C:/Users/sw5/ImgSim'; % make less specific later
addpath(ip);

% Default values
numofcells=1;
nmperpixel=10;

%Define the height and length of the cells here in nanometers
r=25; %nm
l=100; %nm


%The number of molecules to measure
numofmol=1;
sizeofmol=1; % This number is represnetative of the nm of molecule 
% per molecule

%Fluorescene Variables
emwave=520; %nm
n=1.515; %refractive index for immersion oil
NA=1.4; %numerical apperature
a=asin(NA/n);
k=(2*pi/emwave);

num=4-7*power(cos(a),3/2)+3*power(cos(a),7/2);
de=7*(1-power(cos(a),3/2));
fluorvar=1/n/k*power(num/de,-0.5);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling

steps=l*10; %Calculated of nmperpixel and cell size

%Sets the image size according to the number of cells and the cell size
if r>l
    imgsize=2*r*numofcells;
else
    imgsize=2*l*numofcells;
end
% if numofcells==1
%     imgsize=round(imgsize*1.3);
% end
k={};
for i=1:r*2+1
    k{i}=sparse(imgsize,r*2+1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
imgdata=drawEcoli(k,numofcells,r,l,steps,'no');
toc

img=imgdata{1};
for p=1:length(img)
    figure(p);imagesc(img{p});
end

tic
imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
toc

img=imgdata{1};
for p=1:length(img)
    figure(p*10);imagesc(img{p});
end

tic
imgdata=psf(imgdata,fluorvar);
toc

img=imgdata{1};
for p=1:length(img)
    figure(p*100);imagesc(img{i});
end


%    
%     
%     tic
%     graph(imgdata)
%     toc
    
%     tic
%     imgdata=coarsen(imgdata,nmperpixel,64);
%     toc
%     
%     tic
%     graph(imgdata)
%     toc
% end