[X Y]=spherocylinder(21,200,20,200,0,200);
    A = uint16(zeros(20,200));
    for pair = round([X Y])'
        if pair(1)>0 && pair(2)>0 && pair(1)<500 && pair(2)<5000
            A(pair(1),pair(2)) = 1;
        end
    end

    figure(6);imagesc(A);