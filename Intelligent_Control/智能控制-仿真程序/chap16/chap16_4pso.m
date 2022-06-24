save para_file ut Y;
clear all;
close all;
load para_file;
n=size(ut);
N=n(1);

%%%%%%%%%%%%%%%
a1=1;a2=-0.1000;a3=0.0490;
b1=1;b2=0.1000;b3=-0.0200;
%%%%%%%%%%%%%%%

%限定位置和速度的范围
MinX=[0 -1 0 0.1 0 -1];  %参数搜索范围
MaxX=[2 0 1 2 2 0];
Vmax=1;
Vmin=-1;             %限定速度的范围 
%设计粒子群参数
Size=300;   %种群规模
CodeL=6;    %参数个数

c1=1.3;c2=1.3;         %学习因子：[1,2]
wmax=0.90;wmin=0.10;   %惯性权重最小值:(0,1)

G=200;                  %最大迭代次数
%(1)初始化种群的个体
for i=1:G         %初始化每次更新的惯性权重
    w(i)=wmax-((wmax-wmin)/G)*i;  
end  
for i=1:1:CodeL       %十进制浮点制编码
    A(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1); 
    v(:,i)=Vmin +(Vmax - Vmin)*rand(Size,1);%随机初始化速度
end
%（2）初始化个体最优和全局最优：先计算各个粒子的适应度，并初始Pi和BestS
for i=1:1:Size
    J(i)=chap16_4obj(A(i,:),ut,Y,N);
    PB(i,:)=A(i,:);   %初始化局部最优个体
end
BestS=A(1,:); %初始化全局最优个体
for i=2:Size
    if chap16_4obj(A(i,:),ut,Y,N)<chap16_4obj(BestS,ut,Y,N)
       BestS=A(i,:);
    end
end
%（3）进入主要循环，直到满足精度要求
 for kg=1:1:G
     times(kg)=kg;
    for i=1:Size
       v(i,:)=w(kg)*v(i,:)+c1*rand*(PB(i,:)-A(i,:))+c2*rand*(BestS-A(i,:));%加权，实现速度的更新
          for j=1:CodeL   %检查速度是否越界
            if v(i,j)<Vmin
                v(i,j)=Vmin;
            elseif  v(i,j)>Vmax
                v(i,j)=Vmax;
            end
          end
        A(i,:)=A(i,:)+v(i,:); %实现位置的更新
        for j=1:CodeL%检查位置是否越界
            if A(i,j)<MinX(j)
                A(i,j)=MinX(j);
            elseif  A(i,j)>MaxX(j)
                A(i,j)=MaxX(j);
            end
        end
%（4）判断和更新       
       if chap16_4obj(A(i,:),ut,Y,N)<J(i) %判断当此时的位置是否为最优的情况
          J(i)=chap16_4obj(A(i,:),ut,Y,N);
          PB(i,:)=A(i,:);
        end
        if J(i)<chap16_4obj(BestS,ut,Y,N)
          BestS=PB(i,:);
        end
    end
Best_J(kg)=chap16_4obj(BestS,ut,Y,N);
Record(kg,:)=BestS;
if Best_J(kg)<1e-6
     break
 end
 end
BestS    %最佳个体
Best_J(kg)%最佳目标函数值


%From Plant
a1=1;a2=-0.1000;a3=0.0490;
b1=1;b2=0.1000;b3=-0.0200;
disp('True value of parameters: a1=1;a2=-0.10;a3=0.049; b1=1;b2=0.10;b3=-0.02');

figure(1);%目标函数值变化曲线
plot(times,Best_J,'b','linewidth',1.5);
xlabel('Iterations');ylabel('Cost function J_2');

figure(2);%目标函数值变化曲线
para1=Record(1:kg,1);
para2=Record(1:kg,2);
para3=Record(1:kg,3);
para4=Record(1:kg,4);
para5=Record(1:kg,5);
para6=Record(1:kg,6);
plot(times,para1,'b:','linewidth',1.5);
hold on;
plot(times,para2,'b-','linewidth',1.5);
hold on;
plot(times,para3,'r:','linewidth',1.5);
hold on;
plot(times,para4,'r:','linewidth',1.5);
hold on;
plot(times,para5,'r:','linewidth',1.5);
hold on;
plot(times,para6,'r-','linewidth',1.5);
xlabel('Iteration');ylabel('Identified value');
legend('a1','a2','a3','b1','b2','b3');


%最小二乘算法
M=1;
if M==2
told=[0 ut]';
xitep=told*inv(Y*Y')*Y'
end