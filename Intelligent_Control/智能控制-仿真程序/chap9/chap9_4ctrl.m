function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global node c b lambd delta
lambd=5;
delta=0.25;
node=9;
sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0];
c= [-2 -1.5 -1 -0.5 0 0.5 1 1.5 2;
    -2 -1.5 -1 -0.5 0 0.5 1 1.5 2;
    -2 -1.5 -1 -0.5 0 0.5 1 1.5 2;
    -2 -1.5 -1 -0.5 0 0.5 1 1.5 2;
    -2 -1.5 -1 -0.5 0 0.5 1 1.5 2];
b=15;
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global node c b lambd delta
yd=sin(t);
dyd=cos(t);
ddyd=-sin(t);
x1=u(2);
x2=u(3);
e=x1-yd;
de=x2-dyd;

s=lambd*e+de;
v=-ddyd+lambd*de;
xi=[x1;x2;s;s/delta;v];

h=zeros(9,1);
for j=1:1:9
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b^2));
end

Gama=0.05;
faip=x(1);
k=0.10;
S=Gama/2*s^2*h'*h-k*Gama*faip;
sys(1)=S;

function sys=mdlOutputs(t,x,u)
global node c b lambd delta
yd=sin(t);
dyd=cos(t);
ddyd=-sin(t);
x1=u(2);
x2=u(3);
e=x1-yd;
de=x2-dyd;
s=lambd*e+de;
v=-ddyd+lambd*de;

xi=[x1;x2;s;s/delta;v];

faip=x(1);

h=zeros(9,1);
for j=1:1:9
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b^2));
end
ut=-1/2*s*faip*h'*h;

sys(1)=ut;