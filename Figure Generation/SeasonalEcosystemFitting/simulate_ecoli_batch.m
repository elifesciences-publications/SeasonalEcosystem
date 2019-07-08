function [state_vec,batch_series] = simulate_ecoli_batch(time_vec,alpha1,alpha2,Y,K,IC,t_c)

if length(time_vec) < 15 %This gets the script through testing
    state_vec = time_vec;
else
    %Initial conditions and start points for dataset 1
    c10 = IC(1); %Glucose mg/L
    c20 = IC(2); %Galactose mg/L
    rho0 = IC(3); %Biomass mg/L

    %Compute indices of different time series
    n_p = find(~time_vec);
    ind = [1,n_p(2)-1;n_p(2),n_p(3)-1;n_p(3),length(time_vec)];
    
    %Parameters
    c0 = c10 + c20;
    P = [c10; c20]/c0;
    m = 1;
    p = 2;
    nu = [Y;Y];
    s = [alpha1,alpha2];
    
    %Simulate and convert to time series
    [~,~,rhostore,cstore,tstore] = multispeciesbatchMADAPT_variable_K_nu_time(1,rho0,c0,s,P,m,p,0,K,nu,t_c);
    batch_series = timeseries(transpose([cstore; rhostore]),transpose(tstore));
    batch_times = resample(batch_series,time_vec);
    batch_data = batch_times.Data;
    state_vec = zeros(length(batch_data(:,1)),1);
    
    %Process into single vector
    for i = 1:3
        batch_times = resample(batch_series,time_vec(ind(i,1):ind(i,2)));
        batch_data = batch_times.Data;
        state_vec(ind(i,1):ind(i,2)) = batch_data(:,i);
    end
end

end

