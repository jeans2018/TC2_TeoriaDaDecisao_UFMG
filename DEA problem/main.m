
% function main()
clear all;
close all;
clc;
% Initialization
N  = 10; % number of solutions
n  = 6;  % number of decision variables
lb = [0.05 0.05 0.05 0.05 0.05 0.05];  % lower bound
ub = [0.5  0.6  1.0  1.2  1.0  0.6];   % upper bound
nc = 50; %number of cells
nit = 80;
X  = (repmat(lb(:),1,N) + repmat((ub(:)-lb(:)),1,N).*rand(n,N));

% Evaluation of the candidate solutions
fX = dea(X);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optimization algorithm
cell_x = EvDif(X,lb,ub,nc,nit);
j=[];
f=[];

for g=1:nc
   [fp,jP] = nondominatedpoints(cell_x{g},dea(cell_x{g}));
   j = [j jP];
   f = [f fp];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Eliminate Pareto dominated solutions
[X,fX] = nondominatedpoints(f,j);


save solutions X fX


% Evaluate the solutions on the additional criteria considered
criteria = criterios(X,fX);

% Eliminate Pareto dominated solutions
[X,fX] = nondominatedpoints(X,criteria);

save multicriteriaSolutions X fX

% Generate criteria priorities using AHP
Criteria_Weights = [1 3 5 7 9; 1/3 1 3 5 5; 1/5 1/3 1 3 5; ...
    1/7 1/5 1/3 1 3; 1/9 1/5 1/5 1/3 1];
[Criteria_Priorities, W_approx, IC, ICA, CR] = ahp(Criteria_Weights);

% Sort solutions using ELECTRE I
preferencia = {'min','min','min','min','min'};
[ X_ele, fX_ele, ranking_ele ] = electre(X, fX, Criteria_Priorities, preferencia );

% Sort solutions using PROMETHEE II
[ X_prom, fX_prom, ranking_prom,norm_fx]= Promethee_II(X, fX,  Criteria_Priorities, preferencia);

% Compare results between ELECTRE I and PROMETHEE II
c = categorical({'Electre','Promethee'});
labels = {'Custo','Emissão','Perdas de energia','Variação do custo','Variação da emissão'};
for i=1:5
figure
b = bar(c, [fX_ele(i,1) fX_prom(i,1)],'FaceColor','flat');
b.CData(1,:) = [0 0.8 0.8];
b.CData(2,:) = [1 1 0];
title(labels{i});
end
figure
pie(norm_fx(:,ranking_ele(1)),labels);
title('Grafico de Pizza para ELECTRE I');

figure
pie(norm_fx(:,ranking_prom(1)),labels);
title('Grafico de Pizza para PROMETHEE II');
%escolhe a "N" alternativas melhores obtidas por cada método
%plota um grafico para cada criterio comparando as "N" alternativas no
%elec. e prom.

figure
plot3(fX(1,:),fX(2,:),fX(3,:),'k.')
hold on
plot3(fX_ele(1,1:10),fX_ele(2,1:10),fX_ele(3,1:10),'bd')
plot3(fX_prom(1,1:10),fX_prom(2,1:10),fX_prom(3,1:10),'ro')

grid on
xlabel('Custo')
ylabel('Emissão')
zlabel('Perda energia')
title('Avaliação parcial')
legend('Soluções','Melhor soluções electre','Melhores soluções Promethee');