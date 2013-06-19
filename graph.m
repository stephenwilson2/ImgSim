function graph(imgdata,n,s,m)
%% Graphs the imgdata's cells, fluorescence, and molecules
    for i=1:length(imgdata{5})
        figure(i);
        subplot(1,2,1), imagesc(imgdata{5}{i})
        axis equal;
        subplot(1,2,2), imagesc(imgdata{6}{i})
        axis equal;
        compiled=ovlay(imgdata{1},imgdata{6},imgdata{3},imgdata{2});
    end
    psfcompiled=psf(compiled,s,m);
    figure(n);
     surf(psfcompiled),colormap jet,shading interp;
%      figure(n*100)
%      imshow(mat2gray(imgdata{1}))
    axis equal;
end

function cellmask=ovlay(cellmask, cells, ori, angles)
    t=size(cellmask);
    imgs=t(1);

    for i=1:length(angles)
        cel=cells{i}';
        cel=imrotate(cells{i},-angles(i));
        n=size(cel);
        figure(7800932)
        imagesc(cel)
        for x=1:n(1)
            m=uint32(ori(i,1)-n(1)/2+x);
            if m>0 && m<imgs
                for y=1:n(2)
                    r=uint32(ori(i,2)-n(2)/2+y);
                    if r>0 && r<imgs
                        cellmask(m,r)=cel(x,y)*100;%+cellmask(m,r);
                    end
                end
            end
        end
    
    end
end