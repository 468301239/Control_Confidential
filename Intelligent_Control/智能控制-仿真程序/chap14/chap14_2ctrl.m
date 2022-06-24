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
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0  =[0.1 0.1 0.1 0.1 0.1];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
global bj cij
A=[0 1;
   0 0];
B=[0 1]';

x1=u(1);
x2=u(2);

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x2];

h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

P=[ 0.1226    0.0351;
    0.0351    0.0174];
gama=100;
for j=1:1:5
    sys(j)=gama*xi'*P*B*h(j);
end
function sys=mdlOutputs(t,x,u)
global bj cij
x1=u(1);
x2=u(2);

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[x1;x2];
 
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;
K=[-10.8480   -4.8786];

ut=K*xi-fn;
sys(1)=ut; 
sys(2)=fn; 