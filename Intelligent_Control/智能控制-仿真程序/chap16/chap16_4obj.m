function J=pso_evaluate_obj(B,ut,Y,N) %计算个体适应度值
  J=0;
  a1=B(1);
  a2=B(2);
  a3=B(3);
  b1=B(4);
  b2=B(5);
  b3=B(6);
  
  eta=[a1 1 -a1 0  0 a3 -a2;
       b2/b1 0 -b2/b1  -b3/b1 1/b1 0 0];
  
for j=1:1:N
    tol=[0 ut(j)]';
    E(:,j)=tol-eta*Y(j,:)';
end
for j=1:1:N
    Ej(j)=sqrt(E(1,j)^2+E(2,j)^2);
    J=J+0.5*Ej(j)*Ej(j);
end
end