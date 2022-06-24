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
global bj ci c
sizes = simsizes;
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = 0.1*ones(1,5);
str = [];
ts  = [0 0];
ci=[-2 -1 0 1 2];
bj=3.0;
c=10;
function sys=mdlDerivatives(t,x,u)
global bj ci c
xd=sin(t);    
dxd=cos(t);

e=u(1);
ef=u(2);
x1=e+xd;
s=e+c*ef;
 
W=[x(1) x(2) x(3) x(4) x(5)]';
xi=x1;
 
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-ci(:,j))^2/(2*bj^2));
end
 
gama=100;
for i=1:1:5
    sys(i)=gama*s*h(i);
end
function sys=mdlOutputs(t,x,u)
global bj ci c
xd=sin(t);    
dxd=cos(t);

e=u(1);
ef=u(2);
x1=e+xd;

s=e+c*ef;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=x1;
 
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-ci(:,j))^2/(2*bj^2));
end
fn=W*h;

b=10;k=3.0;
D=1.5;
ut=1/b*(-c*e+dxd-fn-k*s-D*sign(s));

sys(1)=ut;
sys(2)=fn;
