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
global ci bi c miu
sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0;
str = [];
ts  = [];
ci=[-2 -1 0 1 2;
    -2 -1 0 1 2];
bi=1;
c=200;
miu=30;
function sys=mdlDerivatives(t,x,u)
global ci bi c miu
x1d=u(1);
dx1d=u(2);
x1=u(3);
x2=u(4);

e=x1-x1d;
de=x2-dx1d;
s=c*e+de;

xi=[x1;x2];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-ci(:,j))^2/(2*bi*bi));
end
gama=150;
k=2*miu/gama;
sys(1)=gama/2*s^2*h'*h-k*gama*x;

function sys=mdlOutputs(t,x,u)
global ci bi c miu
x1d=u(1);
dx1d=u(2);
x1=u(3);
x2=u(4);

e=x1-x1d;
de=x2-dx1d;
thd=0.1*sin(t);
dthd=0.1*cos(t);
ddthd=-0.1*sin(t);
s=c*e+de;

fi=x;
xi=[x1;x2];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-ci(:,j))^2/(2*bi*bi));
end

b=10;
xite=0.5;

ut=1/b*(-0.5*s*fi*h'*h+ddthd-c*de-xite*sign(s)-miu*s);
sys(1)=ut;