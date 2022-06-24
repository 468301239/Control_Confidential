function J=evaluate_objective(B,ut,Y,N) %计算个体适应度值
  J=0;
    
  I=B(1);
  Jp=B(2);
  MgL=B(3);
  K=B(4);
  
  eta=[I Jp MgL 0;
       0 Jp 0 K];
  
for j=1:1:N
    YY=[Y(j,1) Y(j,2) Y(j,3) Y(j,4)];
    
    tol=[ut(j,1) ut(j,1)];
    E(:,j)=tol'-eta*YY';
end
for j=1:1:N
    Ej(j)=sqrt(E(1,j)^2+E(2,j)^2);
    J=J+0.5*Ej(j)*Ej(j);
end
end