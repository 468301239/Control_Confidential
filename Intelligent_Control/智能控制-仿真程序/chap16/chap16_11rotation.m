save para_file told Y1 Y2;
clear all;
close all;
load para_file;
n=size(told);
N=n(1);
Record=0*ones(80,6);
%�޶�λ�ú��ٶȵķ�Χ
MinX=[0 0 0 0 0 0];  %����������Χ
MaxX=[1 1 1 1 1 1];
Vmax=1;
Vmin=-1;             %�޶��ٶȵķ�Χ 
%�������Ⱥ����
Size=300;   %��Ⱥ��ģ
CodeL=6;    %��������
c1=1.3;c2=1.7;         %ѧϰ���ӣ�[1,2]
wmax=0.90;wmin=0.10;   %����Ȩ����Сֵ:(0,1)
G=100;                  %����������
%(1)��ʼ����Ⱥ�ĸ���
for i=1:G         %��ʼ��ÿ�θ��µĹ���Ȩ��
    w(i)=wmax-((wmax-wmin)/G)*i;  
end  
for i=1:1:CodeL       %ʮ���Ƹ����Ʊ���
    A(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1); 
    v(:,i)=Vmin +(Vmax - Vmin)*rand(Size,1);%�����ʼ���ٶ�
end
%��2����ʼ���������ź�ȫ�����ţ��ȼ���������ӵ���Ӧ�ȣ�����ʼPi��BestS
for i=1:1:Size
    J(i)=chap16_11obj(A(i,:),told,Y2,N);
    PB(i,:)=A(i,:);   %��ʼ���ֲ����Ÿ���
end
BestS=A(1,:); %��ʼ��ȫ�����Ÿ���
for i=2:Size
    if chap16_11obj(A(i,:),told,Y2,N)<chap16_11obj(BestS,told,Y2,N)
       BestS=A(i,:);
    end
end
%��3��������Ҫѭ����ֱ�����㾫��Ҫ��
 for kg=1:1:G
     times(kg)=kg;
    for i=1:Size
       v(i,:)=w(kg)*v(i,:)+c1*rand*(PB(i,:)-A(i,:))+c2*rand*(BestS-A(i,:));%��Ȩ��ʵ���ٶȵĸ���
          for j=1:CodeL   %����ٶ��Ƿ�Խ��
            if v(i,j)<Vmin
                v(i,j)=Vmin;
            elseif  v(i,j)>Vmax
                v(i,j)=Vmax;
            end
          end
        A(i,:)=A(i,:)+v(i,:); %ʵ��λ�õĸ���
        for j=1:CodeL%���λ���Ƿ�Խ��
            if A(i,j)<MinX(j)
                A(i,j)=MinX(j);
            elseif  A(i,j)>MaxX(j)
                A(i,j)=MaxX(j);
            end
        end
%��4���жϺ͸���       
       if chap16_11obj(A(i,:),told,Y2,N)<J(i) %�жϵ���ʱ��λ���Ƿ�Ϊ���ŵ����
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
BestS    %��Ѹ���
Best_J(kg)%���Ŀ�꺯��ֵ

disp('True value of rotation parameters:  0.1953    0.0332    0.1984    0.0317    0.4634    0.0131');
figure(1);%Ŀ�꺯��ֵ�仯����
plot(times,Best_J,'b','linewidth',1.5);
xlabel('Iterations');ylabel('Cost function J_2');

figure(2);%Ŀ�꺯��ֵ�仯����
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