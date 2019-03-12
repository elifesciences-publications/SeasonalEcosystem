% Runs different dilution regimes
load('Data/DilutionRegimes/params.mat');

c0s=[100, 1000, 10000];

for cc=1:length(c0s)
    % FIRST set spike_frac = 0, nu=0
    params.nu=0;
    RunSimulateBatchDilution(params,'Data/DilutionRegimes/',10000,c0s(cc));
    
    % FIRST set spike_frac = 0, nu=0.005
    params.nu=0.005;
    RunSimulateBatchDilution(params,'Data/DilutionRegimes/',10000,c0s(cc));
end

%% NEXT set spike_frac = 0.05 (currently hardcoded)
for cc=1:length(c0s)
    params.nu=0;
    RunSimulateBatchDilution(params,'Data/DilutionRegimes/',10000,c0s(cc));
end

