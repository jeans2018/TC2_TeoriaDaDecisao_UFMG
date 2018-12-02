function [ X, fX, ranking,tab] = Promethee_II(X, fX, pesoCriterios,preferencia)
%%

Ns = size(fX,2); %number of solutions
ind = 1:5;

%% 
%escalonar
tab = zeros(5,Ns);
for i=1:5
    if preferencia{i} == 'min'
        tab(i,:) = abs((fX(i,:) - max(fX(i,:)))/abs((min(fX(i,:)) - max(fX(i,:)))));
    else
        tab(i,:) = (fX(i,:) - min(fX(i,:))/(max(fX(i,:)) - min(fX(i,:))));
    end
end

tab = tab*20;

%%
%Cria uma celula identificando para cada criterio na sulução i em relação a
%sulução k quais são melhores (cj(ai) > cj(ak)).
Better = cell(Ns);
P = zeros(Ns);
for i=1:Ns
    for k=1:Ns
        Better{i}{k} = ind(tab(:,i)>tab(:,k));
        
        P(i,k) = sum(pesoCriterios(Better{i}{k})); %preferência global
    end
end

%%
%calculo do fluxo para cada solução
fluxo = zeros(Ns,1);
for i=1:Ns
    fluxo(i,1) = - sum(P(:,i)) + sum(P(i,:));
end

%ordena as alternativas de acordo com o ranking
[~,ord_index] = sort(fluxo); 
ranking = flip(ord_index);
X = X(:,ranking);
fX = fX(:,ranking);
tab = tab/20;

end
 