function drawEllipse(x, y, a, b, varargin)
    %% Draws an Ellipse in position x,y of dimentions a,b
    % There are three optional arguments: the angle, number dots defining
    % the elipse, and the color of the elipse
    %%
    
    % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 3
        error('Requires at most 3 optional inputs');
    end
    
    % Sets defaults for optional inputs
    optargs = {0 50 'white'};
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    
    % Assign the outcomes to the variables
    angle = cell2mat(optargs(1));
    steps = cell2mat(optargs(2));
    color = cell2mat(optargs(3));
       
    p = calculateEllipse(x, y, a, b, angle, steps);
   % m = uint8(p);
   % img = p;
   %trying to check if the ellipse will overlap with the image at all. If
   %so don't use it
    f= getframe;
    [im,map] = frame2im(f);
 
    n=0;
    '______________________________________'
    for pt = p'
        try 
            if im(uint16(pt(1)),uint16(pt(2)),:)~=0
                %im(uint16(pt(1)),uint16(pt(2)))
                n=n+1;
            end
        catch
            'ellipse out of area'
            n=n+1;
        end
    end
    n
    if n==0
        k = plot(p(:,1), p(:,2)); axis off; %'.-'
        set(k,'Color',color,'LineWidth',2)
        'Drawing'
    else
        'Not Drawing'
    end
    result = input(' Get more information?','s');
    if result=='y'
        for pt = p'
            p
        end
        k = plot(p(:,1), p(:,2)); axis off; %'.-'
        set(k,'Color','red','LineWidth',2)
    elseif result=='n'
    elseif result=='q'
        quit
    else
          'Type n or y'  
    end
    
end
function [X Y] = calculateEllipse(x, y, a, b, angle, steps)
    error(nargchk(5, 6, nargin));
    if nargin<6, steps = 36; end

    beta = -angle * (pi / 180);
    alpha = linspace(0, 360, steps)' .* (pi / 180); %creates a linearly spaced vector from 0 to 360 of length steps.
    X = x + (a * cos(alpha) * cos(beta) - b * sin(alpha) * sin(beta));
    Y = y + (a * cos(alpha) * sin(beta) + b * sin(alpha) * cos(beta));
    if nargout==1, X = [X Y]; end
end

