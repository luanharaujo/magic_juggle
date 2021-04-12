clear
close all
global y0 Td T u0


T = 0.01;
z = tf([1 0],[1],T);

a = 1;
b = 1;

G = b / (z - a);

b0 = 0.4673;
b1 = -0.3393;
a1 = -1.5327;
a2 = 0.6607;

Td = (b0*z + b1) / (z^2 + a1*z + a2);

kp = -b1 / b;
ki = (b0 + b1) / b;

C = kp + ki*z / (z -1);
step(Td)
% hold on
% step(C*G / (1 + C*G))
% hold off

i = 1;
kp0 = 0.1;
ki0 = 0.1;
out = sim("simulacao.slx");
ro0 = [kp0, ki0];
y0 = out.y.data;
u0 = out.u.data;
r0 = out.r.data;

ro = [kp0, ki0];

options = optimset('LargeScale','on','Algorithm','active-set','DerivativeCheck','on');
[ ro, fval, exitflag, output] = fmincon('performance_index',ro,[],[],[],[],[0, 0],[10, 10],'funcon',options);
kp
ki
ro

C = ro(1) + ro(2)*z / (z -1);
%figure()
hold on
step(C*G / (1 + C*G))


