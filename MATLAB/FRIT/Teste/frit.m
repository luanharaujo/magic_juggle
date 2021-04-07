function [ro] = frit(ro0,y0,u0,lambda,delta)
% n = size(y0);
% n = n(2);
% 
% b0 = 0.4673;
% b1 = -0.3393;
% a1 = -1.5327;
% a2 = 0.6607;
% 
% r = zeros(1,n);
% e = zeros(1,n);
% de = zeros(2,n);
% ro(:,1) = ro0;
% i = 1;
% while 1
%     kpi = ro(1,i);
%     kii = ro(2,i);
%     for k = 2:n
%         r(k) = (((u0(k) - u0(k-1)) + (r(k-1) - y0(k-1))*kpi) / (kpi + kii)) + y0(k);
%     end
%     for k = 3:n
%         e(k) = -b0*r(k-1) - b1*r(k-2) + y0(k) + a1*(y0(k-1) - e(k-1)) + a2*(y0(k-2) - e(k-2));
%     end
%     for k = 6:n
%         alpha1 = (a1*(kpi + kii)^2 - 2*(kpi + kii)*kpi)*de(1,k-1) + (kpi^2 - 2*a1*(kpi + kii)*kpi + a2*(kpi + kii)^2)*de(1,(k-2)) + (a1*kpi^2 - 2*a2*(kpi+kii)*kpi)*de(1,k-3) + a2*kii^2*de(1,k-4);
%         alpha2 = ((a1 - 1)*(kpi+kii)^2 - 2*(kpi+kii)*kpi)*de(2,k-1) + ((a2-a1)*(kpi+kii)^2 + (1-a1)*(kpi+kii)*2*kpi + kpi^2)*de(2,k-2) + ((a1-1)*kpi^2 + (a1-a2)*(kpi+kii)*2*kpi - a2*(kpi+kii)^2)*de(2,k-3) + ((a2-a1)*kpi^2 + 2*a2*(kpi+kii)*kpi)*de(2,k-4) - a2*kpi^2*de(2,k-5);
%         beta = b0*u0(k-1) + (b1 - 2*b0)*u0(k-2) + (b0 - 2*b1)*u0(k-3) + b1*u0(k-4);
%         de(1,k) = (beta - alpha1) / (kpi + kii)^2;
%         de(2,k) = (beta - alpha2) / (kpi + kii)^2;        
%     end
%     dJe = [0;0];
%     for k = 1:n
%         dJe = dJe + e(k)*de(:,k);
%     end
%     R = dJe' * dJe;
%     ro(:,i+1) = ro(:,i) - (lambda/R)*dJe;
% 
% %     if abs(ro(1,i) - ro(1,i+1)) < delta && abs(ro(2,i) - ro(2,i+1)) < delta
% %         break
% %     end
%     if mod(i,100000) == 0
%         close all
%         plot(ro(1,:),"b")
%         hold on
%         plot(ro(2,:),"r")
%         
%         legend("Kp_i","Ki_i")
%         hold off
%         drawnow
%     end
%     
%     i = i + 1;
% end   
end

