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
cij=[-2 -1 0 1 2;
     -2 -1 0 1 2];
bj=1.0;

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

th=u(1);dth=u(2);
thd=sin(t);dthd=cos(t);

x1=th-thd;
x2=dth-dthd;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[th;dth];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;

P=[ 0.1226    0.0351;
    0.0351    0.0174];

gama=100;
for j=1:1:5
    sys(j)=gama*[x1 x2]*P*B*h(j);
end
function sys=mdlOutputs(t,x,u)
global bj cij
th=u(1);dth=u(2);
thd=sin(t);dthd=cos(t);ddthd=-sin(t);
x1=th-thd;
x2=dth-dthd;

W=[x(1) x(2) x(3) x(4) x(5)];
xi=[th;dth];
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fn=W*h;
K =[-10.8480   -4.8786];
  
tol=K*[x1 x2]'-fn;

ut=tol+ddthd;

sys(1)=ut; 
sys(2)=fn; 