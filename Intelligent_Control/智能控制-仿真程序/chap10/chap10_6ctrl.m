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
cij=0.5*[-2 -1 0 1 2];
bj=3.0;

sizes = simsizes;
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  =[0.1 0.1 0.1 0.1 0.1];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global bj cij

xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);x2=u(3);
e=x1-xd;
de=x2-dxd;

%xi=[x1;x2];
xi=x2;

h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
 
alfa=10;beta=10;k=10;l=10;
t1=tanh(k*e+l*de);
t2=tanh(l*de);

gama=0.10;

W=[x(1) x(2) x(3) x(4) x(5)];
Wmin=-1;Wmax=1;

for j=1:1:5
M=2;
if M==1
dw(j)=gama*h(j)*l*(alfa*t1+beta*t2);
sys(j)=dw(j);
end

if M==2
Kesi(j)=h(j)*l*(alfa*t1+beta*t2);
dw(j)=gama*Kesi(j);
if W(j)>=Wmax&Kesi(j)>0
sys(j)=0;
elseif W(j)<=Wmin&Kesi(j)<0
sys(j)=0;
else
sys(j)=dw(j);
end
end

end
function sys=mdlOutputs(t,x,u)
global bj cij
xd=u(1);    
dxd=cos(t);
ddxd=-sin(t);

x1=u(2);
x2=u(3);

e=x1-xd;
de=x2-dxd;

W=[x(1) x(2) x(3) x(4) x(5)];
%xi=[x1;x2];
xi=x2;
 
h=zeros(5,1);
for j=1:1:5
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));
end
fp=W*h;

alfa=10;beta=10;
k=10;l=10;

t1=tanh(k*e+l*de);
t2=tanh(l*de);

ut=-alfa*t1-beta*t2-fp+ddxd;
sys(1)=ut;   %Umax=alfa+beta+fp_max+ddxd_max)=10+10+4+1=25
sys(2)=fp;