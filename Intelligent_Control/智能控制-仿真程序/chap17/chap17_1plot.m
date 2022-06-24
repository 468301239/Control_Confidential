close all;

figure(1);
subplot(211);
plot(t,q(:,1),'k',t,q(:,3),'r:','linewidth',2);
xlabel('time(s)');ylabel('Angle response');
subplot(212);
plot(t,q(:,1)-q(:,3),'r','linewidth',2);
xlabel('time(s)');ylabel('Angle response error');

figure(2);
plot(t,q(:,2),'k',t,q(:,4),'r:','linewidth',2);
xlabel('time(s)');ylabel('Speed response');

figure(3);
subplot(211);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input,tolm');
subplot(212);
plot(t,ut(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input,tols');