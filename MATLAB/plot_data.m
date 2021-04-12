%limpando a bagunça
clear
clc
close all

%rodando o script que busca os dados mais recentes por ssh no outro computador
system('./scripts/ultimo_dado.sh');

%descobrindo o nome do arquivo mais recente
fname = char(textread('./dados/nome.txt','%s'));
fname = sprintf('./dados/%s',fname);

%extraindo os dados do arquivo csv
%data = load(fname);
Tbl = readtable(fname, 'PreserveVariableNames', true);
VarNames = Tbl.Properties.VariableNames;
numero_variaveis = size(VarNames);
numero_variaveis = numero_variaveis(2)-1;%subitraindo 1 pois existe uma coluna a mais no arquivo CSV por conta da virgula no fim de cada linha na hora de gerar o arquivo de tamnanho indefinido
for i = 1:numero_variaveis
 assignin('base',(genvarname(char(VarNames(i)))),table2array(Tbl(:,i)));
end

plot(-ref_gy)
hold on