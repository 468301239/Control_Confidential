close all;

figure(1);
subplot(211);
plot(t,sin(t),'r',t,x(:,1),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking for link 1');
subplot(212);
plot(t,sin(t),'r',t,x(:,3),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking for link 2');

figure(2);
subplot(211);
plot(t,cos(t),'r',t,x(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking for link 1');
subplot(212);
plot(t,cos(t),'r',t,x(:,4),'b','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking for link 2');

figure(3);
subplot(211);
plot(t,tol1(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input of link 1');
subplot(212);
plot(t,tol2(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input of link 2');

figure(4);
plot(t,f(:,5),'r',t,f(:,6),'b','linewidth',2);
xlabel('time(s)');ylabel('f and fn');