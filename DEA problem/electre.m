function [ X, fX, ranking] = electre(X, fX, pesos, preferencia )
%	electre: ordena as alternativas da melhor para a pior.
%   X: alternativas;
%   fX: avalia��es das alternativasc(colunas) nos crit�rios (linhas);
%   pesos: pesos dos crit�rios normalizados;
%   preferencia: vetor de strings. Se posi��o i tem valor 'max', o crit�rio
%   i deve ser maximizado. Se posi��o i tem valor 'min', o crit�rio i deve
%   ser minimizado.

tau_c = 0.7; %limiar de concord�ncia
tau_d = 0.3; %limiar de discord�ncia   
delta = 1/20; %fator de escala

nr_criterios = size(fX, 1);
nr_alternativas = size(fX, 2);


%--------------------------------------------------------------------------
%normaliza��o
fX_norm = zeros(size(fX));
max_values = max(fX,[],2);
min_values = min(fX,[],2);

for i=1:nr_criterios 
   if(strcmp(preferencia(i),'max'))
       for j=1:nr_alternativas
           if(fX(i,j)==max_values(i))
               fX_norm(i,j)=1/delta; %nota m�xima
           elseif((fX(i,j)~=max_values(i)) && (fX(i,j)~=min_values(i)))
               %nota entre 0 e 1/delta
               fX_norm(i,j)= ((fX(i,j) - min_values(i))/(max_values(i) - min_values(i)))/delta;
           end           
       end
   elseif(strcmp(preferencia(i),'min'))
       for j=1:nr_alternativas
           if(fX(i,j)==min_values(i))
               fX_norm(i,j)=1/delta; %nota m�xima
           elseif((fX(i,j)~=max_values(i)) && (fX(i,j)~=min_values(i)))
               %nota entre 0 e 1/delta
               fX_norm(i,j)= ((fX(i,j) - max_values(i))/(min_values(i) - max_values(i)))/delta;
           end
       end
   end
end
%--------------------------------------------------------------------------
%Compara��es

J_plus = cell(nr_alternativas);
J_equal = cell(nr_alternativas);
J_minus = cell(nr_alternativas);

for i=1:nr_alternativas
    for j=1:nr_alternativas
        if(i~=j)
            J_plus{i,j}=find(fX_norm(:,i)>fX_norm(:,j));
            J_equal{i,j}=find(fX_norm(:,i)==fX_norm(:,j));
            J_minus{i,j}=find(fX_norm(:,i)<fX_norm(:,j));
        end
    end
end
%--------------------------------------------------------------------------
%Converte as rela��es em valores num�ricos

P_plus = cell(nr_alternativas);
P_equal = cell(nr_alternativas);

for i=1:nr_alternativas
    for j=1:nr_alternativas
        if(i~=j)
            P_plus{i,j}=sum(pesos(J_plus{i,j}));
            P_equal{i,j}=sum(pesos(J_equal{i,j}));
        end
    end
end
%--------------------------------------------------------------------------
%Coeficientes de concord�ncia

C = cell(nr_alternativas);

for i=1:nr_alternativas
    for j=1:nr_alternativas
        if(i~=j)
           C{i,j}= P_plus{i,j}+P_equal{i,j};
        end
    end
end
%--------------------------------------------------------------------------
%Coeficiente de discord�ncia

D = cell(nr_alternativas);

for i=1:nr_alternativas
    for j=1:nr_alternativas
        if(i~=j)
           if(isempty(J_minus{i,j}))
               D{i,j}=0;
           else
               D{i,j}=max(fX_norm(J_minus{i,j},j)-fX_norm(J_minus{i,j},i))*delta;
           end
        end
    end
end
%--------------------------------------------------------------------------
%matriz de sobreclassifica��o

sob = zeros(nr_alternativas);

for i=1:nr_alternativas
    for j=1:nr_alternativas
        if(i~=j)
           if((C{i,j}>= tau_c) && (D{i,j}<= tau_d))
               sob(i,j)=1;
           end
        end
    end
end
%--------------------------------------------------------------------------
%rankeia as alternativas

dif = zeros(nr_alternativas,1);

for i=1:nr_alternativas
    dif(i) = sum(sob(i,:))-sum(sob(:,i));
end

[~,ranking] = sort(dif,'descend');
%--------------------------------------------------------------------------
%ordena as alternativas de acordo com o ranking

X = X(:,ranking);
fX = fX(:,ranking);

end

