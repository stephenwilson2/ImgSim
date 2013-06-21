function [X,Y] = calculateEllipse(x, y, a, b, angle, steps)
    beta = -angle * (pi / 180);
    alpha = linspace(0, 360, steps)' .* (pi / 180); %creates a linearly spaced vector from 0 to 360 of length steps.
    X = x + (a * cos(alpha) * cos(beta) - b * sin(alpha) * sin(beta));
    Y = y + (a * cos(alpha) * sin(beta) + b * sin(alpha) * cos(beta));
end