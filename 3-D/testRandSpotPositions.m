function testRandSpotPositions()
clear all
close all
ip = 'C:/Users/sw5/ImgSim'; % make less specific later
addpath(ip);
datapts=50;

% Default values
numofcells=1;
nmperpixel=10;

%Define the height and length of the cells here in nanometers
r=250; %nm
l=1000; %nm

r=round(r/nmperpixel);
l=round(l/nmperpixel);

%The number of molecules to measure
numofmol=10;
sizeofmol=1; % This number is represnetative of the nm of molecule 
% per molecule

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
    load('TestRandomOrigins.mat')
catch
    molz=[];
    molx=[];
    moly=[]; 
    tic
    for o=1:datapts
        imgdata=drawEcoli(k,numofcells,l,r,steps,'no');
        cell=imgdata{1};
        imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
        p=imgdata{4};
        molx=[molx; p(:,1)];
        moly=[moly; p(:,2)];
        molz=[molz; imgdata{5}];
    end
    toc
    save('TestRandomOrigins.mat','molx','moly','molz','cell');
end

%delete('TestRandomOrigins.mat');

xz=[molx,molz];
yz=[moly,molz];

xz=sortrows(xz);
yz=sortrows(yz);

expect=[];
figure(1);
[f,x]=hist(molz,min(molz):5:max(molz));
bar(x,f/trapz(x,f))
hold on;
molz=sort(molz);
expect(1:datapts*numofmol,1)=1/datapts; %not right

expect=[molz ,expect];

plot(expect(:,1),expect(:,2),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen Z',... 
  'FontWeight','bold')
xlabel('Z (nm)')
ylabel('Probability')
saveas(gcf, 'testhistz.fig')


expect=[];
figure(2);
[f2,x2]=hist(xz(:,1),min(xz(:,1)):5:max(xz(:,1)));
bar(x2,f2/trapz(x2,f2))
hold on;

expect(1:datapts*numofmol)=0;
for w=1:datapts*numofmol
    expect(w)=sum(cell{xz(w,2)}(xz(w,1),:))/sum(sum(cell{xz(w,2)})); % not right
end
expect=expect';
expect=[xz(:,1),expect];

plot(expect(:,1),expect(:,2),'-r')
hold off;
title('Distribution of a Large Number of Randomly Chosen X-values',... 
  'FontWeight','bold')
xlabel('X (nm)')
ylabel('Probability')
saveas(gcf, 'testhistx.fig')


expect=[];
figure(3);
[f3,x3]=hist(yz(:,1),min(yz(:,1)):5:max(yz(:,1)));
bar(x3,f3/trapz(x3,f3))
hold on;

expect(1:datapts*numofmol,1)=0;
for w=1:datapts*numofmol
    expect(w)=sum(cell{yz(w,2)}(:,yz(w,1)))/sum(sum(cell{yz(w,2)})); % not right
end

expect=[yz(:,1) ,expect];
plot(expect(:,1),expect(:,2),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen Y-values',... 
  'FontWeight','bold')
xlabel('Y (nm)')
ylabel('Probability')
saveas(gcf, 'testhisty.fig')


end