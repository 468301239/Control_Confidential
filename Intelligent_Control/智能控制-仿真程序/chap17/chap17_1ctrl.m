function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
qm=u(1);dqm=u(2);qs=u(3);dqs=u(4);
em=qm-qs;es=qs-qm;
dem=dqm-dqs;
des=dqs-dqm;

km=10;ks=10;
nm=10;ns=10;

rm=dqm+nm*em;
rs=dqs+ns*es;

dM=0.50;dS=0.50;

fai=0.02;
if abs(rm)<=fai
   rm_sat=rm/fai;
else
   rm_sat=sign(rm);
end
if abs(rs)<=fai
   rs_sat=rs/fai;
else
   rs_sat=sign(rs);
end

%vm=dM*sign(rm);vs=dS*sign(rs);
vm=dM*rm_sat;vs=dS*rs_sat;
tolm=-km*rm-vm-nm*dem;
tols=-ks*rs-vs-ns*des;

sys(1)=tolm;
sys(2)=tols;