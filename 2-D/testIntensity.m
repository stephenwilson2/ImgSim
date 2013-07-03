function testIntensity()
    %% testIntensity
    clear all
    close all

    imgnum=100;
    
    % Default values
    numofcells=1;
    nmperpixel=1;

    %Define the height and length of the cells here in nanometers
    h=500; %nm
    l=2000; %nm

    %The number of molecules to measure
    lsofnumofmol=round(linspace(50,400,imgnum));
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

    try
        load('TestIntensity2-D.mat')
    catch
        tic
        imgdata=drawEcoli(k,numofcells,l,h,steps,'no');
        
        tmpimgdata=imgdata;
        if length(imgdata)>1
            
            datals=cell(imgnum);
            fli='TestIntensity_gray_coarsen';
            z=0;
            for numofmol=lsofnumofmol
                z=z+1;
                z
                imgdata=tmpimgdata;
                i=num2str(numofmol);
                cellnum=num2str(z);
                
                fl=strcat(fli,cellnum,'_',i,'.fig');
                
                imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
                %  wopsf=imgdata{5};
                imgdata=ovlay(imgdata,imgdata{1},imgdata{5});
                
                imgdata{6}=psf(imgdata{6},fluorvar);
                
                imgdata=coarsen(imgdata,nmperpixel,64);
                %             figure(z);
                %             imagesc(imgdata{5}{1});
                %             axis equal;
                %             tic
                %             graph(imgdata)
                %             saveas(gcf, fl)
                %             close all;
                %             toc
                datals{z}=imgdata;
            end
            save('TestIntensity2-D.mat','-v7.3','datals','lsofnumofmol');
        end
        toc
    end
    analyze(datals,lsofnumofmol);
    
end

function analyze(data,lsnum)
    pairpsf(length(data),2)=0;
    for i=1:length(data)
        V=var(data{i}{6}(:));
        n=mean(data{i}{6}(:));
        pairpsf(i,1)=n;
        pairpsf(i,2)=V;
    end
    pairwopsf(length(data),2)=0;
    for i=1:length(data)
        V=var(data{i}{5}{1}(:));
        n=mean(data{i}{6}(:));
        pairwopsf(i,1)=n;
        pairwopsf(i,2)=V;
    end
    
    %with PSF    
    figure(74);
    subplot(1,2,1);
    [p,s]=polyfit(pairpsf(:,1), pairpsf(:,3),1);
    y=pairpsf(:,3);
    yfit = polyval(p,pairpsf(:,1));
    R2psf = corrcoef(pairpsf(:,3), yfit);    
    hold all;
    plot(pairpsf(:,1),pairpsf(:,3),'color','blue');
    plot(pairpsf(:,1),yfit,'color', 'red');
    hold off;
    title('Variance compared to number of molecules',...
        'FontWeight','bold')
    xlabel('Number of molecules')
    ylabel('Variance')

    n1=sprintf('Fit-Slope: %d, R^2: %d', p(1),R2psf(1,2));
    legend('Simulation with PSF',n1)
    

    %without PSF
    subplot(1,2,2);
    [p,s]=polyfit(pairwopsf(:,1), pairwopsf(:,3),1);
    y=pairwopsf(:,3);
    yfit = polyval(p,pairwopsf(:,1));
    R2wopsf = corrcoef(pairwopsf(:,3), yfit);
    hold all;
    plot(pairwopsf(:,1),pairwopsf(:,3),'color','blue');
    plot(pairwopsf(:,1),yfit,'color', 'red');
    hold off;
    title('Variance compared to number of molecules',...
        'FontWeight','bold')
    xlabel('Number of molecules')
    ylabel('Variance')

    n1=sprintf('Fit-Slope: %d, R^2: %d', p(1),R2wopsf(1,2));
    legend('Simulation without PSF',n1)

    saveas(gcf, 'TestIntensity.fig')
    
    save('TestIntensity','-append','pairpsf','pairwopsf')
end