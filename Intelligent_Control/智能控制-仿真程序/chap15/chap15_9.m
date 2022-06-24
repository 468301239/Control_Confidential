% TSP Solving by Hopfield Neural Network
function TSP_hopfield()
clear all;
close all;

%Step 1: Initialization
A=1.5;
D=1;
Mu=50;
Step=0.01;

%Step 2: %Calculate initial route length
N=8;
cityfile = fopen('city8.txt','rt' );
cities = fscanf(cityfile, '%f %f',[ 2,inf] )
fclose(cityfile);
Initial_Length=Initial_RouteLength(cities); 

DistanceCity=dist(cities',cities);
%Step 3:  Initialization NN
U=rands(N,N);
V=1./(1+exp(-Mu*U)); % S function

for k=1:1:2000 
times(k)=k;
%Step 4: Calculate du/dt
    dU=DeltaU(V,DistanceCity,A,D);
%Step 5: Calculate u(t)
    U=U+dU*Step;
%Step 6: Calculate output of NN
    V=1./(1+exp(-Mu*U)); % S function
%Step 7: Calculate energy function
    E=Energy(V,DistanceCity,A,D);
    Ep(k)=E;
%Step 8: Check validity of the route
    [V1,CheckR]=RouteCheck(V); 
end

%Step 9: Results
if(CheckR==0)
   Final_E=Energy(V1,DistanceCity,A,D);
   Final_Length=Final_RouteLength(V1,cities); %Give final length
	disp('Iteration times');k
	disp(' the optimization route is');V1
    disp('Final optimization engergy function:');Final_E
  	disp('Initial length');Initial_Length
  	disp('Final optimization length');Final_Length
     
	PlotR(V1,cities); 
else
	disp('the optimization route is');V1
    disp('the route is invalid');
end

figure(2);
plot(times,Ep,'r','linewidth',2);
title('Energy Function Change');
xlabel('k');ylabel('E');

% Calculate energy function
function E=Energy(V,d,A,D)
[n,n]=size(V);
t1=sumsqr(sum(V,2)-1);
t2=sumsqr(sum(V,1)-1);
PermitV=V(:,2:n);
PermitV=[PermitV,V(:,1)];
temp=d*PermitV;
t3=sum(sum(V.*temp));
E=0.5*(A*t1+A*t2+D*t3);

%%%%%%% Calculate du/dt
function du=DeltaU(V,d,A,D)
[n,n]=size(V);
t1=repmat(sum(V,2)-1,1,n);
t2=repmat(sum(V,1)-1,n,1);
PermitV=V(:,2:n);
PermitV=[PermitV, V(:,1)];
t3=d*PermitV;
du=-1*(A*t1+A*t2+D*t3);

%Check the validity of route
function [V1,CheckR]=RouteCheck(V)
[rows,cols]=size(V);
V1=zeros(rows,cols);
[XC,Order]=max(V);
for j=1:cols
    V1(Order(j),j)=1;
end
C=sum(V1);
R=sum(V1');
CheckR=sumsqr(C-R);

% Calculate Initial Route Length
function L0=Initial_RouteLength(cities)
[r,c]=size(cities);
L0=0;
for i=2:c
   L0=L0+dist(cities(:,i-1)',cities(:,i));
end
% Calculate Final Route Length
function L=Final_RouteLength(V,cities)
[xxx,order]=max(V);
New=cities(:,order);
New=[New New(:,1)];
[rows,cs]=size(New);

L=0;
for i=2:cs
    L=L+dist(New(:,i-1)',New(:,i));
end

% Give Path optimization plot
function PlotR(V,cities)
figure;

cities=[cities cities(:,1)];

[xxx,order]=max(V);
New=cities(:,order);
New=[New New(:,1)];

subplot(1,2,1);
plot( cities(1,1), cities(2,1),'r*' );   %First city
hold on;
plot( cities(1,2), cities(2,2),'+' );    %Second city
hold on;
plot( cities(1,:), cities(2,:),'o-' ), xlabel('X axis'), ylabel('Y axis'), title('Original Route');
axis([0,1,0,1]);

subplot(1,2,2);
plot( New(1,1), New(2,1),'r*' );   %First city
hold on;
plot( New(1,2), New(2,2),'+' );    %Second city
hold on;
plot(New(1,:),New(2,:),'o-');
title('TSP solution');
xlabel('X axis');ylabel('Y axis');
axis([0,1,0,1]);
axis on
