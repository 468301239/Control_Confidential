function J=evaluate_objective(B,told,Y2,N) %计算个体适应度值
  J=0;
  alfa=B;%the ith sample
  
  alfa5=alfa(1);
  alfa6=alfa(2);
  alfa7=alfa(3);
  alfa8=alfa(4);
  alfa9=alfa(5);
  alfa10=alfa(6);
  
  eta2=[1/alfa5 0 0 alfa6/alfa5 0 0;
        0 1/alfa7 0 0 alfa8/alfa7 0;
        0 0 1/alfa9 0 0 alfa10/alfa9];
  
for j=1:1:N
    YY2=[Y2(j,1) Y2(j,2) Y2(j,3) Y2(j,4) Y2(j,5) Y2(j,6)];
    
    V2=told(j,2);
    V3=told(j,3);
    V4=told(j,4);
    tol2=[V2 V3 V4]';
    tol2p=eta2*YY2';
    E(:,j)=tol2-tol2p;
end
for j=1:1:N
    Ej(j)=sqrt(E(1,j)^2+E(2,j)^2+E(3,j)^2);
    J=J+0.5*Ej(j)*Ej(j);
end
end