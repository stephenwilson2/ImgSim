function testRandSpotPositions()
datapts=1000;

%Define the height and length of the cells here in nanometers
h=50; %nm
l=200; %nm

%The number of molecules to measure
numofmol=1;
sizeofmol=1; % This number is represnetative of the nm of molecule 
% per molecule

numofcells=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling

steps=l*10; %Calculated of nmperpixel and cell size

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
angles=zeros(1,datapts);
molx=zeros(1,datapts);
moly=zeros(1,datapts);

tic
for o=1:datapts    
    imgdata=drawEcoli(k,numofcells,l,h,steps,'no');
    imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
    p=imgdata{6}{1};
    molx(o)=p(1);
    moly(o)=p(2);
    angles(o)=imgdata{2};
end
toc


save('TestRandomOrigins.mat','molx','moly','angles');
figure(1);
hist(angles) %angles hist
saveas(gcf, 'histangles.fig')
figure(2);
hist(molx)
saveas(gcf, 'histmolx.fig')
figure(3);
saveas(gcf, 'histmoly.fig')
hist(moly)

end