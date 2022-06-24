function [sys,x0,str,ts] = input(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumOutputs=4;
sizes.NumInputs=0;
sizes.DirFeedthrough=0;
sizes.NumSampleTimes=0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
F1=200*sin(t+pi/4);
F2=-100*sin(t);
F3=200*sin(t+pi/4);
F4=-20*sin(t);
V1=F1+F2+F3+F4;
V2=-F1-F2+F3+F4;
V3=-F1+F2+F3-F4;
V4=F1-F2+F3-F4;
sys(1)=V1;
sys(2)=V2;
sys(3)=V3;
sys(4)=V4;



