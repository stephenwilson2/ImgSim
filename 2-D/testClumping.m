function testClumping ()
    %% testClumping
    clear all
    close all
    ip = 'C:/Users/sw5/ImgSim/2-D'; % make less specific later
    addpath(ip);

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
    imgdata=drawEcoli(k,numofcells,l,h,steps,'no',angle,shape);
    toc
    tmpimgdata=imgdata;
    if length(imgdata)>1
        data=[];
        fli='TestNumofMolClumping_gray_coarsen';

        for numofmol=lsofnumofmol
            imgdata=tmpimgdata;
            i=num2str(numofmol);
            fl=strcat(fli,i,'.fig');
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
            data=[data imgdata{6}];
            toc
        end
        figure(100)
        imshow(mat2gray(data))
        axis equal;
        l=size(data,1);
        for f=1:length(lsofnumofmol)
            s=num2str(lsofnumofmol(f));
            s=strcat('\color{white}',s);
            text(l*f-5,l-5,s);
        end
        saveas(gcf, fli)
    end
end