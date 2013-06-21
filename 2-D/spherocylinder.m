function [X Y]=spherocylinder(x,y,a,b,angle,steps)
    beta = -angle * (pi / 180);
    if a>b
        tmp=a;
        a=b;
        b=tmp;
    end
    
    
    alpha = linspace(0, 180, steps/4)' .* (pi / 180); %creates a linearly spaced vector from 0 to 180 of length steps.
    X = x + (a * cos(alpha) * cos(beta) - a * sin(alpha) * sin(beta))-(b-2*a)*1.5*sin(beta);
    Y = y + (a * cos(alpha) * sin(beta) + a * sin(alpha) * cos(beta))+(b-2*a)*1.5*cos(beta);
    for n=1:(b-2*a)*3
        X=[X;X(length(X))+1*sin(beta)];
        Y=[Y;Y(length(Y))-1*cos(beta)];
    end
    alpha = linspace(180, 360, steps/4)' .* (pi / 180); %creates a linearly spaced vector from 180 to 360 of length steps.  
    X2 = x + (a * cos(alpha) * cos(beta) - a * sin(alpha) * sin(beta))+1.5*(b-2*a)*sin(beta);
    Y2 = y + (a * cos(alpha) * sin(beta) + a * sin(alpha) * cos(beta))-1.5*(b-2*a)*cos(beta);
    for n=1:(b-2*a)*3
        X2=[X2;X2(length(X2))-1*sin(beta)];
        Y2=[Y2;Y2(length(Y2))+1*cos(beta)];
    end
    X=[X;X2];
    Y=[Y;Y2];
    
    
%     A = uint16(zeros(500,500));
%     for pair = round([X Y])'
%         if pair(1)~=0 && pair(2)~=0 && pair(1)<500 && pair(2)<500
%             A(pair(1),pair(2)) = 1;
%         end
%     end
% 
%     figure(6);imagesc(A);

    

    if nargout==1, X = [X Y]; end
end