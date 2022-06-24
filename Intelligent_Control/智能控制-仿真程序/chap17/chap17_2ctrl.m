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
sizes.NumContStates  = 10;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = 0*ones(1,10);
str = [];
ts  = [0 0];
function sys=mdlDerivatives(t,x,u)
cij=[-1 -0.5 0 0.5 1];bj=3.0;

qm=u(1);dqm=u(2);qs=u(3);dqs=u(4);
em=qm-qs;es=qs-qm;
dem=dqm-dqs;des=dqs-dqm;

km=10;ks=10;
nm=10;ns=10;

rm=dqm+nm*em;
rs=dqs+ns*es;

for j=1:1:5
    h1(j)=exp(-norm(dqm-cij(:,j))^2/(2*bj^2));
    h2(j)=exp(-norm(dqs-cij(:,j))^2/(2*bj^2));
end

gama1=10;gama2=10;
for i=1:1:5
    sys(i)=-gama1*rm*h1(i);
    sys(i+5)=-gama2*rs*h2(i);
end

function sys=mdlOutputs(t,x,u)
cij=[-1 -0.5 0 0.5 1];bj=3.0;

qm=u(1);dqm=u(2);qs=u(3);dqs=u(4);
em=qm-qs;es=qs-qm;
dem=dqm-dqs;
des=dqs-dqm;

km=10;ks=10;
nm=10;ns=10;

rm=dqm+nm*em;
rs=dqs+ns*es;

epcM=0.10;epcS=0.10;
%vm=epcM*sign(rm);vs=epcS*sign(rs);

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
vm=epcM*rm_sat;vs=epcS*rs_sat;

x1=dqm;x2=dqs;
for j=1:1:5
    h1(j)=exp(-norm(x1-cij(:,j))^2/(2*bj^2));
end
for j=1:1:5
    h2(j)=exp(-norm(x2-cij(:,j))^2/(2*bj^2));
end
Wm=[x(1) x(2) x(3) x(4) x(5)];
Ws=[x(6) x(7) x(8) x(9) x(10)];

fmp=Wm*h1';
fsp=Ws*h2';

tolm=fmp-km*rm-vm-nm*dem;
tols=fsp-ks*rs-vs-ns*des;

sys(1)=tolm;
sys(2)=tols;