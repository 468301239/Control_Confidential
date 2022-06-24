clear all;
close all;

TE=1;     %参考轨迹参数TE
thd=0.50;
tmax=3*TE;  %仿真时间

n=500;
ts=TE/(2*n); %将TE分为1000个点，每段长度(步长)为ts

G=tmax/ts;  %仿真时间为G=3000
%***************摆线参考轨迹*************%
th0=0;

     
for k=1:1:G
t(k)=k*ts;  %t(1)=0.001;t(2)=0.002;.....
if t(k)<TE
    thr(k)=(thd-th0)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+th0;   %不含原点的参考轨迹(1)
else 
    thr(k)=thd;
end
end

figure(1);
plot((0:0.001:tmax),[0,thr(1:1:G)],'k','linewidth',2);
xlabel('Time (s)');ylabel('theta_r, Cycloid curve');