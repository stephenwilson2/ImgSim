    clear all;
    close all;
    load('TestIntensity.mat')
    
    %with PSF    
    figure(74);
    subplot(1,2,1);
    [p,s]=polyfit(pairpsf(:,1), pairpsf(:,3),3);
    string='';
    for ew=1:length(p)
        k=sprintf('X^%d', length(p)-ew);
        string=strcat('+',num2str(p(ew)),'*',k,string);
    end
    k=sprintf('The equation is: %s', string);
    y=pairpsf(:,3);
    yfit = polyval(p,pairpsf(:,1));
    R2psf = corrcoef(pairpsf(:,3), yfit);    
    hold all;
    plot(pairpsf(:,1),pairpsf(:,3),'color','blue');
    plot(pairpsf(:,1),yfit,'color', 'red');
    hold off;
    title('Variance^2 compared to number of molecules',...
        'FontWeight','bold')
    xlabel('Number of molecules')
    ylabel('Variance^2')
    legend('Simulation with PSF','Fit')
    text(50,-9,k);
    q=sprintf('The R^2 is: %d', R2psf(1,2));
    text(100,20,q);
    

    %without PSF
    subplot(1,2,2);
    [p,s]=polyfit(pairwopsf(:,1), pairwopsf(:,3),3);
    string='';
    for ew=1:length(p)
        k=sprintf('X^%d', length(p)-ew);
        string=strcat('+',num2str(p(ew)),'*',k,string);
    end
    k=sprintf('The equation is: %s', string);
    y=pairwopsf(:,3);
    yfit = polyval(p,pairwopsf(:,1));
    R2wopsf = corrcoef(pairwopsf(:,3), yfit);
    hold all;
    plot(pairwopsf(:,1),pairwopsf(:,3),'color','blue');
    plot(pairwopsf(:,1),yfit,'color', 'red');
    hold off;
    title('Variance^2 compared to number of molecules',...
        'FontWeight','bold')
    xlabel('Number of molecules')
    ylabel('Variance^2')
    legend('Simulation without PSF','Fit')
    text(50,-.15*10^-5,k);
    q=sprintf('The R^2 is: %d', R2wopsf(1,2));
    text(100,1*10^-5,q);

    saveas(gcf, 'TestIntensityLin.fig')