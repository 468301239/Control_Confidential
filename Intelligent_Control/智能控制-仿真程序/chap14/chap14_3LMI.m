clear all;
close all;

A=[0 1;
   0 0];
B=[0 1]';

P=sdpvar(2,2,'symmetric');
Q=sdpvar(2,2,'symmetric');
R=sdpvar(1,2);

alfa=3;
delta=10;

Fai=A*Q+B*R+(A*Q+B*R)'+delta*B*B'+alfa*Q;

%First LMI
L1=set(Fai<0);
L2=set(Q>0);
L=L1+L2;
solvesdp(L);

Q=double(Q);
R=double(R);

P=inv(Q)
K=R*inv(Q)