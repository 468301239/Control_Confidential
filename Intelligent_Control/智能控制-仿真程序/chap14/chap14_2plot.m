close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('x1 response');
subplot(212);
plot(t,x(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('x2 response');

figure(2);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('ut');

figure(3);
plot(t,x(:,3),'k',t,ut(:,2),'r:','linewidth',2);
xlabel('time(s)');ylabel('fx and estiamted fx');
legend('fx','estiamted fx');