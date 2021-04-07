function [Je] = performance_index(ro)
global Td y0 T u0 z

%C = ro(1) + ro(3)*(1 - z^(-T))/T + ro(2)*T/(1 - z^(-T));
C = ro(1) + ro(3)*(1 - z^(-1))/T + ro(2)*T/(1 - z^(-1));
ri = lsim(1/C,u0) + y0;
yi  = lsim(Td,ri);
e   = y0 - yi;
Je  = ( e' *  e ) / length(y0); 
end

