function [XX YY ZZ]=calcEllipsoid(x,y,z,a,b,c,angle, steps)
    u = -angle * (pi / 180); %between pi/2 and neg pi/2
    v = linspace(0, 360, steps)' .* (pi / 180); %creates a linearly spaced vector from 0 to 360 of length steps.

    X = x+a*cos(u)*sin(v);

    Y = y+b*sin(u)*sin(v);

    Z = z+c*cos(v);
    
end
