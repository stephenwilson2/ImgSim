% val = 101:106
% subs=[1 2; 1 2; 3 1; 4 1; 4 4; 4 1]
clear all;
val=[1,1,1,0,1,1,1,0;1,0,1,0,1,1,1,0;0,0,1,1,1,1,1,0;0,0,0,1,1,1,1,0];
val=rand([10,10]);
subs=[1,1,2,2;1,1,2,2;3,3,4,4;3,3,4,4];

s=size(val);
w=s(1);
h=s(2);
factor=5;
if w>factor
    wp=ceil(w/factor);
else
    'too big a factor for w'
end
if h>factor
    hp=ceil(h/factor);
else
    'too big a factor for h'
end
y=zeros(factor,factor);
x{wp,hp}=[];
n=0;
for i=1:wp
    for j=1:hp
        n=n+1;
        y(:,:)=n;
        x{i,j}=y;
    end
end
y=cell2mat(x);
%y
y=y(1:w,1:h);
%val
%y
v1 = reshape(val,numel(val),1);
s1 = reshape(y,numel(y),1);

C=accumarray(s1,v1,[max(s1) 1],@mean);
f{wp,hp}=[];
n=0;
for i=1:wp
    for j=1:hp
        n=n+1;
        f{i,j}=C(n);
    end
end

final=cell2mat(f);
final


