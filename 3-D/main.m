%% main
clear all
close all
ip = 'C:/Users/sw5/ImgSim'; % make less specific later
addpath(ip);

% Default values
numofcells=1;
nmperpixel=1;

%Define the height and length of the cells here in nanometers
r=250; %nm
l=1000; %nm

r=r/nmperpixel;
l=l/nmperpixel;

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

num=5*(7^.5)*(1-power(cos(a),3/2));
de=(6^.5)*n*k*(4*power(cos(a),5)-25*power(cos(a),7/2)+42*power(cos(a),5/2)...
    -25*power(cos(a),3/2)+4)^.5;
fluorvarz=num/de;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling

steps=2000; %Calculated of nmperpixel and cell size

%Sets the image size according to the number of cells and the cell size
if r>l
    imgsize=2*r*numofcells;
else
    imgsize=2*l*numofcells;
end

k={};
for i=1:r*2
    k{i}=sparse(imgsize,r*2+1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try 
    load('main.mat')
catch
    tic
    imgdata=drawEcoli(k,numofcells,r,l,steps,'no');
    toc
    save('main','imgdata')
end
% img=imgdata{1};
% for p=1:length(img)/2
%     figure(p);imagesc(img{p});
%     axis equal;
% end

tic
imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
toc


img=imgdata{1};
% for p=1:length(img)
%     if sum(sum(img{p}))>0
%         figure(p*10);imagesc(img{p});
%     end
% end

tic
imgdata=psf(imgdata,fluorvar,fluorvarz);
toc


img=imgdata{1};
save('main2','imgdata','-v7.3')

for k=1:length(img)
    if sum(sum(img{k}))>0
        figure(k);imagesc(img{k});
    end
end


% for p=1:length(img)
%       figure(p);imagesc(img{p});
% end


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