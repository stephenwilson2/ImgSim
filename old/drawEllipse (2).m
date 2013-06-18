function drawEllipse(ls)
    %% Draws an Ellipse in position x,y of dimentions a,b
    % There are three optional arguments: the angle, number dots defining
    % the elipse, and the color of the elipse
    %%
    
  
    
   %trying to check if the ellipse will overlap with the image at all. If
   %so don't use it
    f= getframe;
    [im,map] = frame2im(f);
 
    n=0;
    fprintf('%s\n','____________');
    for pt = p'
        try 
            if im(uint16(pt(1)),uint16(pt(2)),:)~=0
                %im(uint16(pt(1)),uint16(pt(2)))
                n=n+1;
            end
        catch
            fprintf('%s\n','ellipse out of area');
            n=n+1;
        end
    end
    fprintf('%i\n',n);
    if n==0
        k = plot(p(:,1), p(:,2)); axis off; %'.-'
        set(k,'Color',color,'LineWidth',2)
        fprintf('%s\n','Drawing');
    else
        fprintf('%s\n','Not Drawing');
    end
    result = input('Get more information? \n','s');
    if result=='y'
        for pt = p'
            disp(p);
        end
        k = plot(p(:,1), p(:,2)); axis off; %'.-'
        set(k,'Color','red','LineWidth',2)
    elseif result=='n'
    elseif result=='q'
        quit
    else
          fprintf('%s\n','Type n or y');
    end
    
end


