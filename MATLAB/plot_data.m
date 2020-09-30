%limpando a bagunça
%clear
clc
close all

%rodando o script que busca os dados mais recentes por ssh no outro computador
!powershell -inputformat none -file .\scripts\ultimo_dado.ps1

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

plot((tempo - tempo(1))/1000, stateEstimate0x2Ez)
hold on
plot((tempo - tempo(1))/1000, ref_z);

set(gcf,'units','normalized','outerposition',[0 0 1 1]);

%plotando caminho do dorne
% plot3(data(:,2),data(:,3), data(:,4));
% hold on;
% grid;
% xlabel('X: tras -> frente');
% ylabel('Y: direita -> esquerda');
% zlabel('Z: baixo -> cima');

%arrumando o angulo de visão e as escalas para ficar semelhante ao dito pela camera
% view(-120,45);
% axis([-0.15 0.71 -0.15 0.81 0 0.6]);

%maximizando a janela do plot
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);

%pegando e integrando as referencisa
% tempo=data(:,1)*0.001;
% z_ref=data(:,11);
% y_ref = cumtrapz(tempo,data(:,9));
% x_ref = cumtrapz(tempo,data(:,8));

%plotando as referencias
% plot3(x_ref,y_ref,z_ref);

%4D plot
% pause(3);
% for i = 1:998
%   plot3(data(i,2),data(i,3), data(i,4),'Or');
%   pause(0.01);
% end
