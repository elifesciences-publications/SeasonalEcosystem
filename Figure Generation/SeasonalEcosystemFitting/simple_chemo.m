%This is the RHS for an E. coli chemostat

function rhs = simple_chemo(t,x,alpha,d,s,Y,K)

rhs = zeros(4,1);
rhs(1) = x(1)*(Y*alpha(1)*x(2)/(K(1) + x(2)) + Y*alpha(2)*x(3)/(K(2) + x(3)) + ...
    + Y*alpha(3)*x(4)/(K(3) + x(4))  - d);
rhs(2) = s(1) - alpha(1)*x(2)*x(1)/(K(1) + x(2)) - d*x(2);
rhs(3) = s(2) - alpha(2)*x(3)*x(1)/(K(2) + x(3)) - d*x(3);
rhs(4) = s(3) - alpha(3)*x(4)*x(1)/(K(3) + x(4)) - d*x(4);

end


