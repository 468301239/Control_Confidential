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
sizes = simsizes;
sizes.NumContStates  = 12;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 15;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0 0 0 0 0 0 0 0 0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
V1=u(1);V2=u(2);V3=u(3);V4=u(4);
g=9.8;m=2.15;l=0.25;
I1=1.28;I2=1.26;I3=2.87;
C=1.33;
K1=0.11;K2=0.12;K3=0.13;
K4=0.17;K5=0.16;K6=0.15;
alfa=[1/m K1/m K2/m K3/m l/I1 l*K4/I1 l/I2 l*K5/I2 C/I3 l*K6/I3];

theta=x(7);dtheta=x(8);
psi=x(9);dpsi=x(10);
fai=x(11);dfai=x(12);

dx=x(2);
ddx=V1*alfa(1)*(cos(fai)*sin(theta)*cos(psi)+sin(fai)*sin(psi))-alfa(2)*dx;
dy=x(4);
ddy=V1*alfa(1)*(sin(fai)*sin(theta)*cos(psi)-cos(fai)*sin(psi))-alfa(3)*dy;
dz=x(6);
ddz=V1*alfa(1)*cos(fai)*cos(psi)-g-alfa(4)*dz;

ddtheta=V2*alfa(5)-alfa(6)*dtheta;
ddpsi=V3*alfa(7)-alfa(8)*dpsi;
ddfai=V4*alfa(9)-alfa(10)*dfai;

sys(1)=x(2);
sys(2)=ddx;
sys(3)=x(4);
sys(4)=ddy;
sys(5)=x(6);
sys(6)=ddz;

sys(7)=x(8);
sys(8)=ddtheta;
sys(9)=x(10);
sys(10)=ddpsi;
sys(11)=x(12);
sys(12)=ddfai;
function sys=mdlOutputs(t,x,u)
V1=u(1);V2=u(2);V3=u(3);V4=u(4);

g=9.8;m=2.15;l=0.25;
I1=1.28;I2=1.26;I3=2.87;
C=1.33;
K1=0.11;K2=0.12;K3=0.13;
K4=0.17;K5=0.16;K6=0.15;

alfa=[1/m K1/m K2/m K3/m l/I1 l*K4/I1 l/I2 l*K5/I2 C/I3 l*K6/I3];

theta=x(7);dtheta=x(8);
psi=x(9);dpsi=x(10);
fai=x(11);dfai=x(12);

dx=x(2);
ddx=V1*alfa(1)*(cos(fai)*sin(theta)*cos(psi)+sin(fai)*sin(psi))-alfa(2)*dx;
dy=x(4);
ddy=V1*alfa(1)*(sin(fai)*sin(theta)*cos(psi)-cos(fai)*sin(psi))-alfa(3)*dy;
dz=x(6);
ddz=V1*alfa(1)*cos(fai)*cos(psi)-g-alfa(4)*dz;

ddtheta=V2*alfa(5)-alfa(6)*dtheta;
ddpsi=V3*alfa(7)-alfa(8)*dpsi;
ddfai=V4*alfa(9)-alfa(10)*dfai;

sys(1)=x(2);
sys(2)=ddx;
sys(3)=x(4);
sys(4)=ddy;
sys(5)=x(6);
sys(6)=ddz;

sys(7)=x(7);     %theta
sys(8)=x(8);     
sys(9)=ddtheta;
sys(10)=x(9);    %psi
sys(11)=x(10);
sys(12)=ddpsi;
sys(13)=x(11);   %fai
sys(14)=x(12);
sys(15)=ddfai;