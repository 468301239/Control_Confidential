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
sizes = simsizes;
sizes.NumContStates  = 36;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [zeros(36,1)];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
ym=u(1);dym=u(2);
x1=u(3);x2=u(4);

e=ym-x1;
de=dym-x2;

gama=20;

k2=1;k1=3;
E=[e,de]';
A=[0 -k2;
   1 -k1];
Q=[50 0;0 50];
P=lyap(A,Q);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FS1=0;

u1(1)=1/(1+exp(5*(x1+2)));
u1(6)=1/(1+exp(-5*(x1-2)));
for i=2:1:5
    u1(i)=exp(-(x1+1.5-(i-2))^2);
end

u2(1)=1/(1+exp(5*(x2+2)));
u2(6)=1/(1+exp(-5*(x2-2)));
for i=2:1:5
    u2(i)=exp(-(x2+1.5-(i-2))^2);
end

for i=1:1:6
  for j=1:1:6
    FS2(6*(i-1)+j)=u1(i)*u2(j);
    FS1=FS1+u1(i)*u2(j);
  end
end
FS=FS2/FS1;

b=[0;1];
S=gama*E'*P(:,2)*FS;

for i=1:1:36
    sys(i)=S(i);
end
function sys=mdlOutputs(t,x,u)
ym=u(1);dym=u(2);
x1=u(3);x2=u(4);

for i=1:1:36
    thtau(i,1)=x(i);
end

FS1=0;
u1(1)=1/(1+exp(5*(x1+2)));
u1(6)=1/(1+exp(-5*(x1-2)));
for i=2:1:5
    u1(i)=exp(-(x1+1.5-(i-2))^2);
end

u2(1)=1/(1+exp(5*(x2+2)));
u2(6)=1/(1+exp(-5*(x2-2)));
for i=2:1:5
    u2(i)=exp(-(x2+1.5-(i-2))^2);
end

for i=1:1:6
  for j=1:1:6
    FS2(6*(i-1)+j)=u1(i)*u2(j);
    FS1=FS1+u1(i)*u2(j);
  end
end
FS=FS2/FS1;

ut=thtau'*FS';
sys(1)=ut;