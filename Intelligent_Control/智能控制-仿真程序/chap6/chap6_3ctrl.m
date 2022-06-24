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
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[0.1];
str=[];
ts=[0 0];
function sys=mdlDerivatives(t,x,u)
thd=sin(t);
dthd=cos(t);

x1=u(2);
x2=u(3);
e=x1-thd;
de=x2-dthd;
c=15;
s=c*e+de;

xi=[x1;x2];

FS1=0;
for l1=1:1:5
    gs1=-[(x1+pi/3-(l1-1)*pi/6)/(pi/12)]^2;
	u1(l1)=exp(gs1);
end

for l2=1:1:5
    gs2=-[(x2+pi/3-(l2-1)*pi/6)/(pi/12)]^2;
	u2(l2)=exp(gs2);
end
for l1=1:1:5
	for l2=1:1:5
		FS2(5*(l1-1)+l2)=u1(l1)*u2(l2);
		FS1=FS1+u1(l1)*u2(l2);
	end
end
kesi=FS2/(FS1+0.001);

gama=150;
miu=30;
k=2*miu/gama;
sys(1)=gama/2*s^2*kesi*kesi'-k*gama*x;
function sys=mdlOutputs(t,x,u)
thd=sin(t);
dthd=cos(t);
ddthd=-sin(t);

x1=u(2);
x2=u(3);
e=x1-thd;
de=x2-dthd;
c=15;
s=c*e+de;

fi=x;
xi=[x1;x2];

FS1=0;
for l1=1:1:5
   gs1=-[(x1+pi/3-(l1-1)*pi/6)/(pi/12)]^2;
   u1(l1)=exp(gs1);
end
for l2=1:1:5
   gs2=-[(x2+pi/3-(l2-1)*pi/6)/(pi/12)]^2;
   u2(l2)=exp(gs2);
end
for l1=1:1:5
	for l2=1:1:5
		FS2(5*(l1-1)+l2)=u1(l1)*u2(l2);
		FS1=FS1+u1(l1)*u2(l2);
	end
end
kesi=FS2/(FS1+0.001);

b=10;
xite=0.5;miu=30;

ut=1/b*(-0.5*s*fi*kesi*kesi'+ddthd-c*de-xite*sign(s)-miu*s);

sys(1)=ut;