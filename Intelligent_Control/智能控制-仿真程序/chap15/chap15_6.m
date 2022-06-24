clear all;
close all;

TE=1;     %�ο��켣����TE
thd=0.50;
tmax=3*TE;  %����ʱ��

n=500;
ts=TE/(2*n); %��TE��Ϊ1000���㣬ÿ�γ���(����)Ϊts

G=tmax/ts;  %����ʱ��ΪG=3000
%***************���߲ο��켣*************%
th0=0;

     
for k=1:1:G
t(k)=k*ts;  %t(1)=0.001;t(2)=0.002;.....
if t(k)<TE
    thr(k)=(thd-th0)*(t(k)/TE-1/(2*pi)*sin(2*pi*t(k)/TE))+th0;   %����ԭ��Ĳο��켣(1)
else 
    thr(k)=thd;
end
end

figure(1);
plot((0:0.001:tmax),[0,thr(1:1:G)],'k','linewidth',2);
xlabel('Time (s)');ylabel('theta_r, Cycloid curve');