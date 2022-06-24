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
global bj cij k1 k2
cij=0.5*[-2 -1 0 1 2;
       -2 -1 0 1 2];
bj=3.0;
k1=50;k2=50;
sizes = simsizes;
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  =[0.1 0.1 0.1 0.1 0.1];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global bj cij k1 k2

yd=u(1);dyd=cos(t);ddyd=-sin(t);
x1=u(2);x2=u(3);

z1=x1-yd;
dz1=x2-dyd;

%kb=0.50;
kb1=0.51;  %kb must bigger than z1(0)
xd_max=1.0;xd_min=-1.0;
x1_max=kb1+xd_max;x1_min=-kb1+xd_min;
alfa=-k1*z1+dyd;
z2=x2-alfa;

dalfa=-k1*dz1+ddyd;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x2];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

gama=0.10;
for j=1:1:5
    sys(j)=gama*z2*h(j)-gama*x(j);
end

function sys=mdlOutputs(t,x,u)
global bj cij k1 k2

yd=u(1);dyd=cos(t);ddyd=-sin(t);
x1=u(2);x2=u(3);

z1=x1-yd;
dz1=x2-dyd;

%kb=0.50;
kb1=0.51;  %kb must bigger than z1(0)

xd_max=1.0;xd_min=-1.0;
x1_max=kb1+xd_max;x1_min=-kb1+xd_min;
alfa=-k1*z1+dyd;
z2=x2-alfa;

dalfa=-k1*dz1+ddyd;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x2];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;
b=133;
ut=1/b*(-fn+dalfa-k2*z2);

sys(1)=ut;
sys(2)=z1;
sys(3)=fn;