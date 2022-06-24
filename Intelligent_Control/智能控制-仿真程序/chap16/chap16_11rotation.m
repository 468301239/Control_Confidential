save para_file told Y1 Y2;
clear all;
close all;
load para_file;
n=size(told);
N=n(1);
Record=0*ones(80,6);
%限定位置和速度的范围
MinX=[0 0 0 0 0 0];  %参数搜索范围
MaxX=[1 1 1 1 1 1];
Vmax=1;
Vmin=-1;             %限定速度的范围 
%设计粒子群参数
Size=300;   %种群规模
CodeL=6;    %参数个数
c1=1.3;c2=1.7;         %学习因子：[1,2]
wmax=0.90;wmin=0.10;   %惯性权重最小值:(0,1)
G=100;                  %最大迭代次数
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
    J(i)=chap16_11obj(A(i,:),told,Y2,N);
    PB(i,:)=A(i,:);   %初始化局部最优个体
end
BestS=A(1,:); %初始化全局最优个体
for i=2:Size
    if chap16_11obj(A(i,:),told,Y2,N)<chap16_11obj(BestS,told,Y2,N)
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
       if chap16_11obj(A(i,:),told,Y2,N)<J(i) %判断当此时的位置是否为最优的情况
          J(i)=chap16_11obj(A(i,:),told,Y2,N);
          PB(i,:)=A(i,:);
        end
        if J(i)<chap16_11obj(BestS,told,Y2,N)
          BestS=PB(i,:);
        end
    end
Best_J(kg)=chap16_11obj(BestS,told,Y2,N);
Record(kg,:)=BestS;
if Best_J(kg)<1e-4
     break
 end
 end
BestS    %最佳个体
Best_J(kg)%最佳目标函数值

disp('True value of rotation parameters:  0.1953    0.0332    0.1984    0.0317    0.4634    0.0131');
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
plot(times,para4,'r-','linewidth',1.5);
hold on;
plot(times,para5,'k:','linewidth',1.5);
hold on;
plot(times,para6,'k-','linewidth',1.5);
xlabel('Iteration');ylabel('Identified value');
legend('\alpha_5','\alpha_6','\alpha_7','\alpha_8','\alpha_9','\alpha_1_0');