function testRandSpotPositions()
%%Tests the randomness of the x and y values chosen for orgins of molcules.
%%It requires not inputs and will save data to a file called
%%'TestRandomOrigins.mat'. It will automatically load data from this file.
close all;
clear all;

datapts=50000;

%Define the height and length of the cells here in nanometers
h=50; %nm
l=200; %nm
bin1=h;
bin2=l;

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

molx=zeros(1,datapts);
moly=zeros(1,datapts);
cells=cell(1,datapts);
try
    load('TestRandomOrigins2-D.mat');
catch
    tic
    for o=1:datapts
        imgdata=drawEcoli(k,numofcells,l,h,steps,'no');
        cells{o}=imgdata{5}{1};
        imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
        p=imgdata{6}{1};
        molx(o)=p(1);
        moly(o)=p(2);
    end
    toc

    save('TestRandomOrigins2-D.mat','molx','moly','cells');
end


expect=[];
figure(1);
[f2,x2]=hist(molx,1:1:bin1);
bar(x2*10,f2*10/trapz(x2,f2))
hold on;
molx=sort(molx);
expect(1:datapts)=0;
for w=1:datapts
    cel=cells{w};
    expect(w)=(sum(cel(molx(w),:)/sum(sum(cel))));
end

expect=[molx *10;expect*10];
plot(expect(1,:),expect(2,:),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen X-values',... 
  'FontWeight','bold')
xlabel('X (nm)')
ylabel('Probability')
saveas(gcf, 'testhistmolx.fig')






expect=[];
figure(2);
[f3,x3]=hist(moly,1:1:bin2);
bar(x3*10,f3*10/trapz(x3,f3))
hold on;
moly=sort(moly);
expect(1:datapts,1)=0;
for w=1:datapts
    cel=cells{w};
    expect(w)=(sum(cel(:,moly(w))/sum(sum(cel))));
end
expect=expect';
expect=[moly *10;expect*10];
plot(expect(1,:),expect(2,:),'color','red')
hold off;
title('Distribution of a Large Number of Randomly Chosen Y-values',... 
  'FontWeight','bold')
xlabel('Y (nm), Resolution 10nm/pixel')
ylabel('Probability')
saveas(gcf, 'testhistmoly.fig')


end