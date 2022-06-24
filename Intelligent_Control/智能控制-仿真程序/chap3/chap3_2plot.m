close all;

figure(1);
plot(t,y(:,1),'k',t,y(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('y response');

figure(2);
plot(ut(:,1),'k','linewidth',2);
xlabel('x1');ylabel('ut');