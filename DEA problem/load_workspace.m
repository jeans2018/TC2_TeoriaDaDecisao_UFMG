clear all;
close all;
clc;

struct2vars(load('D:\Ravi Quast\Engenharia de Sistemas volta da Holanda\Teoria da Decis�o\TF\1-12\TC2_TeoriaDaDecisao_UFMG-master\DEA problem\LOG\02-12-2018 09.34.31.980_40_points ##\workspace.mat'));
close all;

%Create Directories and Figure Counter
mkdir LOG
DirName = sprintf(datestr(now,'dd-mm-yyyy HH.MM.ss.FFF'));
DirName = [DirName '_' num2str(length(fX)) '_points'];
status = mkdir(['LOG\' DirName]);
status = mkdir(['LOG\' DirName '\images_eps']);
status = mkdir(['LOG\' DirName '\images_png']);
cont_fig = 0;

% Compare results between ELECTRE I and PROMETHEE II
c = categorical({'Electre','Promethee'});
labels = {'Custo','Emiss�o','Perdas de energia','Varia��o do custo','Varia��o da emiss�o'};
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

%Generate Pie Chart for ELECTRE I
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
pie(norm_fx(:,ranking_ele(1)),labels);
title('Grafico de Pizza para ELECTRE I');
ax = gca;
ax.TitleFontSizeMultiplier = 1.2;
set(gca,'FontSize',14)
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\pizza_electre.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\pizza_electre.png'],'-dpng','-r0');


%Generate Pie Chart for PROMETHEE II
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
pie(norm_fx(:,ranking_prom(1)),labels);
title('Grafico de Pizza para PROMETHEE II');
ax = gca;
ax.TitleFontSizeMultiplier = 1.2;
set(gca,'FontSize',14)
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\pizza_promethee.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\pizza_promethee.png'],'-dpng','-r0');

%escolhe a "N" alternativas melhores obtidas por cada m�todo
%plota um grafico para cada criterio comparando as "N" alternativas no
%elec. e prom.

%Generate 2D Graph without markers 
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
plot(fX(1,:),fX(2,:),'k.','MarkerSize',18)
hold on
plot(fX_ele(1,1:10),fX_ele(2,1:10),'k.','MarkerSize',18)
plot(fX_prom(1,1:10),fX_prom(2,1:10),'k.','MarkerSize',18)
grid on
xlabel('Custo')
ylabel('Emiss�o')
title('Avalia��o parcial das alternativas')
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca,'FontSize',20)
lgd = legend('Solu��es','Location','Best');
set(lgd,'FontSize',20);
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\avaliacao_parcial_2D_smark.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\avaliacao_parcial_2D_smark.png'],'-dpng','-r0');

%Generate 2D Graph with markers
FigH = figure('Position', get(0, 'Screensize'));
cont_fig = cont_fig + 1;
plot(fX(1,:),fX(2,:),'k.','MarkerSize',18)
hold on
plot(fX_ele(1,1),fX_ele(2,1),'b*','MarkerSize',18)
plot(fX_prom(1,1),fX_prom(2,1),'r*','MarkerSize',18)
plot(fX_ele(1,1:10),fX_ele(2,1:10),'bd','MarkerSize',18)
plot(fX_prom(1,1:10),fX_prom(2,1:10),'ro','MarkerSize',18)
grid on
xlabel('Custo')
ylabel('Emiss�o')
title('Avalia��o parcial das alternativas')
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca,'FontSize',20)
lgd = legend('Solu��es','Melhor Solu��o Electre I','Melhor Solu��o Promethee II', 'Melhores Solu��es Electre I','Melhores Solu��es Promethee II','Location','Best');
set(lgd,'FontSize',20);
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\avaliacao_parcial_2D_cmark.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\avaliacao_parcial_2D_cmark.png'],'-dpng','-r0');


%%Generate 3D Graph
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
ylabel('Emiss�o')
zlabel('Perda energia')
title('Avalia��o parcial das alternativas')
ax = gca;
ax.TitleFontSizeMultiplier = 1.5;
set(gca,'FontSize',20)
lgd = legend('Solu��es','Melhor Solu��o Electre I','Melhor Solu��o Promethee II', 'Melhores Solu��es Electre I','Melhores Solu��es Promethee II','Location','Best');
set(lgd,'FontSize',20);

print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_eps\avaliacao_parcial_3D.eps'],'-depsc2','-r0');
print(figure(cont_fig),[pwd '\' 'LOG\' DirName '\images_png\avaliacao_parcial_3D.png'],'-dpng','-r0');

%Save workspace
save(['LOG\' DirName '\workspace.mat'])