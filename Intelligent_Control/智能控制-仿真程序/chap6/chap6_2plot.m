close all;

figure(1);
subplot(211);
plot(t,0.3*sin(t),'r',t,y(:,1),'k:','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking of first link');
subplot(212);
plot(t,0.3*sin(t),'r',t,y(:,3),'k:','linewidth',2);
xlabel('time(s)');ylabel('Angle tracking of second link');

figure(2);
subplot(211);
plot(t,0.3*cos(t),'r',t,y(:,2),'k:','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking of first link');
subplot(212);
plot(t,0.3*cos(t),'r',t,y(:,4),'k:','linewidth',2);
xlabel('time(s)');ylabel('Angle speed tracking of second link');

figure(3);
subplot(211);
plot(t,y(:,5),'r',t,u(:,3),'k:','linewidth',2);
xlabel('time(s)');ylabel('F and Fc');
subplot(212);
plot(t,y(:,6),'r',t,u(:,4),'k:','linewidth',2);
xlabel('time(s)');ylabel('F and Fc');

figure(4);
subplot(211);
plot(t,u(:,1),'k','linewidth',2);
xlabel('time(s)');ylabel('Control input of Link1');
subplot(212);
plot(t,u(:,2),'k','linewidth',2);
xlabel('time(s)');ylabel('Control input of Link2');