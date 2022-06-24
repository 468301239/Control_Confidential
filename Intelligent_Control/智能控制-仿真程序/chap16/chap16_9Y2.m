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
sizes.NumOutputs     = 6;
sizes.NumInputs      = 15;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
g=9.8;
theta=u(7);dtheta=u(8);ddtheta=u(9);
psi=u(10);dpsi=u(11);ddpsi=u(12);
fai=u(13);dfai=u(14);ddfai=u(15);

Y2=[ddtheta ddpsi ddfai dtheta dpsi dfai];
sys(1)=Y2(1);
sys(2)=Y2(2);
sys(3)=Y2(3);
sys(4)=Y2(4);
sys(5)=Y2(5);
sys(6)=Y2(6);





