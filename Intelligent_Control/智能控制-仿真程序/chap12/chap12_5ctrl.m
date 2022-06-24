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
global bj cij
cij=0.5*[-1 -0.5 0 0.5 1;
         -1 -0.5 0 0.5 1];
bj=3.0;

sizes = simsizes;
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  =[0.1 0.1 0.1 0.1 0.1];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
global bj cij

x1=u(1);x2=u(2);x3=u(3);x4=u(4);
c3=9;c2=1+27;c1=c3+27;
s=c1*x1+c2*x2+c3*x3+x4;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x3];

h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

gama=10;
for j=1:1:5
    sys(j)=gama*s*h(j);
end

function sys=mdlOutputs(t,x,u)
global bj cij
x1=u(1);x2=u(2);x3=u(3);x4=u(4);

c3=9;
c2=1+27;
c1=c3+27;
s=c1*x1+c2*x2+c3*x3+x4;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x3];

h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

xite=0.10;k=10;
ut=-c1*x2-c2*(x1+x3)-c3*x4-k*s-fn-xite*sign(s);
sys(1)=ut;
sys(2)=fn;