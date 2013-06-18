% val = 101:106
% subs=[1 2; 1 2; 3 1; 4 1; 4 4; 4 1]
val=[1,1,1,0,1;1,0,1,0,1;0,0,1,1,1;0,0,0,1,1;]

factor=2;

subs={};
s=size(val);
w=s(1);
h=s(2);
m=0;


for i=1:w
    for n=1:h
        m=m+1;
        subs{m}=[round(i/factor); round(n/factor)];
    end
end

subs=cell2mat(subs);
% for o=1:factor
%     subs= [subs subs];
% end
subs=subs';

bl=[];
for i=1:w
    bl=[bl val(i,:)];
end
bl;

C=accumarray(subs,bl,[],@mean)




