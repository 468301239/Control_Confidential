save para_file ut Y;
clear all;
close all;
load para_file;
n=size(ut);
N=n(1);
%�޶�λ�ú��ٶȵķ�Χ
MinX=[0 0 0 1000];  %����������Χ
MaxX=[5 5 10 1500];
Vmax=1;
Vmin=-1;             %�޶��ٶȵķ�Χ 
%�������Ⱥ����
Size=300;   %��Ⱥ��ģ
CodeL=4;    %��������

c1=1.3;c2=1.3;         %ѧϰ���ӣ�[1,2]
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
    J(i)=chap16_2obj(A(i,:),ut,Y,N);
    PB(i,:)=A(i,:);   %��ʼ���ֲ����Ÿ���
end
BestS=A(1,:); %��ʼ��ȫ�����Ÿ���
for i=2:Size
    if chap16_2obj(A(i,:),ut,Y,N)<chap16_2obj(BestS,ut,Y,N)
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
       if chap16_2obj(A(i,:),ut,Y,N)<J(i) %�жϵ���ʱ��λ���Ƿ�Ϊ���ŵ����
          J(i)=chap16_2obj(A(i,:),ut,Y,N);
          PB(i,:)=A(i,:);
        end
        if J(i)<chap16_2obj(BestS,ut,Y,N)
          BestS=PB(i,:);
        end
    end
Best_J(kg)=chap16_2obj(BestS,ut,Y,N);
Record(kg,:)=BestS;
if Best_J(kg)<1e-5
     break
 end
 end
BestS    %��Ѹ���
Best_J(kg)%���Ŀ�꺯��ֵ

disp('True value of rotation parameters:  1.0    1.0    5.0    1200');
figure(1);%Ŀ�꺯��ֵ�仯����
plot(times,Best_J,'b','linewidth',1.5);
xlabel('Iterations');ylabel('Cost function J_2');

figure(2);%Ŀ�꺯��ֵ�仯����
para1=Record(1:kg,1);
para2=Record(1:kg,2);
para3=Record(1:kg,3);
para4=Record(1:kg,4);

plot(times,para1,'b:','linewidth',1.5);
hold on;
plot(times,para2,'b-','linewidth',1.5);
hold on;
plot(times,para3,'r:','linewidth',1.5);
hold on;
plot(times,para4,'r-','linewidth',1.5);
xlabel('Iteration');ylabel('Identified value');
legend('I','J','MgL','K');


%��С�����㷨
M=1;
if M==2
    told=[ut ut]';
    xitep=told*inv(Y*Y')*Y'
end