    clear all;
    close all;
    load('TestIntensity.mat')
    
    pairpsf(:,3)=power(pairpsf(:,3),.5);
    pairwopsf(:,3)=power(pairwopsf(:,3),.5);
    
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

    saveas(gcf, 'TestIntensityLin.fig')