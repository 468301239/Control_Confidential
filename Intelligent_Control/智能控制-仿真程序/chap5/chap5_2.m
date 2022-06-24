%Define N+1 triangle membership function
clear all;
close all;

z1=-1:0.01:1;

M1=(z1+1)/2;
M2=(1-z1)/2;

figure(1);
plot(z1,M1);

hold on;
plot(z1,M2);
xlabel('z1');
ylabel('Degree of membership');