function [cell_x] = EvDif(X,lb,ub,nc,nit)
%% Aterações aqui
C = 0.5;    % Probabilidade de Recombinação
N = 10;    % Tamanho da População
n = 6;      % Dimensão do Problema
min_1 = 600;
min_2 = 0.17;
max_1 = 5.8032e+04;
max_2 = 58.1275;
%%
cell_x = cell(1,nc);
X_init = X;
for k = 1:nc
w = rand(1,2);
w = w/sum(w);
T = 1;  
V = zeros(n,N); % Matriz de Soluções Mutantes

%% Looping
for iteracao = 1:nit  % Critério de Parada  
    % avaliar a população
    F = 0.4 + 0.5*rand;
    fX = dea(X);

    fX(1,:) = (fX(1,:) - min_1)/(max_1 - min_1);
    fX(2,:) = (fX(2,:)- min_2)/(max_2 - min_2);
    f_mono = w(1)*fX(1,:) + w(2)*fX(2,:);
    VetorBase = randperm(N);  % Vetores Base Ordem Aleatoria;
    for i = 1:N     % Para cada Individuo
        R = randi(N,1,2);    % Dois Individuos Selecionados para Vetor de Dif
        delta = randi(n); 
        for  j = 1:n   % Para cada Dimensão
            U = rand(1);    % Probabilidade de Recombinação
            if (U <= C) || (delta == j)
                V(j,i) = X(j,(VetorBase(i))) - F*(X(j,R(1)) - X(j,R(2)));
                if(V(j,i) > ub(j)||V(j,i) < lb(j))
                    V(j,i) = lb(j) + rand*(ub(j) - lb(j));
                end
            else
              V(j,i) = X(j,i);
            end           
        end              
    end  
    
    for i = 1:N
        teste = dea(V(:,i));
        teste(1,:) = (teste(1,:) - min_1)/( max_1 - min_1);
        teste(2,:) = (teste(2,:)- min_2)/(max_2 - min_2);
        teste_mono = w(1)*teste(1,:) + w(2)*teste(2,:);
        if( teste_mono <= f_mono(i) ) 
            X(:,i) = V(:,i);
        end
    end
    T = T+1;
end
cell_x{k} = X;
X = X_init;       
end

    
        
