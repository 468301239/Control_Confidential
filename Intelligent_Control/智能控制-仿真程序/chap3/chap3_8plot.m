close all;

figure(1);
subplot(211);
plot(t,sin(t),'k',t,y(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('Position tracking');
legend('Ideal position signal','tracking signal');
subplot(212);
plot(t,cos(t),'k',t,y(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');
legend('Ideal speed signal','tracking signal');

figure(2);
plot(t,y(:,3),'k',t,dt(:,1),'r:','linewidth',2);
xlabel('time(s)');ylabel('dt and adjustment of K');
legend('Practical dt','adjustment of K');

figure(3);
plot(t,ut(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('Control input');