function [sys,x0,str,ts] = s_function(t,x,u,flag)
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
global c b node
node=5;
sizes = simsizes;
sizes.NumContStates  = node;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.1*ones(node,1)];
str = [];
ts  = [];
c=[-2 -1 0 1 2;
   -2 -1 0 1 2];
b=1.5;

function sys=mdlDerivatives(t,x,u)
global c b node
B=0.015;L=0.0008;D=0.05;R=0.075;m=0.01;J=0.05;
l=0.6;Kb=0.085;M=0.05;Kt=1;g=9.8;
Mt=J+1/3*m*l^2+1/10*M*l^2*D;
N=m*g*l+M*g*l;

zd=u(1);dzd=cos(t);ddzd=-sin(t);
x1=u(2);x2=u(3);x3=u(4);
gx=x1^2+x2^2;

z1=x1-zd;
c1=100;c2=100;c3=100;

a1=-B/Mt;a2=N/Mt*gx;a3=Kt/Mt;
b3=1/L;

dx2=a1*x2+a2+a3*x3;
dfx=2*x1*x2+2*x2*dx2;

da2=N/Mt*dfx;
dz1=x2-dzd;
ddz1=dx2-ddzd;
z2=x2+c1*z1-dzd;
dz2=dx2+c1*dz1-ddzd;
z3=a3*x3+a1*x2+a2+c1*dz1-ddzd+c2*z2+z1;

xi=[x2 x3]';
for j=1:1:node
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b^2));
end

gama=0.50;
sys=gama*a3*z3*h;         %f estimation
function sys=mdlOutputs(t,x,u)
global c b node

B=0.015;L=0.0008;D=0.05;R=0.075;m=0.01;J=0.05;
l=0.6;Kb=0.085;M=0.05;Kt=1;g=9.8;
Mt=J+1/3*m*l^2+1/10*M*l^2*D;
N=m*g*l+M*g*l;

zd=u(1);dzd=cos(t);ddzd=-sin(t);
x1=u(2);x2=u(3);x3=u(4);
gx=x1^2+x2^2;

z1=x1-zd;
c1=100;c2=100;c3=100;

a1=-B/Mt;a2=N/Mt*gx;a3=Kt/Mt;
b3=1/L;

dx2=a1*x2+a2+a3*x3;
dfx=2*x1*x2+2*x2*dx2;

da2=N/Mt*dfx;
dz1=x2-dzd;
ddz1=dx2-ddzd;
z2=x2+c1*z1-dzd;
dz2=dx2+c1*dz1-ddzd;
z3=a3*x3+a1*x2+a2+c1*dz1-ddzd+c2*z2+z1;

T=-a1*dx2-da2-c1*ddz1+ddzd-c2*dz2-dz1-z2-c3*z3;

xi=[x2 x3]';
for j=1:1:node
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b^2));
end

w_fp=[x(1:node)]';
fp=w_fp*h';
ut=1/b3*(1/a3*T-fp);

sys(1)=ut;
sys(2)=fp;