function [RM_b2g,RM_g2b] = RM(psi,phi,theta)
    %Rotation matrixs
    RM_b2g = [  cos(psi)*cos(theta)     cos(psi)*sin(theta)*sin(phi) - sin(psi)*cos(phi)    cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi);
                sin(psi)*cos(theta)     sin(psi)*sin(theta)*sin(phi) + cos(psi)*cos(phi)    sin(psi)*sin(theta)*cos(phi) - cos(psi)*sin(phi);
                -sin(theta)             cos(theta)*sin(phi)                                 cos(theta)*cos(phi)                                 ];
    
    %RM_g2b = inv(RM_b2g);%mudar para transposta
    RM_g2b = RM_b2g';
end

