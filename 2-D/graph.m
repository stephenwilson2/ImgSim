function graph(imgdata)
%% Graphs the imgdata's cells, fluorescence, and molecules
    overlay=imgdata{6};
    
    n=randi([1 9]);
    figure(n);
    imagesc(overlay);
    axis equal;
%     figure(n*100)
%     imshow(mat2gray(overlay))
%     axis equal;
end

