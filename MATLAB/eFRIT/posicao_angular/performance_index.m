function [J] = performance_index(ro)
global Tds y0 T u0 z lambda fs

Tdsd = Tds * tf(1,1,'ioDelay',ro(4));
Tdd = c2d(Tdsd,T,'zoh');
C = ro(1) + ro(3)*(1 - z^(-1))/T + ro(2)*T/(1 - z^(-1));
ri = lsim(1/C,u0) + y0;
yi  = lsim(Tdd,ri);
e   = y0 - yi;
Je  = ( e' *  e ) / length(y0);

ei = ri - yi;
ui = lsim(C,ei);
dui = ui - [0; ui(1:end-1)];
Ju = ( lambda * fs )^2 * ( dui' * dui ) / length(dui);
J  = Je + Ju;
end

