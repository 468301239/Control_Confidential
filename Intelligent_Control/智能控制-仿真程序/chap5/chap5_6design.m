clear all;
close all;

g=9.8;m=2.0;M=8.0;l=0.5;
a=l/(m+M);beta=cos(88*pi/180);

a1=4*l/3-a*m*l;
A1=[0 1;g/a1 0];
B1=[0 ;-a/a1];

a2=4*l/3-a*m*l*beta^2;

A2=[0 1;2*g/(pi*a2) 0];
B2=[0;-a*beta/a2];

A3=[0 1;2*g/(pi*a2) 0];
B3=[0;a*beta/a2];

A4=[0 1;0 0];
B4=[0;a/a1];

%P0=[-3-0.3i;-3+0.3i];%Stable poles
% K1=place(A1,B1,P0)
% K2=place(A2,B2,P0)
% K3=place(A3,B3,P0)
% K4=place(A4,B4,P0)

%P0=[-10;-1];     
P0=[-2;-2];   %Stable poles  配置的极点有重极点，不能用place命令而用acker命令
K1=acker(A1,B1,P0)
K2=acker(A2,B2,P0)
K3=acker(A3,B3,P0)
K4=acker(A4,B4,P0)

save Ki_file K1 K2 K3 K4;