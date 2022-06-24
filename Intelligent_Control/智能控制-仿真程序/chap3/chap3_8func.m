clear all;
close all;

ci=5;
ts=0.001;
for k=1:1:10000
   t(k)=k*ts;
   d(k)=200*exp(-(t(k)-ci)^2);
end
figure(1);
plot(t,d,'k','linewidth',2);
xlabel('time(s)');
ylabel('dt,Gaussian function');