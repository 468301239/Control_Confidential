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
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0;0];
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
%%%%%%%%%%%%%%%%%%%%
Vt=200;g=9.8;Lop=-0.1;Lap=1;Ma=0.1;Mq=-0.02;Md=1;
a3=g/Vt;a2=Lop;a1=Lap;
b1=Md;b2=Ma;b3=Mq;
%%%%%%%%%%%%%%%%%%%%
ut=u(1);
sys(1)=a1*x(2)-a1*x(1)+a2-a3*cos(x(1));
sys(2)=x(3);
sys(3)=b1*ut+b2*(x(2)-x(1))+b3*x(3);
function sys=mdlOutputs(t,x,u)
ut=u(1);
Vt=200;g=9.8;Lop=-0.1;Lap=1;Ma=0.1;Mq=-0.02;Md=1;
a3=g/Vt;a2=Lop;a1=Lap;
b1=Md;b2=Ma;b3=Mq;
dx1=a1*x(2)-a1*x(1)+a2-a3*cos(x(1));
dx2=x(3);
dx3=b1*ut+b2*(x(2)-x(1))+b3*x(3);
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=dx1;
sys(5)=dx2;
sys(6)=dx3;