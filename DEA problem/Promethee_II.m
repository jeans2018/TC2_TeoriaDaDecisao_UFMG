function [ X, fX, ranking,tab] = Promethee_II(X, fX, pesoCriterios,preferencia)
%%
% load('multicriteriaSolutions');
% fX = criterios(X,fX);
% pesoCriterios = [0.5148;0.2517;0.1321;0.0649;0.0364];
Ns = length(fX); %number of solutions
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

tab = tab*max(max(fX));
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
tab = tab/max(max(fX));
%%



 