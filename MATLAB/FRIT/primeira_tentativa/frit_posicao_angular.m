clear
close all
global y0 Td T u0 z

%system('../../scripts/ultimo_parametro.sh');

parametros = load('./dados/ultimos_parametros.csv');

%pid_rate

r_pitch_kp = parametros(4);
r_pitch_ki = parametros(5);
r_pitch_kd = parametros(6);

kp0 = r_pitch_kp
ki0 = r_pitch_ki
kd0 = r_pitch_kd

% kp0 = 250;
% ki0 = 500;
% kd0 = 2.5;

T = 1/500;
z = tf([1 0], 1, T);
s = tf([1 0], 1);

Tds = 1/(0.05*s + 1)^7;
Tds = Tds * tf(1,1,'ioDelay',5.8065);
Td =  c2d(Tds, T, 'zoh');
step(Td)
%Td = tf(1, [1 0 0 0 0 0], T, 'InputDelay', 2)


load('dados/posicao_angular_gaiola_P_2.mat','stateEstimate0x2Epitch','controller0x2EpitchRate','ref_gy');
y0 = stateEstimate0x2Epitch;
u0 = controller0x2EpitchRate;
r0 = ref_gy;

% y0_filtrado = lowpass(y0,1,1/T);
% 
% plot(y0)
% figure()
% plot(y0_filtrado)
% hold on

% [B, A] = butter(5, 0.02, 'low');
% filtered = transpose(filtfilt(B, A, transpose(y0)));
% 
% plot(filtered)

% y0 = filtered;
% load('dados/dados_para_frit_v1.mat','tremexp_com_gaiola_y0','tremexp_com_gaiola_u0');
% y0 = tremexp_com_gaiola_y0*pi*1000/(180);
% u0 = tremexp_com_gaiola_u0(2:end);


ro0 = [kp0, ki0, kd0];

ro = [kp0, ki0, kd0];

options = optimset('LargeScale','on','Algorithm','active-set','DerivativeCheck','on');
[ ro, fval, exitflag, output] = fmincon('performance_index',ro,[],[],[],[],[0, 0, 0],[10, 10, 10],'funcon',options);

ro
figure()
plot(y0)
hold on
plot(-r0)
