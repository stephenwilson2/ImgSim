function testWalk()
%%Test the random walk and displays the Radius of Gyration versus the
%%Length of the macromolecule(RNA in this case). The Radius of Gyration is
%%the average distance of the monomers from the center of mass.

    %Define the height and length of the cells here in nanometers
    h=50; %nm
    l=200; %nm
    numofcells=1;
    %The number of molecules to measure
    
    datapts=10;
    numofmol=1;
    L=linspace(1,1000,datapts); % This number is representative of the nm of molecule
    % per molecule
    
    a=1; %the kuhn length is 1 nm b/c that is the dist. walked for 
    pl=a/2; %persistence length
    X=[];
    for u=L
        x=u*pl/3;
        X=[X x];
    end
    
    
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
    
    datals{length(datapts)}=[];
    tic
    for o=1:datapts
        sizeofmol=L(o);
        imgdata=drawEcoli(k,numofcells,l,h,steps,'no');
        imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
        p=imgdata{5}{1};
        datals{o}=p;
        figure(o);imagesc(p);axis equal;
    end
    toc
    X
    figure(23);
    plot(L,X);
end
