close all;

figure(1);
plot(t,y(:,1),'k',t,y(:,2),'r:','linewidth',2);
legend('Ideal position signal','Position tracking');
xlabel('time(s)');ylabel('Angle response');

figure(2);
plot(t,ut(:,1),'k','linewidth',0.01);
xlabel('time(s)');ylabel('Control input');

c=5;
e=z(:,1);
ef=z(:,2);
figure(3);
plot(ef,e,'r',ef,-c*ef,'k','linewidth',2);
xlabel('ef');ylabel('e');
title('phase trajectory');