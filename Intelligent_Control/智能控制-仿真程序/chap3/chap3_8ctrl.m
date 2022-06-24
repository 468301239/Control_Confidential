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
sizes.NumOutputs     = 3;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
persistent s0
x1=u(1);
x2=u(2);

c=50;
x1d=sin(t);dx1d=cos(t);ddx1d=-sin(t);

e=x1d-x1;
de=dx1d-x2;
s=c*e+de;

D=200;xite=3.0;
M=2;
if M==1
    K=D+xite;        % Traditional K design
elseif M==2
    K=abs(u(4))+xite; % Adjustment of K with fuzzy rule
end

ut=ddx1d+c*de+K*sign(s);
sys(1)=ut;
sys(2)=s;
sys(3)=K;