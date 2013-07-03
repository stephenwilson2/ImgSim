function testClumping (varargin)
    %% testClumping
    
    % Default values

    shape='sc'; % Shape of cell. Options are:
                % Ellipse, spherocylinder, and sphere (sphere only works
                % with one cell right not)
    angle=0; % Force an angle on the cells. 360 if don't force
    imgnum=5; % Num of images between the lnum and hnum of mol
        lnum=50;% Lower num of mol
        hnum=200;% High num of mol
    res=64;
    
    
    
    
    numofcells=1;
    nmperpixel=1;
    
    % The number of molecules to measure
    lsofnumofmol=round(linspace(lnum,hnum,imgnum));
    sizeofmol=1; % This number is represnetative of the nm of molecule
    % per molecule
    
    % Repeat the simulation 'rep' times and display the data as one image
     rep=3; 
     
    % Fluorescene Variables
    emwave=520; %nm
    n=1.515; % Refractive index for immersion oil
    NA=1.4; % Numerical apperature
    a=asin(NA/n);
    k=(2*pi/emwave);

    num=4-7*power(cos(a),3/2)+3*power(cos(a),7/2);
    de=7*(1-power(cos(a),3/2));
    fluorvar=1/n/k*power(num/de,-0.5);
    


    % Define the height and length of the cells here in nanometers
    h=500; %nm
    l=10000; %nm

        % Sets defaults for optional inputs
        optargs = {shape};
        
        % Checks to ensure  3 optional inputs at most
        numvarargs = length(varargin);
        if numvarargs > 1
            error('Takes at most 1 optional inputs');
        end
        
        % Overwrites defaults if optional input exists
        optargs(1:numvarargs) = varargin;
        shape = cell2mat(optargs(1));

    
    % Filename
    flend=strcat(num2str(res),'_',shape,'long');
    fli=strcat('TestNumofMolClumping_',flend);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Scaling
    steps=l*nmperpixel*10; % Calculated of nmperpixel and cell size

    % Sets the image size according to the number of cells and the cell size
    if h>l
        imgsize=h*numofcells;
    else
        imgsize=l*numofcells;
    end
    if numofcells==1
        imgsize=round(imgsize*1.3);
    end

    k(imgsize,imgsize) = 0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    try
        load(strcat('TestClumping_',flend))
    catch
        fprintf('%s\n', 'Drawing mask');
        
        tic
        imgdata=drawEcolimod(k,numofcells,l,h,steps,'no',angle,shape);
        toc
        
        
        tmpimgdata=imgdata;
        if length(imgdata)>1
            alldata=[];
            for t=1:rep
                data=[];
                
                for numofmol=lsofnumofmol
                    imgdata=tmpimgdata;
                    i=num2str(numofmol);
                    %                 fl=strcat(fli,i,'.fig');
                    fprintf('\n%s\n', 'Populating Molecules');
                    tic
                    imgdata=populateMolecules(imgdata,numofmol,sizeofmol,shape);
                    toc
                    
                    figure(548);imagesc(imgdata{5}{1});axis equal;
                    
                    if strcmp(shape,'s')==0
                        fprintf('\n%s\n', 'Overlaying Molecules with mask');
                        tic
                        imgdata=ovlay(imgdata,imgdata{1},imgdata{5});
                        toc
                    else
                        imgdata{6}=imgdata{5}{1};
                    end
                    
                    fprintf('\n%s\n', ...
                        'Applying PSF directly to molecules (equiv. 1:1 binding)');
                    tic
                    imgdata{6}=psf(imgdata{6},fluorvar);
                    toc
                    
                    fprintf('\n%s\n', 'Coarsening');
                    
                    tic
                    imgdata=coarsen(imgdata,nmperpixel,res);
                    toc
                    
                    tic
                    %                 graph(imgdata)
                    %                 saveas(gcf, fl)
                    close all;
                    data=[data imgdata{6}];
                    toc
                end
%                 figure(100)
%                 imshow(mat2gray(data))
%                 axis equal;
%                 l=size(data,1);
%                 for f=1:length(lsofnumofmol)
%                     s=num2str(lsofnumofmol(f));
%                     s=strcat('\color{white}',s);
%                     text(l*f-5,l-5,s);
%                 end
%                 saveas(gcf, strcat(fli,'_',num2str(t)))
                alldata=[alldata;data];
                
            end
        end
    end
    save(strcat('TestClumping_',flend),'alldata');
    figure(100)
    imshow(mat2gray(alldata))
    axis equal;
    l=size(alldata,1);
    for f=1:length(lsofnumofmol)
        s=num2str(lsofnumofmol(f));
        s=strcat('\color{white}',s,' Molecules');
        text(l/(imgnum/2)*.9*f-l/(imgnum/2)*.9+5,l,s);
    end
    saveas(gcf, fli)
    
end