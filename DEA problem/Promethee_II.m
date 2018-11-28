clear all; clc; close all;
%%
load('multicriteriaSolutions');
tabela = criterios(X,fX);
pesoCriterios = [0.5148;0.2517;0.1321;0.0649;0.0364];
Ns = length(tabela); %number of solutions
ind = 1:5;

%%
%escalonar
tab = zeros(5,Ns);
for i=1:5
tab(i,:) = abs((tabela(i,:) - max(tabela(i,:)))/abs((min(tabela(i,:)) - max(tabela(i,:)))));
end

tab = tab*max(max(tabela));
%%

J_plus = cell(Ns);
P = zeros(Ns);
for i=1:Ns
    for k=1:Ns
        J_plus{i}{k} = ind(tabela(:,i)<tabela(:,k));
        
        P(i,k) = sum(pesoCriterios(J_plus{i}{k}));
    end
end

%%
fluxo = zeros(Ns,1);
for i=1:Ns
    fluxo(i,1) = - sum(P(:,i)) + sum(P(i,:));
end
 
% [~,id_best] = max(fluxo);
[~,ord_index] = sort(fluxo);
ord_index = flip(ord_index);
id_best = ord_index(1);
%%
% figure
% plot3(tabela(3,:),tabela(2,:),tabela(1,:),'k.');
% hold on
% plot3(tabela(3,id_best),tabela(2,id_best),tabela(1,id_best),'rx');
% hold off
% xlabel('Perda de energia');
% ylabel('Emissão poluente');
% zlabel('Custo de combustivel');
% grid on
% 
% figure
% plot3(tabela(5,:),tabela(4,:),tabela(1,:),'k.');
% hold on
% plot3(tabela(5,id_best),tabela(4,id_best),tabela(1,id_best),'rx');
% hold off
% xlabel('Variação da emissão de poluentes');
% ylabel('Variação do custo');
% zlabel('Custo de combustivel');
% grid on
%  
% figure
% plot3(tabela(3,:),tabela(1,:),tabela(2,:),'k.');
% hold on
% plot3(tabela(3,id_best),tabela(1,id_best),tabela(2,id_best),'rx');
% hold off
% xlabel('Variação do custo');
% ylabel('Custo de combustivel');
% zlabel('Emissão de poluentes');
% grid on
%  
% figure
% plot3(tabela(5,:),tabela(4,:),tabela(2,:),'k.');
% hold on
% plot3(tabela(5,id_best),tabela(4,id_best),tabela(2,id_best),'rx');
% hold off
% zlabel('Emissão de poluentes');
% ylabel('Variação do custo');
% xlabel('Variação da emissão de poluentes');
% grid on



 