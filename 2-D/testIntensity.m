function testIntensity()
    %% testIntensity
    clear all
    close all
    ip = 'C:/Users/sw5/ImgSim/2-D'; % make less specific later
    addpath(ip);
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   load('TestIntensity.mat')
    imgnum=5;
    
    % Default values
    numofcells=1;
    nmperpixel=1;

    %Define the height and length of the cells here in nanometers
    h=500; %nm
    l=2000; %nm

    %The number of molecules to measure
    lsofnumofmol=round(linspace(50,200,imgnum));
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
    toc
    tmpimgdata=imgdata;
    if length(imgdata)>1
        
        datals=cell(imgnum);
        fli='TestIntensity_gray_coarsen';
        z=0;
        for numofmol=lsofnumofmol
            z=z+1;
            imgdata=tmpimgdata;
            i=num2str(numofmol);
            cellnum=num2str(z);

            fl=strcat(fli,cellnum,'_',i,'.fig');
            
            fprintf('\n%s\n', 'Populating Molecules');
            tic
            imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
            toc

            fprintf('\n%s\n', 'Overlaying Molecules with mask');
            tic
            imgdata=ovlay(imgdata,imgdata{1},imgdata{5});
            toc

            fprintf('\n%s\n', 'Applying PSF directly to molecules (equiv. 1:1 binding)');
            tic
            imgdata{6}=psf(imgdata{6},fluorvar);
            toc

            fprintf('\n%s\n', 'Coarsening');

            tic
            imgdata=coarsen(imgdata,nmperpixel,64);
            toc
            
            tic
            graph(imgdata)
            saveas(gcf, fl)
            close all;
            toc
            datals{z}=imgdata;
        end
        save('TestIntensity.mat','datals');
    end
    analyze(datals,lsofnumofmol);
end

function analyze(data,lsnum)
    pair(length(data),2)=0;
    for i=1:length(data)
        V=var(data{i}{6});
        numofmol=lsnum(i);
        V=sum(sum(V)); %%%%%%%%%not right?
        V=V^2;
        if i==1
            pair=[numofmol V];
        else
            pair=[pair; [numofmol V]];
        end
    end
    p=polyfit(pair(:,1), pair(:,2),1);
    k=sprintf('The slope is: %d', p(1));
    yfit = polyval(p,pair(:,1));
    figure(72);
    hold all;
    plot(pair(:,1),pair(:,2),'color','blue');
    plot(pair(:,1),yfit,'color', 'red');
    hold off;
    title('Variance^2 compared to number of molecules',...
        'FontWeight','bold')
    xlabel('Number of molecules')
    ylabel('Variance^2')
    text(100,200,k);
    saveas(gcf, 'TestIntensity.fig')
end