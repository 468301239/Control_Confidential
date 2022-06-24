clear all;
close all;

Size=50;  %��������
D=4;      %ÿ�������У����̶���,���ֳ�4��,��ֵ�����ΪD+2

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
%***************��ʼ��·��**************%
for i=1:Size
    for j=1:D
    Path(i,j)=rand*(thd-th0)+th0;
    end
end

%�Ƚ�������������ֵ����ΪD=4ʱ���������%
        XX(1)=0;XX(2)=200*ts;XX(3)=400*ts;XX(4)=600*ts;XX(5)=800*ts;XX(6)=1000*ts;
        YY(1)=th0;YY(6)=thd;
        YY(2)=Path(i,1);YY(3)=Path(i,2);YY(4)=Path(i,3);YY(5)=Path(i,4);
%�����ֵ��Ϻ�����ߣ�ע�ⲽ��nt��һ��,��ʱ���1000����
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