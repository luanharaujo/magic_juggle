function [Je] = performance_index(ro)
global Td y0 T u0
z = tf([1 0],1,T);

C = ((ro(1) + ro(2))*z -ro(1)) / (z-1);
ri = lsim(1/C,u0) + y0;
yi  = lsim(Td,ri);
e   = y0 - yi;
Je  = ( e' *  e ) / length(y0); 
end

