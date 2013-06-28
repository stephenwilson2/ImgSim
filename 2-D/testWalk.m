function testWalk()
%%Test the random walk and displays the Radius of Gyration versus the
%%Length of the macromolecule(RNA in this case). The Radius of Gyration is
%%the average distance of the monomers from the center of mass.
    clear all;
    close all;
    try
        load('RandomWalkData3')
    catch
        
        %Define the height and length of the cells here in nanometers
        h=50; %nm
        l=200; %nm
        numofcells=1;
        %The number of molecules to measure
        
        datapts=100;
        numofRgs=30;
        
        numofmol=1;
        L=linspace(10,300,numofRgs); % This number is contour length in nm
        
        a=2*1; %the kuhn length is 2 nm b/c that twice the persistence length
        pl=1; %persistence length
        N=L/a; %the number of steps
        
        
        %calculate the radius of gyration
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
        for i=1:numofRgs
            for o=1:datapts
                sizeofmol=L(i);
                imgdata=drawEcoli(k,numofcells,l,h,steps,'no');
                imgdata=populateMolecules(imgdata,numofmol,sizeofmol);
                p=imgdata{5}{1};
                datals{o}=p;
                %figure(o);imagesc(p);axis equal;
            end
            rg{i}=datals;
        end
        Rgs(numofRgs)=0;
        for i=1:numofRgs
            datals=rg{i};
            tmp=zeros(1,o);
            for o=1:datapts %for each cell calc a Rg
                expRg=0;
                [x,y]=find(datals{o});
                xy=[x y];
                for c=1:length(y)
                    num=datals{o}(xy(c,1),xy(c,2))/200;
                    for b=1:num-1
                        xy=[xy;xy(c,:)];
                    end
                end
                u=mean(xy);
                for k=1:L(i) %k represents a single unit of the contour length
                    r=((xy(k,2)-u(1,2))^2+(xy(k,1)-u(1,1))^2)^.5;
                    expRg=expRg+(r)^2;
                end
                expRg=expRg/N(i);
                tmp(o)=expRg;
            end
            Rgs(i)=mean(tmp);
        end
        toc
    end
    
    pe=polyfit(L,X,1);

    
    pa=polyfit(L,Rgs,1);
  
    yfita = polyval(pa,L);
    
    
    figure(23);
    hold all;
    plot(L,X);
    plot(L,Rgs,'color','red');
    plot(L,yfita,'color','red');
    title('Radius of Gyration versus the Contour Length of Polymer',...
        'FontWeight','bold')
    xlabel('Countour Length (nm)')
    ylabel('Radius of Gyration (nm^2)')
    exp=sprintf('Expected-slope: %d',pe(1));
    act=sprintf('Actual Linear Fit-slope: %d',pa(1));
    legend(exp,'Actual',act)
    saveas(gcf, 'TestRandomWalk.fig')
    
    save('RandomWalkData3')
end
