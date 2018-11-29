function [ X, fX, ranking,tab] = Promethee_II(X, fX,tabela, pesoCriterios,preferencia)
%%

Ns = length(tabela); %number of solutions
ind = 1:5;

%%
%escalonar
tab = zeros(5,Ns);
for i=1:5
    if preferencia{i} == 'min'
        tab(i,:) = abs((tabela(i,:) - max(tabela(i,:)))/abs((min(tabela(i,:)) - max(tabela(i,:)))));
    else
        tab(i,:) = (tabela(i,:) - min(tabela(i,:))/(max(tabela(i,:)) - min(tabela(i,:))));
    end
end

tab = tab*20; %max(max(tabela));
%%

J_plus = cell(Ns);
P = zeros(Ns);
for i=1:Ns
    for k=1:Ns
        J_plus{i}{k} = ind(tab(:,i)>tab(:,k));
        
        P(i,k) = sum(pesoCriterios(J_plus{i}{k}));
    end
end

%%
fluxo = zeros(Ns,1);
for i=1:Ns
    fluxo(i,1) = - sum(P(:,i)) + sum(P(i,:));
end
 
[~,ord_index] = sort(fluxo);
ranking = flip(ord_index);
X = X(:,ranking);
fX = fX(:,ranking);
tab = tab/20; %max(max(tabela));
%%



 