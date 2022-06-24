close all;

figure(1);
subplot(211);
plot(t,sin(t),'r',t,y(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');

kb1=0.51;  %kb must bigger than z1(0)
figure(3);
plot(t,kb1,'r',t,-kb1,'k',t,z1(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('z1');

figure(4);
plot(t,y(:,3),'r',t,fn,'k','linewidth',2);
xlabel('time(s)');ylabel('fx and fn');