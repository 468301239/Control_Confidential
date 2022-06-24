function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 9;
sizes.NumInputs      = 15;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
g=9.8;
dx=u(1);ddx=u(2);
dy=u(3);ddy=u(4);
dz=u(5);ddz=u(6);

theta=u(7);dtheta=u(8);ddtheta=u(9);
psi=u(10);dpsi=u(11);ddpsi=u(12);
fai=u(13);dfai=u(14);ddfai=u(15);

k1=cos(fai)*cos(psi)*sin(theta)+sin(fai)*sin(psi);
k2=sin(fai)*sin(theta)*cos(psi)-cos(fai)*sin(psi);
k3=cos(fai)*cos(psi);

Y1=[ddx ddy ddz+g dx dy dz]';
sys(1)=Y1(1);
sys(2)=Y1(2);
sys(3)=Y1(3);
sys(4)=Y1(4);
sys(5)=Y1(5);
sys(6)=Y1(6);
sys(7)=k1;
sys(8)=k2;
sys(9)=k3;



