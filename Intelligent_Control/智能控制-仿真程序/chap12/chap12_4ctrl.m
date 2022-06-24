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
global node c b Fai
node=7;
c=1*[-1.5 -1 -0.5 0 0.5 1 1.5;
       -1.5 -1 -0.5 0 0.5 1 1.5;
       -1.5 -1 -0.5 0 0.5 1 1.5;
       -1.5 -1 -0.5 0 0.5 1 1.5;
       -1.5 -1 -0.5 0 0.5 1 1.5];
b=0.1;
Fai=100*eye(2);

sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0];
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global node c b Fai
qd1=u(1);
d_qd1=u(2);
dd_qd1=u(3);
qd2=u(4);
d_qd2=u(5);
dd_qd2=u(6);

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);


%q=[q1;q2];
e1=qd1-q1;
e2=qd2-q2;
de1=d_qd1-d_q1;
de2=d_qd2-d_q2;
e=[e1;e2];
de=[de1;de2];
r=de+Fai*e;

qd=[qd1;qd2];
dqd=[d_qd1;d_qd2];
ddqd=[dd_qd1;dd_qd2];

z1=[e(1);de(1);qd(1);dqd(1);ddqd(1)];
z2=[e(2);de(2);qd(2);dqd(2);ddqd(2)];

h1=zeros(7,1);
h2=zeros(7,1);
for j=1:1:node
    h1(j)=exp(-norm(z1-c(:,j))^2/(b*b));
    h2(j)=exp(-norm(z2-c(:,j))^2/(b*b));
end

gama=5;
sys(1)=gama/2*((r(1))^2*(h1'*h1)+(r(2))^2*(h2'*h2))-gama*x(1);
function sys=mdlOutputs(t,x,u)
global node c b Fai
qd1=u(1);
d_qd1=u(2);
dd_qd1=u(3);
qd2=u(4);
d_qd2=u(5);
dd_qd2=u(6);

q1=u(7);
d_q1=u(8);
q2=u(9);
d_q2=u(10);

q=[q1;q2];

e1=qd1-q1;
e2=qd2-q2;
de1=d_qd1-d_q1;
de2=d_qd2-d_q2;
e=[e1;e2];
de=[de1;de2];
r=de+Fai*e;

qd=[qd1;qd2];
dqd=[d_qd1;d_qd2];
ddqd=[dd_qd1;dd_qd2];

%z=[e;de;qd;dqd;ddqd];

faip=x(1);

z1=[e(1);de(1);qd(1);dqd(1);ddqd(1)];
z2=[e(2);de(2);qd(2);dqd(2);ddqd(2)];
h1=zeros(7,1);
h2=zeros(7,1);
for j=1:1:node
    h1(j)=exp(-norm(z1-c(:,j))^2/(b*b));
    h2(j)=exp(-norm(z2-c(:,j))^2/(b*b));
end

p=[2.9 0.76 0.87 3.04 0.87];
M=[p(1)+p(2)+2*p(3)*cos(q2) p(2)+p(3)*cos(q2);
    p(2)+p(3)*cos(q2) p(2)];

H=[h1 h2];
Kp=100*eye(2);
epN=1;

M=2;
if M==1
    sat=sign(r);
elseif M==2 %Saturated function 
   fai0=0.05;
   if abs(r)<=fai0
      sat=r/fai0;
   else
      sat=sign(r);
   end
end
v=-epN*sat;
H_norm=norm(H)^2;

tol=(faip.*r)/2*H_norm^2+Kp*r-v;    

sys(1)=tol(1);
sys(2)=tol(2);