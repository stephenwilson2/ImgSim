function imgdata=ovlay(imgdata,bi,oi)
%ovlay inputs:  1)imagedata
%      output: 
%               1)the cell mask, 16-bit image matrix
%               2)angles of the cells
%               3)origins of the cells
%               4)dimensions of the cell (in a cell type: len, height)
%               5)the molecules channel (in a cell type): 1000=rna
%               6)overlay
    img=imgdata{1};
    angles=imgdata{2};
    ori=imgdata{3};
    dim=imgdata{4};
        len=dim{1};
        height=dim{2};
    cells=oi;

    t=size(bi);
    imgs=t(1);
    
    for i=1:length(angles)
        cel=imrotate(cells{i},-angles(i));
        n=size(cel);

        for x=1:n(1)
            m=uint32(ori(i,1)-n(1)/2+x);
            if m>0 && m<imgs
                for y=1:n(2)
                    r=uint32(ori(i,2)-n(2)/2+y);
                    if r>0 && r<imgs
                        bi(m,r)=cel(x,y)*100;%+img(m,r);
                    end
                end
            end
        end
    
    end
    imgdata={img,angles,ori,dim,cells,bi};
end