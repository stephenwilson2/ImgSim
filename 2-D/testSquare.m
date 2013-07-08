clear all;
r=5;
steps=20;

x=-r:1/steps:r;

y=zeros(length(x),1);
y(:)=r;
x=x';

x2=[x;x];
x2=[x2;y];
x2=[x2;-y];

y2=[y; -y];
y2=[y2;x];
y2=[y2;x];


plot(x2,y2,'or')
% plot(x,y,'or',x,-y,'ob',y,x,'og',-y,x,'og')