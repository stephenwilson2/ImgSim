function drawOvoellipses(x, y, a, b, varargin)
    numvarargs = length(varargin);
    if numvarargs > 3
        error('Requires at most 3 optional inputs');
    end
    
    % Sets defaults for optional inputs
    optargs = {0 50 'red'};
    
    % Overwrites defaults if optional input exists
    optargs(1:numvarargs) = varargin;
    
    % Assign the outcomes to the variables
    angle = cell2mat(optargs(1));
    steps = cell2mat(optargs(2));
    color = cell2mat(optargs(3));
       
    p = calcOvoellipses(x, y, a, b, angle, steps);
    k = plot(p(:,1), p(:,2)); axis off; %'.-'
    set(k,'Color',color,'LineWidth',2) 
end
  
function [X,Y]= calcOvoellipses(x,y,a,b,angle,steps)
   error(nargchk(5, 6, nargin));
   if nargin<6, steps = 36; end
   
   alpha = linspace(0, 180, steps)' .* (pi / 180); % Creates, converts, ...
   % and transposes a linearly spaced vector from 0 to 180 of length steps.
    
   X = (x + b* cos(alpha)+a);
   Y = (y + b* sin(alpha)+a);
   
   if nargout==1, X = [X Y]; end
end