clear
close all
global y0 Tds T u0 z lambda fs

%system('../../scripts/ultimo_parametro.sh');

parametros = load('./dados/ultimos_parametros.csv');

%pid_rate

lambda = 1;

r_pitch_kp = parametros(4);
r_pitch_ki = parametros(5);
r_pitch_kd = parametros(6);

kp0 = r_pitch_kp
ki0 = r_pitch_ki
kd0 = r_pitch_kd
L0 = 6

% kp0 = 250;
% ki0 = 500;
% kd0 = 2.5;

T = 1/500;
z = tf([1 0], 1, T);
s = tf([1 0], 1);

Tds = 1/(0.05*s + 1)^7;
Td =  c2d(Tds, T, 'zoh');
%Td = tf(1, [1 0 0 0 0 0], T, 'InputDelay', 2)


load('dados/posicao_angular_gaiola_P_2.mat','stateEstimate0x2Epitch','controller0x2EpitchRate','ref_gy');
y0 = stateEstimate0x2Epitch;
u0 = controller0x2EpitchRate;
r0 = ref_gy;

ro0 = [kp0, ki0, kd0];
ro = [kp0, ki0, kd0, L0];


Tdsd = Tds * tf(1,1,'ioDelay',L0);
Tdd = c2d(Tdsd,T,'zoh');
C = ro(1) + ro(3)*(1 - z^(-1))/T + ro(2)*T/(1 - z^(-1));
ri = lsim(1/C,u0) + y0;
yi  = lsim(Tdd,ri);
e   = y0 - yi;
Je  = ( e' *  e ) / length(y0);

ei = ri - yi;
ui = lsim(C,ei);
dui = ui - [0; ui(1:end-1)];
Ju   = ( dui' * dui ) / length(dui);

fs = sqrt( Je / Ju );	

options = optimset('LargeScale','on','Algorithm','active-set','DerivativeCheck','on');
[ ro, fval, exitflag, output] = fmincon('performance_index',ro,[],[],[],[],[0, 0, 0, 0],[10, 10, 10, 10],'funcon',options);

ro
figure()
plot(y0)
hold on
plot(-r0)
