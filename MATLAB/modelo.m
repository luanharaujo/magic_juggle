%rodando o script que puxa os ultimos parametros do outro computador
!powershell -inputformat none -file .\scripts\ultimo_parametro.ps1

%abrindo o arquivo csv
parametros = load('./dados/ultimos_parametros.csv');

%posCtlPID
xKp = parametros(19);
xKi = parametros(20);
xKd = parametros(21);

yKp = parametros(22);
yKi = parametros(23);
yKd = parametros(24);

xyVelMax = parametros(31);

zKp = parametros(25);
zKi = parametros(26);
zKd = parametros(27);

zVelMax = parametros(32);
if zVelMax < 0.5 %mirroring the formware code
    zVelMax = 0.5;
end

vxKp = parametros(33);
vxKi = parametros(34);
vxKd = parametros(35);

vyKp = parametros(36);
vyKi = parametros(37);
vyKd = parametros(38);

vzKp = parametros(39);
vzKi = parametros(40);
vzKd = parametros(41);

%pid_attitude
roll_kp = parametros(1);
roll_ki = parametros(2);
roll_kd = parametros(3);

pitch_kp = parametros(4);
pitch_ki = parametros(5);
pitch_kd = parametros(6);

yaw_kp = parametros(7);
yaw_ki = parametros(8);
yaw_kd = parametros(9);

%pid_rate
r_roll_kp = parametros(10);
r_roll_ki = parametros(11);
r_roll_kd = parametros(12);

r_pitch_kp = parametros(13);
r_pitch_ki = parametros(14);
r_pitch_kd = parametros(15);

r_yaw_kp = parametros(16);
r_yaw_ki = parametros(17);
r_yaw_kd = parametros(18);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Arrumar a posição depois
rpLimit = parametros(42);
thrustBase = parametros(43);
thrustMim = parametros(44);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m=27/1000;%mass (27g naked)
g = 9.89;%pra fazer LUAN!!!!!!!!!!!!!!!!!
%pegar gravidade do simulink
max_thrust = (58*g)/1000;%Newton
arm_length = 0.0065;%meter
I = [1.66e-05  0 0; 0 1.66e-05 0; 0 0 2.93e-05];%inertia

%PIDs period
Tpid_pos = 1/100;
Tpid_vel = 1/100;
Tpid_att = 1/500;
Tpid_rat = 1/500;

open_system modelo_pid
