clear;clc

%This script runs an adaptor invasion

p = 2;
s = transpose(linspace(0,1,21));
s = [s, 1- s];
m = size(s,1);
K  = 1; 
rho0 = 1;
c0 = 1e3; 
P = [0.55; 0.45]; 
b0 = zeros(m,1) + 1/(m);
rc = 1e-7;
cutoff = 0.25;
save_sim = 0;
sim_id = 1;
tb_max = 1e2;
errtype = 1;
plt = 1;
folder = '';
flux_control = 0;
invasion_size = 0.35;


%% Run non-adapter for initial condition of invasion

[b0f,Nr] = serialdilMADAPT(rho0,c0,s,P,m,p,plt,b0,errtype,K);

new_b0 = [b0f*(1-invasion_size); invasion_size];

%% Simulate adapter invasion

[bstore,sstore,mult_non_adapt,mult_adapt,ctrl_store] = ...
    serial_adaptor_fun(new_b0,rho0,c0,s,P,plt,K,cutoff,save_sim,sim_id,...
    rc,folder,flux_control,tb_max);

