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
global cij bj c
sizes = simsizes;
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = 0*ones(1,5);
str = [];
ts  = [];
cij=[-1 -0.5 0 0.5 1;
     -1 -0.5 0 0.5 1];
bj=1.0;
c=15;
function sys=mdlDerivatives(t,x,u)
global cij bj c
x1d=u(1);dx1d=cos(t);
x1=u(2);x2=u(3);
e=x1d-x1;
de=dx1d-x2;
s=c*e+de;

xi=[x1;x2];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
gama=0.015;
W=[x(1) x(2) x(3) x(4) x(5)]';
for i=1:1:5
    sys(i)=-1/gama*s*h(i);
end
function sys=mdlOutputs(t,x,u)
global cij bj c
x1d=u(1);
dx1d=cos(t);ddx1d=-sin(t);
x1=u(2);
x2=u(3);
e=x1d-x1;
de=dx1d-x2;

s=c*e+de;
W=[x(1) x(2) x(3) x(4) x(5)]';
xi=[x1;x2];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W'*h;
b=133;
xite=1.10;
%ut=1/b*(-fn+ddx1d+c*de+xite*sign(s));

delta=0.05;
kk=1/delta;
if abs(s)>delta
   sats=sign(s);
else
   sats=kk*s;
end
ut=1/b*(-fn+ddx1d+c*de+xite*sats);

sys(1)=ut;
sys(2)=fn;