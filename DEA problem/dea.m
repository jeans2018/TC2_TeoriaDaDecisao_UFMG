function fx = dea(x)
    % Entrada
    % x: matriz de soluções onde cada coluna corresponde a uma solução e
    % as linhas são os valores das variáveis que correspondem ao valor de
    % potência gerada, em p.u.
    % Saída
    % fx: valor dos objetivos para as soluções presentes em x, onde na
    % primeira linha tem-se os custos e na segunda os valores de emissão.

    [custo,emissao]=Objetivos6_pen(x);    
    fx = [custo;emissao];    
end

function [Custo,Emissao,Perdas]=Objetivos6_pen(x)  % coeficientes e solução candidata 

    co=size(x,2);
    for i=1:co,    % Para cada solução
        [custo,emissao,perdas]=Calculo(x(:,i));
        Custo(1,i)=custo;
        Emissao(1,i)=emissao;
        Perdas(1,i)=perdas;
    end
end

function [custo,emissao,perdas]=Calculo(x)  % Recebe apenas uma solução (vetor coluna)
    
    coef=[10    200    100    4.091    -5.554    6.490    2e-04      2.857     0.05     0.5
        10    150    120     2.543    -6.047    5.638    5e-04      3.333     0.05     0.6
        20    180    40      4.258    -5.094    4.586    1e-06      8.000     0.05     1.0
        10    100    60      5.326    -3.550    3.380    2e-03      2.000     0.05     1.2
        20    180    40      4.258    -5.094    4.586    1e-06      8.000     0.05     1.0
        10    150    100     6.131    -5.555    5.151    1e-05      6.667     0.05     0.6];

    B=[0.1382  -0.0299  0.0044  -0.0022  -0.0010  -0.0008
        -0.0299  0.0487  -0.0025  0.0004  0.0016  0.0041
        0.0044  -0.0025  0.0182  -0.0070  -0.0066  -0.0066
        -0.0022  0.0004  -0.0070  0.0137  0.0050  0.0033
        -0.0010  0.0016  -0.0066  0.0050  0.0109  0.0005
        -0.0008  0.0041  -0.0066  0.0033  0.0005  0.0244];

    B0=[-0.0107 0.0060 -0.0017 0.0009 0.0002 0.0030];

    B00=9.8573e-4;

    custo=0;
    emissao=0;
    for i=1:6,
        custo=custo+coef(i,1)+coef(i,2)*x(i)+coef(i,3)*(x(i))^2;
        emissao=emissao+(10^(-2))*(coef(i,4)+coef(i,5)*x(i)+coef(i,6)*((x(i))^2))+coef(i,7)*exp(coef(i,8)*x(i));
    end
    
    perdas=B00;
    for i=1:6,
        for j=1:6,
            perdas=perdas+x(i)*B(i,j)*x(j);           
        end
        perdas=perdas+B0(i)*x(i);
    end
    
    % Método de Penalidades
    h=abs(sum(x)-2.834-perdas);
    p1=(10^4)*h^2;
    p2=(10)*h^2;
    custo=custo+p1;
    emissao=emissao+p2;
end
