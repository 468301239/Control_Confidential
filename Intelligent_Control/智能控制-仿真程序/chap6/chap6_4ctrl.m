function [sys,x0,str,ts] = MIMO_Tong_s(t,x,u,flag)
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
global Fai
Fai=[30 0;0 30];
sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.1];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global Fai
qd1=u(1);
qd2=u(2);
dqd1=0.3*cos(t);
dqd2=0.3*cos(t);
dqd=[dqd1 dqd2]';

ddqd1=-0.3*sin(t);
ddqd2=-0.3*sin(t);
ddqd=[ddqd1 ddqd2]';

q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fsd1=0;
for l1=1:1:5
    gs1=-[(dq1+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
	u1(l1)=exp(gs1);
end
fsd2=0;
for l2=1:1:5
    gs2=-[(dq2+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
	u2(l2)=exp(gs2);
end
for l1=1:1:5
    fsu1(l1)=u1(l1);
	fsd1=fsd1+u1(l1);
end
for l2=1:1:5
    fsu2(l2)=u2(l2);
	fsd2=fsd2+u2(l2);
end
fs1=fsu1/(fsd1+0.001);
fs2=fsu2/(fsd2+0.001);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e1=q1-qd1;
e2=q2-qd2;
e=[e1 e2]';
de1=dq1-dqd1;
de2=dq2-dqd2;
de=[de1 de2]';

s=de+Fai*e;

faip=x(1);
Kesi=[fs1 fs2]';

gama=150;
miu=30;
k=2*miu/gama;
sys(1)=gama/2*(norm(s))^2*Kesi'*Kesi-k*gama*faip;

function sys=mdlOutputs(t,x,u)
global Fai
q1=u(3);dq1=u(4);
q2=u(5);dq2=u(6);

r1=1;r2=0.8;
m1=1;m2=1.5;

D11=(m1+m2)*r1^2+m2*r2^2+2*m2*r1*r2*cos(q2);
D22=m2*r2^2;
D21=m2*r2^2+m2*r1*r2*cos(q2);
D12=D21;
D=[D11 D12;D21 D22];

C12=m2*r1*sin(q2);
C=[-C12*dq2 -C12*(dq1+dq2);C12*q1 0];

g1=(m1+m2)*r1*cos(q2)+m2*r2*cos(q1+q2);
g2=m2*r2*cos(q1+q2);
G=[g1;g2];

qd1=u(1);
qd2=u(2);
dqd1=0.3*cos(t);
dqd2=0.3*cos(t);
dqd=[dqd1 dqd2]';

ddqd1=-0.3*sin(t);
ddqd2=-0.3*sin(t);
ddqd=[ddqd1 ddqd2]';

e1=q1-qd1;
e2=q2-qd2;
e=[e1 e2]';
de1=dq1-dqd1;
de2=dq2-dqd2;
de=[de1 de2]';

s=de+Fai*e;

dqr=dqd-Fai*e;
ddqr=ddqd-Fai*de;


fsd1=0;
for l1=1:1:5
    gs1=-[(dq1+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
	u1(l1)=exp(gs1);
end
fsd2=0;
for l2=1:1:5
    gs2=-[(dq2+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
	u2(l2)=exp(gs2);
end

for l1=1:1:5
    fsu1(l1)=u1(l1);
	fsd1=fsd1+u1(l1);
end
for l2=1:1:5
    fsu2(l2)=u2(l2);
	fsd2=fsd2+u2(l2);
end
fs1=fsu1/(fsd1+0.001);
fs2=fsu2/(fsd2+0.001);

% Fp(1)=thta1'*fs1';
% Fp(2)=thta2'*fs2';

KD=10*eye(2);
W=[0.2 0;0 0.2];

%tol=D*ddqr+C*dqr+G+1*Fp'-KD*s-W*sign(s);
faip=x(1);
Kesi=[fs1 fs2]';
tol=D*ddqr+C*dqr+G-0.5*s*faip*Kesi'*Kesi-KD*s-W*sign(s);

sys(1)=tol(1);
sys(2)=tol(2);