function graph(imgdata)
%% Graphs the imgdata's cells, fluorescence, and molecules
    for i=1:length(imgdata{5})
        figure(i);
        imagesc(imgdata{5}{i})
        axis equal;

    end

    overlay=imgdata{6};
    
    n=randi([1 9]);
    figure(n);
    imagesc(overlay);
    figure(n*100)
    imshow(mat2gray(overlay))
    axis equal;
end

