%% main
clear all
close all
ip = 'C:/Users/sw5/ImgSim/2-D'; % make less specific later
addpath(ip);

% Default values
numofcells=1;
nmperpixel=1;

%Define the height and length of the cells here in nanometers
h=500; %nm
l=2000; %nm

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling
steps=l*nmperpixel*10; %Calculated of nmperpixel and cell size

%Sets the image size according to the number of cells and the cell size
if h>l
    imgsize=h*numofcells;
else
    imgsize=l*numofcells;
end
if numofcells==1
    imgsize=round(imgsize*1.3);
end

k(imgsize,imgsize) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s\n', 'Drawing mask');
tic
imgdata=drawEcoli(k,numofcells,l,h,steps,'no');
% %drawEcoli inputs:1)16-bit image matrix
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
if length(imgdata)>1
    fprintf('\n%s\n', 'Populating Molecules');
    tic
    imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
    toc
    %% Populates cells with molecules of some shape
    %populateMolecules inputs:  1)imagedata
    %                           2)copies of molecules*
    %                           3)size of molecules*
    %                           * denotes optional input
    %                  output:
    %                           1)the cell mask, 16-bit image matrix
    %                           2)angles of the cells
    %                           3)origins of the cells
    %                           4)dimensions of the cell (in a cell type: len, height)
    %                           5)the molecules channel (in a cell type)
    %                           6)the origins of the molecules
 
    %   Shows the cells prior to the PSF
%     for i=1:length(imgdata{5})
%         figure(i*1000);imagesc(imgdata{5}{i});
%         axis equal;
%     end 

    fprintf('\n%s\n', 'Overlaying Molecules with mask');
    tic
    imgdata=ovlay(imgdata,imgdata{1},imgdata{5});
    toc
    
% % %     figure(4);imagesc(imgdata{1});
% % %     figure(5);imagesc(imgdata{6});
    fprintf('\n%s\n', 'Applying PSF directly to molecules (equiv. 1:1 binding)');
    tic
    imgdata{6}=psf(imgdata{6},fluorvar);
    toc

%     tic
%     fprintf('\n%s\n', 'Overlaying Fluorescence');
%     imgdata{6}=imgdata{6}+imgdata{1};
%     toc

    fprintf('\n%s\n', 'Graphing');
    tic
    graph(imgdata)
    toc
    
    tic
    imgdata=coarsen(imgdata,nmperpixel,64);
    toc

    tic
    graph(imgdata)
    toc
end