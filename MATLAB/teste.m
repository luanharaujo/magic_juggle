clc
close all

phi = 0;
psi = pi/4;
theta = 0;

g=[0; 0; -9.89];
[RM_b2g,RM_g2b] = RM(phi,psi,theta);
gt = RM_b2g*g;
norm(g)
norm(gt)
quiver3(0,0,0,gt(1),gt(2),gt(3));
axis([-10 10 -10 10 -10 10]);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
