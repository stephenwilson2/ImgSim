% cell[2000,500]=0;
% cells={};
% 
% for w=1:500
%     cells{w}=cell;
% end
clear all;
s2=219.29;
arr(500)=0;
arr(430)=1;
find(arr)

for i=1:length(arr)
    if arr(i)>0
        val=arr(arr>0);
        for n=1:length(arr)
            y=gaussDistribution(n,i,s2);
            tmp(n)=y*val;
        end
    end
end
arr(tmp>0)=tmp(tmp>0);
arr
