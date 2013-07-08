function output=calcSquare(varargin)
angle=45*pi/180;
a=2000;
b=500;
steps=20;
ix=a;
iy=b;

% Sets defaults for optional inputs
optargs = {ix,iy,a,b,angle,steps};

% Checks to ensure  6 optional inputs at most
numvarargs = length(varargin);
if numvarargs > 6
    error('Takes at most 6 optional inputs');
end

% Overwrites defaults if optional input exists
optargs(1:numvarargs) = varargin;
ix = cell2mat(optargs(1));
iy = cell2mat(optargs(2));
a = cell2mat(optargs(3));
b = cell2mat(optargs(4));
angle = cell2mat(optargs(5))*pi/180;
steps = cell2mat(optargs(6));

steps=20;

x=-a:1/steps:a;

y=zeros(length(x),1);
y(:)=b;
x=x';


hy=-b:1/steps:b;

hx=zeros(length(hy),1);
hx(:)=a;
hy=hy';

x2=[x+ix;x+ix];
x2=[x2;hx+ix];
x2=[x2;-hx+ix];

y2=[y+iy; -y+iy];
y2=[y2;hy+iy];
y2=[y2;hy+iy];

output=[x2 y2];

% plot(x2,y2,'or')

end