function tabela=criterios(x,fx)
    % Entradas
    % x: matriz de soluções onde cada coluna corresponde a uma solução e
    % as linhas são os valores das variáveis que correspondem ao valor de
    % potência gerada, em p.u.
    % fx: valor dos objetivos para as soluções presentes em x, onde na
    % primeira linha tem-se os custos e na segunda os valores de emissão.
    % Saída
    % tabela: matriz onde cada linha corresponde a um critério, sendo
    % respectivamente: Custo ($), Emissão (ton/h), Percentual de Perdas em
    % relação ao total produzido, Delta Custo ($) e Delta Emissão (ton/h).
    
    Criterio1=fx(1,:);
    Criterio2=fx(2,:);
    [perdas,pperdas]=Perdas(x);   
    Criterio3=pperdas;
    [Criterio4,Criterio5]=Coef_Incert(x,perdas);
    tabela=[Criterio1;Criterio2;Criterio3;Criterio4;Criterio5];
    
end

function [perdas,pperdas]=Perdas(x)
    B=[0.1382  -0.0299  0.0044  -0.0022  -0.0010  -0.0008
        -0.0299  0.0487  -0.0025  0.0004  0.0016  0.0041
        0.0044  -0.0025  0.0182  -0.0070  -0.0066  -0.0066
        -0.0022  0.0004  -0.0070  0.0137  0.0050  0.0033
        -0.0010  0.0016  -0.0066  0.0050  0.0109  0.0005
        -0.0008  0.0041  -0.0066  0.0033  0.0005  0.0244];
    B0=[-0.0107 0.0060 -0.0017 0.0009 0.0002 0.0030];
    B00=9.8573e-4;
    co=size(x,2);
    
    for k=1:co,    % Para cada solução
        sol=x(:,k);
        
        soma=B00;
        for i=1:6,
            for j=1:6,
                soma=soma+sol(i)*B(i,j)*sol(j);           
            end
            soma=soma+B0(i)*sol(i);
        end 
        perdas(1,k)=soma;
        pperdas(1,k)=soma/sum(sol);
    end  
end

function [Criterio4,Criterio5]=Coef_Incert(x,Perdas)
    ncen=1000;
    nsol=size(x,2);    
    coef=[10    200    100    4.091    -5.554    6.490    2e-04      2.857...
          10    150    120    2.543    -6.047    5.638    5e-04      3.333...
          20    180    40     4.258    -5.094    4.586    1e-06      8.000...
          10    100    60     5.326    -3.550    3.380    2e-03      2.000...
          20    180    40     4.258    -5.094    4.586    1e-06      8.000...
          10    150    100    6.131    -5.555    5.151    1e-05      6.667];
    delta=0.05*coef;
    
    for i=1:ncen,    % Gera os novos cenários
        for j=1:48,
            cen(i,j)=coef(j)+((-1)^randi(2))*rand*delta(j);            
        end
    end
    
    for i=1:nsol,    % Avalia cada solução nos cenários
        for j=1:ncen,
            [a(j),b(j)]=Obj(cen(j,:),x(:,i),Perdas(i));
        end
        Criterio4(1,i)=max(a)-min(a);
        Criterio5(1,i)=max(b)-min(b);
    end    
end

function [custo,emissao]=Obj(cen,x,per)
    
    coef=[cen(1:8);cen(9:16);cen(17:24);cen(25:32);cen(33:40);cen(41:48)];
    
    custo=0;
    emissao=0;
    for i=1:6,
        custo=custo+coef(i,1)+coef(i,2)*x(i)+coef(i,3)*(x(i))^2;
        emissao=emissao+(10^(-2))*(coef(i,4)+coef(i,5)*x(i)+coef(i,6)*((x(i))^2))+coef(i,7)*exp(coef(i,8)*x(i));
    end
    
    % Método de Penalidades
    h=abs(sum(x)-2.834-per);
    p1=(10^4)*h^2;
    p2=(10)*h^2;
    custo=custo+p1;
    emissao=emissao+p2;   
end
