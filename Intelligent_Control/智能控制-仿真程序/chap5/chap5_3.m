%Define N+1 triangle membership function
clear all;
close all;

z2=0:0.01:4;

N1=z2/4;
N2=(4-z2)/4;

figure(1);
plot(z2,N1);

hold on;
plot(z2,N2);
xlabel('z2');
ylabel('Degree of membership');