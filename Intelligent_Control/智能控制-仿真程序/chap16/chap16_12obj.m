function f=evaluate_objective(A,told,Y1,N) %A is the ith sample
J=0;
alfa1=A(1);alfa2=A(2);alfa3=A(3);alfa4=A(4);

xite1=[1/alfa1 0 0 alfa2/alfa1 0 0;
       0 1/alfa1 0 0 alfa3/alfa1 0;
       0 0 1/alfa1 0 0 alfa4/alfa1];
  
for j=1:1:N
    YY1=[Y1(j,1) Y1(j,2) Y1(j,3) Y1(j,4) Y1(j,5) Y1(j,6)];  %Y1
    
    k11=Y1(j,7);
    k22=Y1(j,8);
    k33=Y1(j,9);
    k=[k11 0 0;
       0 k22 0;
       0 0 k33];
        
    V1=told(j,1);
    tol1=[V1 V1 V1]';
    
    E1(:,j)=k*tol1-xite1*YY1';
end
for j=1:1:N
    E(j)=sqrt(E1(1,j)^2+E1(2,j)^2+E1(3,j)^2);
    J=J+0.5*E(j)*E(j);
end
f=J;
end