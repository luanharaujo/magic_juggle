clear
close all
global y0 Td T u0 z

%system('../../scripts/ultimo_parametro.sh');

% parametros = load('./dados/ultimos_parametros.csv');
% 
% %pid_rate
% 
% r_pitch_kp = parametros(13);
% r_pitch_ki = parametros(14);
% r_pitch_kd = parametros(15);
% 
% kp0 = r_pitch_kp;
% ki0 = r_pitch_ki;
% kd0 = r_pitch_kd;

kp0 = 250;
ki0 = 500;
kd0 = 2.5;

T = 1/500;
z = tf([1 0], 1, T);
s = tf([1 0], 1);

Tds = 1/(0.05*s + 1)^5;
Td =  c2d(Tds, T, 'zoh');
%Td = tf(1, [1 0 0 0 0 0], T, 'InputDelay', 2)


load('dados/t3.mat','gyro0x2EyRaw','controller0x2Ecmd_pitch');
y0 = gyro0x2EyRaw;
u0 = controller0x2Ecmd_pitch;

y0_filtrado = lowpass(y0,1,1/T);

plot(y0)
figure()
plot(y0_filtrado)
hold on

[B, A] = butter(5, 0.02, 'low');
filtered = transpose(filtfilt(B, A, transpose(y0)));

plot(filtered)

y0 = filtered;
load('dados/dados_para_frit_v1.mat','tremexp_com_gaiola_y0','tremexp_com_gaiola_u0');
y0 = tremexp_com_gaiola_y0*pi*1000/(180);
u0 = tremexp_com_gaiola_u0(2:end);


ro0 = [kp0, ki0, kd0];

ro = [kp0, ki0, kd0];

options = optimset('LargeScale','on','Algorithm','active-set','DerivativeCheck','on');
[ ro, fval, exitflag, output] = fmincon('performance_index',ro,[],[],[],[],[0, 0],[10, 10],'funcon',options);

ro

