%% main
clear all
close all
ip = 'C:/Users/sw5/ImgSim'; % make less specific later
addpath(ip);

% Default values
numofcells=1;
nmperpixel=10;

%Define the height and length of the cells here in nanometers
r=5; %nm
l=20; %nm


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

steps=l*nmperpixel*10; %Calculated of nmperpixel and cell size

%Sets the image size according to the number of cells and the cell size
if r>l
    imgsize=2*r*numofcells;
else
    imgsize=2*l*numofcells;
end
if numofcells==1
    imgsize=round(imgsize*1.3);
end
k={};
for i=1:imgsize
    k{i}=sparse(imgsize,imgsize);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
imgdata=drawEcoli(k,numofcells,r,l,steps,'no');
%  drawEcoli inputs:1)16-bit image matrix
%                   2)number of cells to try and put in*
%                   3)height of cell (in px)*
%                   4)length of cell (in px)*
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
toc
% if length(imgdata)>1
%     imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
%     %% Populates cells with molecules of some shape
%     %populateMolecules inputs:  1)imagedata
%     %                           2)copies of molecules*
%     %                           3)size of molecules*
%     %                           * denotes optional input
%     %                  output:
%     %                           1)the cell mask, 16-bit image matrix
%     %                           2)angles of the cells
%     %                           3)origins of the cells
%     %                           4)dimensions of the cell (in a cell type: len, height)
%     %                           5)the molecules channel (in a cell type)
%     tic
%     imgdata=ovlay(imgdata,imgdata{1},imgdata{5});
%     toc
%     
%     
%     tic
%     imgdata{6}=psf(imgdata{6},fluorvar);
%     toc
%    
%     tic
%     imgdata{6}=imgdata{6}+imgdata{1};
%     toc
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