function dx = adaptor_RHS(x,s,K,del)
%This script compute the RHS for the adapter ODEs

%Initialize vector of changes
dx = zeros(size(x));

%Extract variables from main vector
c = x(1:2);
p = length(c);
rho = x(3:end-3);
svar = x(end-2:end-1);
c_ctrl = x(end);

%Augment strategy matrix to include adapter
s_new = [s; svar(1) svar(2)];

%Compute growth rates
growth_rate = s_new*(c./(K + c));
dx(3:end-3) = rho.*growth_rate;

%Compute adapter strategy changes
dx(end-2) = growth_rate(end)*(del*c_ctrl - svar(1));
dx(end-1) = growth_rate(end)*(del*(1-c_ctrl) - svar(2));

%Compute nutrient consumption rates
dx(1:2) = -(c./(K + c)).*transpose(sum(s_new.*repmat(rho,1,p)));

end

