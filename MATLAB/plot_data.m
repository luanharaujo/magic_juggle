%limpando a bagunça
%clear
clc
%close all

%rodando o script que busca os dados mais recentes por ssh no outro computador
!powershell -inputformat none -file C:\Users\luanh\OneDrive\Documents\MATLAB\scripts\ultimo_dado.ps1

%descobrindo o nome do arquivo mais recente
fname = char(textread('./dados/nome.txt','%s'));
fname = sprintf('./dados/%s',fname);

%extraindo os dados do arquivo csv
data = load(fname);

%plotando caminho do dorne
plot3(data(:,2),data(:,3), data(:,4));
hold on;
grid;
xlabel('X: tras -> frente');
ylabel('Y: direita -> esquerda');
zlabel('Z: baixo -> cima');

%arrumando o angulo de visão e as escalas para ficar semelhante ao dito pela camera
view(-120,45);
axis([-0.15 0.71 -0.15 0.81 0 0.6]);

%maximizando a janela do plot
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

%pegando e integrando as referencisa
tempo=data(:,1)*0.001;
z_ref=data(:,11);
y_ref = cumtrapz(tempo,data(:,9));
x_ref = cumtrapz(tempo,data(:,8));

%plotando as referencias
plot3(x_ref,y_ref,z_ref);

%4D plot
% pause(3);
% for i = 1:998
%   plot3(data(i,2),data(i,3), data(i,4),'Or');
%   pause(0.01);
% end