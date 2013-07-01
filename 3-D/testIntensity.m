function testIntensity()
    %% testIntensity
    clear all
    close all
    ip = 'C:/Users/sw5/ImgSim'; % make less specific later
    addpath(ip);
    imgnum=10;
    
    
    % Default values
    numofcells=1;
    nmperpixel=64;
    numofslice=8; %%%%even only!
    numofslice=2*round(numofslice/2);
    
    %Define the height and length of the cells here in nanometers
    r=250; %nm
    l=1000; %nm
    
    r=round(r/nmperpixel);
    l=round(l/nmperpixel);

    %The number of molecules to measure
    lsofnumofmol=round(linspace(50,400,imgnum)/nmperpixel);
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


    tic
    imgdata=drawEcoli(k,numofcells,l,r,steps,'no');

    tmpimgdata=imgdata;
    if length(imgdata)>1
        
        datals=cell(imgnum,1);
        fli='TestIntensity_gray_coarsen';
        u=0;
        for numofmol=lsofnumofmol
            u=u+1;
            u
            imgdata=tmpimgdata;
            i=num2str(numofmol);
            cellnum=num2str(u);

            fl=strcat(fli,cellnum,'_',i,'.fig');

            imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
            

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
            end
            
            datals{u}=im;
        end
        save('TestIntensity.mat','-v7.3','datals','lsofnumofmol','imgdata','im','numofslice','mask');
    end
    analyze(datals,lsofnumofmol);
    toc
end

function analyze(data,lsnum)

    pairpsf{length(data{1})}=[];
  
    for inum=1:length(data{1})
        for zplane=1:length(data{1})
            V=var(data{inum}{zplane}(:));
            numofmol=lsnum(inum);
            pairpsf{inum}(zplane)=[numofmol,V];
        end
        
    end

    
    %with PSF    
    figure(72);
    [p,s]=polyfit(pairpsf(:,1), pairpsf(:,2),1);
    y=pairpsf(:,2);
    yfit = polyval(p,pairpsf(:,1));
    R2psf = corrcoef(pairpsf(:,2), yfit);    
    hold all;
    plot(pairpsf(:,1),pairpsf(:,2),'color','blue');
    plot(pairpsf(:,1),yfit,'color', 'red');
    hold off;
    title('Variance compared to number of molecules',...
        'FontWeight','bold')
    xlabel('Number of molecules')
    ylabel('Variance')
    n1=sprintf('Fit-Slope: %d, R^2: %d', p(1),R2psf(1,2));
    legend('Simulation with PSF',n1)
    
% 
%     subplot(1,4,2);
%     [p,s]=polyfit(pairpsf(:,1), pairpsf(:,3),1);
%     string='';
%     for ew=1:length(p)
%         k=sprintf('X^%d', length(p)-ew);
%         string=strcat('+',num2str(p(ew)),'*',k,string);
%     end
%     k=sprintf('The equation is: %s', string);
%     y=pairpsf(:,3);
%     yfit = polyval(p,pairpsf(:,1));
%     R2psf = corrcoef(pairpsf(:,3), yfit);    
%     hold all;
%     plot(pairpsf(:,1),pairpsf(:,3),'color','blue');
%     plot(pairpsf(:,1),yfit,'color', 'red');
%     hold off;
%     title('Variance compared to number of molecules',...
%         'FontWeight','bold')
%     xlabel('Number of molecules')
%     ylabel('Variance')
%     n1=sprintf('Fit-Slope: %d, R^2: %d', p(1),R2psf(1,2));
%     legend('Simulation with PSF',n1)
%     
%     
%     %without PSF
%     subplot(1,4,3);
%     [p,s]=polyfit(pairwopsf(:,1), pairwopsf(:,3),3);
%     y=pairwopsf(:,3);
%     yfit = polyval(p,pairwopsf(:,1));
%     R2wopsf = corrcoef(pairwopsf(:,3), yfit);
%     hold all;
%     plot(pairwopsf(:,1),pairwopsf(:,3),'color','blue');
%     plot(pairwopsf(:,1),yfit,'color', 'red');
%     hold off;
%     title('Variance compared to number of molecules',...
%         'FontWeight','bold')
%     xlabel('Number of molecules')
%     ylabel('Variance')
%     n1=sprintf('Fit-Slope: %d, R^2: %d', p(1),R2wopsf(1,2));
%     legend('Simulation without PSF',n1)
%     
%     
%     subplot(1,4,4);
%     [p,s]=polyfit(pairwopsf(:,1), pairwopsf(:,3),1);
%     string='';
%     for ew=1:length(p)
%         k=sprintf('X^%d', length(p)-ew);
%         string=strcat('+',num2str(p(ew)),'*',k,string);
%     end
%     k=sprintf('The equation is: %s', string);
%     y=pairwopsf(:,3);
%     yfit = polyval(p,pairwopsf(:,1));
%     R2wopsf = corrcoef(pairwopsf(:,3), yfit);
%     hold all;
%     plot(pairwopsf(:,1),pairwopsf(:,3),'color','blue');
%     plot(pairwopsf(:,1),yfit,'color', 'red');
%     hold off;
%     title('Variance compared to number of molecules',...
%         'FontWeight','bold')
%     xlabel('Number of molecules')
%     ylabel('Variance')
%     n1=sprintf('Fit-Slope: %d, R^2: %d', p(1),R2wopsf(1,2));
%     legend('Simulation without PSF',n1)
%     
%     saveas(gcf, 'TestIntensity.fig')
%     
%     save('TestIntensity','-append','pairpsf','pairwopsf')
end