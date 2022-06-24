function f=evaluate_objective(A,told,Y2,N)   %A is the ith sample
J=0;
alfa5=A(1);alfa6=A(2);alfa7=A(3);
alfa8=A(4);alfa9=A(5);alfa10=A(6);
  
xite2=[1/alfa5 0 0 alfa6/alfa5 0 0;
       0 1/alfa7 0 0 alfa8/alfa7 0;
       0 0 1/alfa9 0 0 alfa10/alfa9];
  
for j=1:1:N
    YY2=[Y2(j,1) Y2(j,2) Y2(j,3) Y2(j,4) Y2(j,5) Y2(j,6)];  %Y2
    
    V2=told(j,2);
    V3=told(j,3);
    V4=told(j,4);
    tol2=[V2 V3 V4];
    
    E2(:,j)=tol2'-xite2*YY2';
end
for j=1:1:N
    E(j)=sqrt(E2(1,j)^2+E2(2,j)^2+E2(3,j)^2);
    J=J+0.5*E(j)*E(j);
end
f=J;
end