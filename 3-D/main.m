%% main
clear all
close all
ip = 'C:/Users/sw5/ImgSim'; % make less specific later
addpath(ip);

% Default values
numofcells=1;
nmperpixel=1;
numofslice=8; %%%%even only!
numofslice=2*round(numofslice/2);

%Define the height and length of the cells here in nanometers
r=250; %nm
l=1000; %nm

r=round(r/nmperpixel);
l=round(l/nmperpixel);

%The number of molecules to measure
numofmol=200;
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

num=5*(7^.5)*(1-power(cos(a),3/2));
de=(6^.5)*n*k*(4*power(cos(a),5)-25*power(cos(a),7/2)+42*power(cos(a),5/2)...
    -25*power(cos(a),3/2)+4)^.5;
fluorvarz=num/de;

fluorvar=fluorvar/nmperpixel;
fluorvarz=fluorvarz/nmperpixel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling

steps=20000; %Calculated of nmperpixel and cell size

%Sets the image size according to the number of cells and the cell size
if r>l
    imgsize=2*r*numofcells*1.3;
else
    imgsize=2*l*numofcells*1.3;
end

k={};
for i=1:r*2
    k{i}=sparse(round(imgsize),round((r*2+1)*2.5));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    load('main2')
catch
    try
        load('main')
    catch
        tic
        imgdata=drawEcoli(k,numofcells,r,l,steps,'no');
        toc
        save('main','-v7.3','imgdata')
    end
    
    tic
    imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
    toc
    
    tic
    imgdata=psfz(imgdata,fluorvarz);
    toc


    
    im{numofslice}=[];
    mask{numofslice}=[];
    n=0;
    slices=round(linspace(1,r*2,numofslice));
    for slice=slices
        n=n+1;
        imgdata=psfplane(imgdata,slice,fluorvar);
        im{n}=imgdata{1}{slice};
        mask{n}=imgdata{2}{slice};
    end
    
    save('main2','-v7.3','imgdata','im','numofslice','mask')
end


IM=[];
Mask=[];

for i=1:length(mask)-numofslice/2
    tmp=[mask{i}*100;mask{i+numofslice/2}*100];
    Mask=[Mask tmp];
end

for i=1:length(im)-numofslice/2
    tmp=[im{i};im{i+numofslice/2}];
    IM=[IM tmp];
end
IM=ovlay(Mask, IM);
figure(121);
imagesc(IM); axis equal;
slices=round(linspace(1,r*2,numofslice));
for i=1:length(im)-numofslice/2
    s=sprintf('z=%i nm',slices(i)*nmperpixel);
    s2=sprintf('z=%i nm',slices(i+numofslice/2)*nmperpixel);
    text(size(im{i},1)/2*i-size(im{i},1)/2,0-size(IM,2)/15, s, 'FontSize',18);
    text(size(im{i},1)/2*i-size(im{i},1)/2,size(IM,2)+size(IM,2)/10, s2, 'FontSize',18);
end

delete('main.mat','main2.mat')
