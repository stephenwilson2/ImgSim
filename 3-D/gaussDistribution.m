function y = gaussDistribution(x, mu, s)
 p1 = -.5 * ((x - mu)/s) .^ 2;
 p2 = (s * sqrt(2*pi));
 y = exp(p1) ./ p2;
end