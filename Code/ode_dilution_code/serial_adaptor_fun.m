function [bstore,sstore,mult_non_adapt,mult_adapt,ctrl_store] = ...
    serial_adaptor_fun(b0,rho0,c0,s,P,plt,K,cutoff,save_sim,sim_id,rc,...
    folder,flux_control,tb_max)

%This script runs a serial dilution course of the adapter simulation. It
%will optionally save these results to a file. It will also output the
%intra-batch results of a final batch

%Fill in missing variables with defaults
if ~exist('folder')
    folder = 'results';
end
if ~exist('rc')
    rc = 1e-8;
end
if ~exist('flux_control')
    flux_control = false;
end

p = size(P,1); %Compute p
del = 1; %Enzyme budget of adaptor

%Initialize adaptor as producing dominant enzyme
ctrl_init = P(1) > P(2);

%Initialize loop variables and storage vectors
bstore = zeros(length(b0),tb_max);
bstore(:,1) = b0;
sstore = zeros(p,tb_max);
sstore(:,1) = zeros(p,1) + del/p;
ctrl_store = zeros(1,tb_max);
ctrl_store(1) = ctrl_init;
switch_store = zeros(1,tb_max);
u = 0;
tb = 1;

%Run serial dilution simulation
while u == 0   
    [xfinal,~,~,switch_num] = ...
        adaptor_batch(bstore(:,tb),rho0,c0,P,s,K,del,sstore(:,tb),ctrl_store(tb),cutoff,0,rc,flux_control);
    bstore(:,tb+1) = xfinal(3:end-3)/sum(xfinal(3:end-3));
    sstore(:,tb+1) = xfinal(end-2:end-1);
    ctrl_store(tb+1) = xfinal(end);
    switch_store(tb+1) = switch_num;
    
    if tb>tb_max %End simulation once maximum time exceeded
        u = 1;
    end   
    
    tb = tb + 1;    
end

%Truncate storage vectors
bstore = bstore(:,1:tb);
sstore = sstore(:,1:tb);
ctrl_store = ctrl_store(1:tb);
switch_store = switch_store(1:tb);

%% Plot interbatch dynamics

m = size(s,1) + 1;

if plt    
    figure
    hold on
    legend_labels = cellstr(strcat('Species ',string(1:m-1)));
    legend_labels = [legend_labels,{'Adaptor'}];
    imap = jet(size(bstore,1)+1);
    for ii = 1:size(bstore,1)-1
        plot(1:tb,bstore(ii,:),'Color',imap(ii,:), 'DisplayName',...
            legend_labels{ii},'LineWidth',2)
    end
    plot(1:tb,bstore(end,:),'-','Color',imap(end,:), 'DisplayName',...
        legend_labels{end},'LineWidth',2)
    plot(1:tb,sstore(1,:),'--','DisplayName','Adaptor Strategy');
    xlabel('Batch number')
    ylabel('Population fraction at batch start')
    legend()
    set(gca,'YScale','log')
end

%% Look at a final batch of the system

[xfinal,xstore,tstore] = adaptor_batch(bstore(:,tb),...
    rho0,c0,P,s,K,del,sstore(:,tb),ctrl_store(tb),cutoff,plt,rc,flux_control);

% Check that total adaptor budget is constant
if plt
    figure;plot(tstore,sum(xstore(end-2:end-1,:)),'k-')
    title('Total adaptor strategy budget')
end

% Compute growth properties of different species
I_new = trapz(transpose(tstore),transpose(xstore(1:2,:)./(K+(xstore(1:2,:)))));
adaptor_growth = transpose(xstore(end-2:end-1,:)).*transpose(xstore(1:2,:));
sI_adapt = trapz(transpose(tstore),adaptor_growth./(K+transpose(xstore(1:2,:))));
mult_non_adapt = exp(s*transpose(I_new));
mult_adapt = exp(sum(sI_adapt));
growth = s*transpose(I_new); 
mult = exp(growth); 
g = log((c0+rho0)/rho0); 


%% Save results if specified
if save_sim
    save([folder,'/serial_adaptor_sim_id_',num2str(sim_id),'.mat'])
end

end
