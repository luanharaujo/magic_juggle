clear
close all

T = 0.01;
z = tf([1 0],[1],T);

a = 1;
b = 1;

G = b / (z - a)

b0 = 0.4673;
b1 = -0.3393;
a1 = -1.5327;
a2 = 0.6607;

Td = (b0*z + b1) / (z^2 + a1*z + a2)

kp = -b1 / b;
ki = (b0 + b1) / b;

C = kp + ki*z / (z -1)
step(Td)
hold on
step(C*G / (1 + C*G))
hold off

i = 1;
kp0 = 0.5;
ki0 = 0.2;