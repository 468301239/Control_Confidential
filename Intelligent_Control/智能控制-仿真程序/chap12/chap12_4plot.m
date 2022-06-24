close all;

figure(1);
subplot(211);
plot(t,x1(:,1),'r',t,x1(:,2),'b-.','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking of link 1');
legend('Ideal angle signal','Tracking signal');
subplot(212);
plot(t,x2(:,1),'r',t,x2(:,2),'b-.','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking of link 2');
legend('Ideal angle signal','Tracking signal');

figure(2);
subplot(211);
plot(t,x3(:,1),'r',t,x3(:,2),'b-.','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link 1');
legend('Ideal speed signal','Tracking signal');
subplot(212);
plot(t,x4(:,1),'r',t,x4(:,2),'b-.','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking of link 2');
legend('Ideal speed signal','Tracking signal');

figure(3);
subplot(211);
plot(t,tol1(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of link 1');  
subplot(212);
plot(t,tol2(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input of link 2');