function drawEcoli (varargin)
%% Draws Ellipses representing ecoli
% Will do so randomly. Randomizes around a number of ecoli
%%
  % Checks to ensure  3 optional inputs at most
    numvarargs = length(varargin);
    if numvarargs > 3
        error('Requires at most 3 optional inputs');
    end
    
    % Sets defaults for optional inputs
    optargs = {5,10,30};
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    avgnum = cell2mat(optargs(1));
    len = cell2mat(optargs(2));
    height = cell2mat(optargs(3));

    avgnum=random('poiss',avgnum);
    p=randi(500,avgnum,2);
    for num = p
        angle = random('normal',180,90);
        % SOMETHING weird is going on with num and n
        for n = num
            %n
            drawEllipse(num(1),num(2),len,height, angle);
        end
    end
        
        f = getframe;              %Capture screen shot
        [im,map] = frame2im(f);    %Return associated image data 
        if isempty(map)            %Truecolor system
             rgb = im;
        else                       %Indexed system
           rgb = ind2rgb(im,map);   %Convert image data
        end
        BW2 = imfill(rgb, 4, 'holes');
        imshow(BW2);
        %num(1)
  end

