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
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0.1];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
b=10;
ut=u(1);
dt=0.5*sin(t);
fx=10*x(1);
sys(1)=b*ut+fx+dt; 
function sys=mdlOutputs(t,x,u)
fx=10*x(1);
sys(1)=x(1);
sys(2)=fx;