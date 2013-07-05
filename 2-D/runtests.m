
clear all;
close all;

e=0;
% try
%     testWalk()
% catch
%     e=e+1;
% end
% try
%     testRandSpotPositions()
% catch
%     e=e+1;
% end
try
    testIntensity()
catch
    e=e+1;
end

try
    testClumping()
catch
    e=e+1;
end

save('Errors',e)