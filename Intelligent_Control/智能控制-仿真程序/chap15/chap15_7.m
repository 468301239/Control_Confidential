clear all;
close all;

Size=50;  %样本个数
D=4;      %每个样本有４个固定点,即分成4段,插值点个数为D+2

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
%***************初始化路径**************%
for i=1:Size
    for j=1:D
    Path(i,j)=rand*(thd-th0)+th0;
    end
end

%先进行三次样条插值，此为D=4时的特殊情况%
        XX(1)=0;XX(2)=200*ts;XX(3)=400*ts;XX(4)=600*ts;XX(5)=800*ts;XX(6)=1000*ts;
        YY(1)=th0;YY(6)=thd;
        YY(2)=Path(i,1);YY(3)=Path(i,2);YY(4)=Path(i,3);YY(5)=Path(i,4);
%输出插值拟合后的曲线，注意步长nt的一致,此时输出1000个点
        Path_spline=spline(XX,YY,linspace(0,1,1000));
        
figure(1);
plot((0:0.001:tmax),[0,thr(1:1:3000)],'k','linewidth',2);
xlabel('Time (s)');ylabel('Cycloid curve');
hold on;
plot((0:0.2:1), YY,'ko','linewidth',2);
hold on;
plot((0:0.001:TE),[0,Path_spline],'k-.','linewidth',2);
xlabel('Time (s)');ylabel('Initial Path');
legend('Cycloid curve','Interpolation points','Initial Path');