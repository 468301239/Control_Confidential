clear all;
close all;
load para_file;
n=size(told);
N=n(1);
MinX=[0 0 0 0];  %����������Χ
MaxX=[1 1 1 1];

Size=50;   %��Ⱥ��ģ
CodeL=4;   %��������

F=0.7;        % �������ӣ�[1,2]
cr =0.6;      % ��������
G=200;              % ���������� 
%��ʼ����Ⱥ�ĸ���
for i=1:1:CodeL       
    P(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

BestS=P(1,:); %ȫ�����Ÿ���
for i=2:Size
        if chap16_12obj(P(i,:),told,Y1,N)<chap16_12obj(BestS,told,Y1,N)
        BestS=P(i,:);
    end
end
Ji=chap16_12obj(BestS,told,Y1,N);
%������Ҫѭ����ֱ�����㾫��Ҫ��
for kg=1:1:G
     times(kg)=kg;
%����
    for i=1:Size
        r1 = 1;r2=1;r3=1;r4=1;
        while(r1 == r2|| r1 ==r3 || r2 == r3 || r1 == i|| r2 ==i || r3 == i||r4==i ||r1==r4||r2==r4||r3==r4 )
            r1 = ceil(Size * rand(1));
             r2 = ceil(Size * rand(1));
              r3 = ceil(Size * rand(1));
              r4 = ceil(Size * rand(1));
        end
        h(i,:)=BestS+F*(P(r1,:)-P(r2,:));
        
        for j=1:CodeL%���λ���Ƿ�Խ��
            if h(i,j)<MinX(j)
                h(i,j)=MinX(j);
            elseif h(i,j)>MaxX(j)
                h(i,j)=MaxX(j);
            end
        end
%����
        for j = 1:1:CodeL
              tempr = rand(1);
              if(tempr<cr)
                  v(i,j) = h(i,j);
               else
                  v(i,j) = P(i,j);
               end
        end
%ѡ��        
        if(chap16_12obj(v(i,:),told,Y1,N)<chap16_12obj(P(i,:),told,Y1,N))
            P(i,:)=v(i,:);
        end
%�жϺ͸���       
       if chap16_12obj(P(i,:),told,Y1,N)<Ji %�жϵ���ʱ��λ���Ƿ�Ϊ���ŵ����
          Ji=chap16_12obj(P(i,:),told,Y1,N);
          BestS=P(i,:);
        end
      
    end
Best_J(kg)=chap16_12obj(BestS,told,Y1,N);
Record(kg,:)=BestS;
end
disp('the transtition parameters are:0.4651    0.0512    0.0558    0.0605');
BestS    %��Ѹ���
Best_J(kg)%���Ŀ�꺯��ֵ
figure(1);%Ŀ�꺯��ֵ�仯����
plot(times,Best_J(times),'k','linewidth',2);
xlabel('Iterations');ylabel('Best J');

figure(2);%Ŀ�꺯��ֵ�仯����
alfa1=[Record(:,1)'];
alfa2=[Record(:,2)'];
alfa3=[Record(:,3)'];
alfa4=[Record(:,4)'];

plot(times,alfa1,'b:','linewidth',2);
hold on;
plot(times,alfa2,'b-','linewidth',2);
hold on;
plot(times,alfa3,'r:','linewidth',2);
hold on;
plot(times,alfa4,'r-','linewidth',2);
xlabel('Iterations');ylabel('Identified value');
legend('\alpha_1','\alpha_2','\alpha_3','\alpha_4');