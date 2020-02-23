function [xfinal,xstore,tstore,switch_num] = ...
    adaptor_batch(b0,rho0,c0,P,s,K,del,s_init,ctrl_init,cutoff,plt,rc,flux_control)

%This script runs a single batch of the adapter simulation

%Order is [c1, c2, rho_1,...rho_m, rho_adapter, alpha1_adapter, alpha2_adapter, ctrl state]
x0 = [P*c0; rho0.*b0 ; s_init; ctrl_init];

%Fill in missing variables with defaults
if ~exist('rc')
    rc = 1e-8;
end

if ~exist('flux_control')
    flux_control = false;
end

%Maximum relative change within a single timestep
maxchange = 0.01;

%Initialize loop tracking variables and storage vectors
u = 0;
tn = 1;
xstore = zeros(length(x0),1e7);
xstore(:,1) = x0;
state_store = zeros(1,1e7);
tstore = state_store;

%Initialize current nutrient stte
state_store(1) = P(1) > P(2);

%Run simulation with RK4
while u == 0
    
    xi = xstore(:,tn);
    dx1 = adaptor_RHS(xi,s,K,del);
    
    relchange = max(abs(dx1(1:end-1)./xi(1:end-1)));
    dt = maxchange/relchange; %Set time step
    
    xii = xi + 0.5*dt*dx1;
    dx2 = adaptor_RHS(xii,s,K,del);
    
    xiii = xi + 0.5*dt*dx2;
    dx3 = adaptor_RHS(xiii,s,K,del);
    
    xiv = xi + dt*dx3;
    dx4 = adaptor_RHS(xiv,s,K,del);
    
    x_new = ...
        xstore(:,tn) + dt*((1/6)*dx1 + (1/3)*dx2 + (1/3)*dx3 + (1/6)*dx4);
    
    if min(x_new) < 0
        u = 1;
        disp('ENDED DUE TO NEGATIVE STATE VARIABLES')
    end
    
    %Compute delta and determine whether to change control state
    if flux_control
        flux = xi(1:2)./(K + xi(1:2));
        state = flux(1) > flux(2);
        relative_c_diff = abs(flux(1) - flux(2))/max(flux);
    else
        state = xi(1) > xi(2);
        relative_c_diff = abs(xi(1) - xi(2))/max(xi(1:2));
    end
    if (xi(end) ~= state) && (relative_c_diff > cutoff)
        x_new(end) = state;
    end
    
    xstore(:,tn+1) = x_new;
    tstore(tn+1) = tstore(tn) + dt;
    state_store(tn+1) = state;
    
    %Set negligible nutrient amounts to zero to speed up integrator
    xstore(xstore(1:2,tn+1)<1e-75,tn+1) = 0; 
    
    %End if nutrients have been sufficiently depleted
    if max(xstore(1:2,tn+1)./(P.*c0)) < rc
        u = 1;
    end
    tn = tn + 1;
    
    
end

%Truncate storage vectors
xstore = xstore(:,1:tn);
state_store = state_store(1:tn);
tstore = tstore(1:tn);
xfinal = xstore(:,tn);
switch_num = sum(abs(diff(xstore(end,:))));


if plt
    
    figure
    subplot(1,2,1)
    hold on
    imap = jet(size(s,1)+1);
    imap = [1 0 0; 0 0 1; imap];
    legend_labels = cellstr(strcat('Species ',string(1:size(s,1))));
    legend_labels = [{'Nutrient 1','Nutrient 2'},legend_labels,'Adaptor'];
    for ii = 1:(length(x0)-3)
        plot(tstore,xstore(ii,:),'Color',imap(ii,:),'LineWidth',2)
    end
    
    legend(legend_labels,...
        'Location','southeast')
    xlabel('Time')
    ylabel('Concentration')
    
    subplot(1,2,2)
    hold on
    for ii = size(xstore,1)-2:size(xstore,1)
        plot(tstore,xstore(ii,:),'LineWidth',2)
    end
    plot(tstore,state_store)
    legend({'Strategy 1','Strategy 2','Control state','Nutrient 1 Greater'},...
        'Location','southeast')
    xlabel('Time')
    
end

end
