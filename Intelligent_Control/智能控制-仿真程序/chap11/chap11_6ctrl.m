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
sizes.NumContStates  = 9;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.1 0.1 0.1 0.1 0.1 0 0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
global bj cij
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);

c=15.0;
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
alfa=k*s+c*de-ddxd+fn+xite*sign(s);

gama1=10;gama2=10;
sgn_b1=1;sgn_b2=-1;

dk11=gama1*s*alfa*sgn_b1;
dk21=gama1*s*sgn_b1;
dk12=gama2*s*alfa*sgn_b2;
dk22=gama2*s*sgn_b2;

gama3=10;
for j=1:1:5
    sys(j)=gama3*s*h(j);
end
sys(6)=dk11; 
sys(7)=dk21; 
sys(8)=dk12; 
sys(9)=dk22; 
function sys=mdlOutputs(t,x,u)
global bj cij
k11p=x(6);k21p=x(7);k12p=x(8);k22p=x(9);

xd=u(1);dxd=cos(t);ddxd=-sin(t);
x1=u(2);x2=u(3);

c=15;
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

k=5;
xite=0.10;
alfa=k*s+c*de+fn-ddxd+xite*sign(s);

uc1=-k11p*alfa-k21p;
uc2=-k12p*alfa-k22p;

rou1=1.0;rou2=1.0;
u1_bar=0;u2_bar=0;
if t>=8
rou1=0.20;
rou2=0;u2_bar=0.2;
end

u1=rou1*uc1+u1_bar;
u2=rou2*uc2+u2_bar;
sys(1)=u1; 
sys(2)=u2;