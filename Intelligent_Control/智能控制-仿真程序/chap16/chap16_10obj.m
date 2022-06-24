function J=evaluate_objective(B,told,Y1,N)  %计算个体适应度值
  J=0;
  alfa=B;  %the ith sample
  eta1=[1/alfa(1) 0 0 alfa(2)/alfa(1) 0 0;
      0 1/alfa(1) 0 0 alfa(3)/alfa(1) 0;
      0 0 1/alfa(1) 0 0 alfa(4)/alfa(1)];
  
for j=1:1:N
    YY1=[Y1(j,1) Y1(j,2) Y1(j,3) Y1(j,4) Y1(j,5) Y1(j,6)];
    k=[Y1(j,7) 0 0;Y1(j,8) 0 0;Y1(j,9) 0 0];
    V1=told(j,1);
    
    tol1=[V1 V1 V1]';
    tol1p=eta1*YY1';
    
    E(:,j)=k*tol1-tol1p;
end
for j=1:1:N
    Ej(j)=sqrt(E(1,j)^2+E(2,j)^2+E(3,j)^2);
    J=J+0.5*Ej(j)*Ej(j);
end
end