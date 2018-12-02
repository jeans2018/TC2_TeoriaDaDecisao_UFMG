
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

%Creater Directories and Figure Counter
mkdir LOG
DirName = sprintf(datestr(now,'dd-mm-yyyy HH.MM.ss.FFF'));
DirName = [DirName '_' num2str(length(fX)) '_points'];
status = mkdir(['LOG\' DirName]);
status = mkdir(['LOG\' DirName '\images_eps']);
status = mkdir(['LOG\' DirName '\images_png']);
cont_fig = 0;

% Compare results between ELECTRE I and PROMETHEE II
c = categorical({'Electre','Promethee'});
labels = {'Custo','Emissão','Perdas de energia','Variação do custo','Variação da emissão'};
for i=1:5
figure
cont_fig = cont_fig + 1;
b = bar(c, [fX_ele(i,1) fX_prom(i,1)],'FaceColor','flat');
b.CData(1,:) = [0 0.8 0.8];
b.CData(2,:) = [1 1 0];
title(labels{i});
ax = gca;
ax.TitleFontSizeMultiplier = 1.2;
set(gca,'FontSize',14)

print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\bar_f' num2str(cont_fig) '.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\bar_f' num2str(cont_fig) '.png'],'-dpng','-r0');
end
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
pie(norm_fx(:,ranking_ele(1)),labels);
title('Grafico de Pizza para ELECTRE I');
ax = gca;
ax.TitleFontSizeMultiplier = 1.2;
set(gca,'FontSize',14)
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\pizza_electre.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\pizza_electre.png'],'-dpng','-r0');



FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
pie(norm_fx(:,ranking_prom(1)),labels);
title('Grafico de Pizza para PROMETHEE II');
ax = gca;
ax.TitleFontSizeMultiplier = 1.2;
set(gca,'FontSize',14)
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\pizza_promethee.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\pizza_promethee.png'],'-dpng','-r0');

%escolhe a "N" alternativas melhores obtidas por cada método
%plota um grafico para cada criterio comparando as "N" alternativas no
%elec. e prom.

%Gera Grafico 2D
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
plot(fX(1,:),fX(2,:),'k.','MarkerSize',18)
hold on
plot(fX_ele(1,1:10),fX_ele(2,1:10),'k.','MarkerSize',18)
plot(fX_prom(1,1:10),fX_prom(2,1:10),'k.','MarkerSize',18)
grid on
xlabel('Custo')
ylabel('Emissão')
title('Avaliação parcial das alternativas')
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca,'FontSize',20)
lgd = legend('Soluções','Location','Best');
set(lgd,'FontSize',20);
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\avaliacao_parcial_2D.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\avaliacao_parcial_2D.png'],'-dpng','-r0');

%Gera Grafico 3D
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
plot3(fX(1,:),fX(2,:),fX(3,:),'k.','MarkerSize',18)
hold on
plot3(fX_ele(1,1),fX_ele(2,1),fX_ele(3,1),'b*','MarkerSize',18)
plot3(fX_prom(1,1),fX_prom(2,1),fX_prom(3,1),'r*','MarkerSize',18)
plot3(fX_ele(1,1:10),fX_ele(2,1:10),fX_ele(3,1:10),'bd','MarkerSize',18)
plot3(fX_prom(1,1:10),fX_prom(2,1:10),fX_prom(3,1:10),'ro','MarkerSize',18)
grid on
xlabel('Custo')
ylabel('Emissão')
zlabel('Perda energia')
title('Avaliação parcial das alternativas')
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca,'FontSize',20)
lgd = legend('Soluções','Melhor Solução Electre I','Melhor Solução Promethee II', 'Melhores Soluções Electre I','Melhores Soluções Promethee II','Location','Best');
set(lgd,'FontSize',20);

print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\avaliacao_parcial_3D.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\avaliacao_parcial_3D.png'],'-dpng','-r0');

%Save workspace
save(['LOG\' DirName '\workspace.mat'])