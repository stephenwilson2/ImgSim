function [X,Y]=drawSquare()%x, y, a, b, angle, steps)
    x=0;y=0;a=500;b=1000;angle=pi;steps=20;
    beta=angle;
    alpha=linspace(0,2*pi,steps);
    
    X= x+(a * cos(beta));
 
    Y= y+(b * cos(beta));
    
    
%     tempX = [startX:steps/4:endX]';
% 	tempY = tempX;
% 	tempY(:) = startY;
% 	output = [tempX(:),tempY(:)];
% 	
% 
% 	tempY = [startY+1:steps/4:endY]';
% 	tempX = tempY;
% 	tempX(:) = endX;
% 	output = [output;tempX(:),tempY(:)];
% 	
% 	
% 	tempX = [endX-1:-steps/4:startX]';
% 	tempY = tempX;
% 	tempY(:) = endY;
% 	output = [output;tempX(:),tempY(:)];
% 	
% 	tempY = [endY-1:-steps/4:startY]';
% 	tempX = tempY;
% 	tempX(:) = startX;
% 	output = [output;tempX(:),tempY(:)];
%     X=output(:,1);
%     Y=output(:,2);
%     
    scatter(X,Y);

    if nargout==1, X = [X Y]; end

end