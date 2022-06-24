function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global bj cij
cij=0.5*[-2 -1 0 1 2;
       -2 -1 0 1 2];
bj=3.0;

sizes = simsizes;
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0  =[0.1 0.1 0.1 0.1 0.1 1.0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
global bj cij
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);

c=10;
e=x1-xd;
de=x2-dxd;
s=c*e+de;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x2];

h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

k=5;xite=0.10;
alfa=k*s+c*de+fn-ddxd-xite*sign(s);

gama=10;
sgn_th=1.0;
dp=gama*s*alfa*sgn_th;
 
for j=1:1:5
    sys(j)=gama*s*h(j);
end
sys(6)=dp; 
function sys=mdlOutputs(t,x,u)
global bj cij
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);

c=10;
e=x1-xd;
de=x2-dxd;
s=c*e+de;
p_estimation=x(6); 

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x2];
 
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

k=5;
xite=0.10;
alfa=k*s+c*de+fn-ddxd-xite*sign(s);

uc=-p_estimation*alfa;

if t>=5.0
    rou=0.20;
else
    rou=1.0;
end
ut=rou*uc;
sys(1)=ut; 