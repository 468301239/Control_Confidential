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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0 =[1 0];
str = [];
ts = [];
function sys=mdlDerivatives(t,x,u)
A=[0 1;
   0 0];
B=[0 1]';
    
ut=u(1);
fx=10*x(1)*x(2);
dx=A*x+B*(ut+fx);

sys(1)=dx(1);
sys(2)=dx(2);
function sys=mdlOutputs(t,x,u)
fx=10*x(1)*x(2);
sys(1)=x(1);
sys(2)=x(2);