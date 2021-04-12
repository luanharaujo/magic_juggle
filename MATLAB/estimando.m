close all
clear
clc

T = 1/500;

load('dados_para_frit_v1.mat','degrau_sem_gaiola_perto_r0','degrau_sem_gaiola_perto_y0');
y0 = degrau_sem_gaiola_perto_y0;
r0 = -degrau_sem_gaiola_perto_r0(2:end)*pi*1000/(180);

y0 = lowpass(y0,1,1/T);

plot(y0)
hold on
plot(r0)

data=iddata(y0,r0,T);
sys=tfest(data,5,1)