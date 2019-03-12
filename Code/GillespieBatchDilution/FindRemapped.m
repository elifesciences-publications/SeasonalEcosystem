function [remapped_vec] = FindRemapped(n0, params,c0,supply_vecs)
% Finds remapped supply based on nutrient integral

% load('SavedData/S0.1_Randn0_nusweep/params.mat')
% params.nu = 0.002;
% params.nu=0;
% params.S = [0.1,0.9];
% c0s = round(10.^[2:0.25:5]);
% vals = linspace(0,1,50);
% supply_vecs = [vals;1-vals]';

% % Find strategy nearest to supply and put all species there.
% norm_strategies = params.Strategies./ repmat(sqrt(sum(params.Strategies.^2,2)),1,size(params.Strategies,2));
% projections =   sum(norm_strategies.*(params.S/sqrt(sum(params.S.^2))));
% [~,chosen_strategy] = max(projections);
% params.Strategies(chosen_strategy,:) = params.S/sum(params.S);
% params.n0 = zeros(size(params.n0));
% params.n0(chosen_strategy) = n0;

orderparam = zeros(length(supply_vecs),1);
massconserv = NaN(length(supply_vecs),1);

useMex = true;

% disp(['c0=' num2str(c0)]);
T_distance = zeros(length(supply_vecs),1);
for vv=1:length(supply_vecs)
%     disp([vv, length(supply_vecs)]);
    params.S = supply_vecs(vv,:)'*c0;
%         disp(['c0=' num2str(c0s(cc)) ' ; S1=' num2str(supply_vecs(vv))]);
    if(useMex)
        host = getenv('HOSTNAME');
        if(length(host)<5)
            [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies_mex(params.n0,params,c0+100,1E6);
        elseif(strcmp(host(1:5),'tiger')==1)
            [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies_tiger_mex(params.n0,params,c0+100,1E6);
        elseif(strcmp(host(1:5),'della')==1)
            [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies_della_mex(params.n0,params,c0+100,1E6);
        end
    else
        [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies(params.n0,params,c0+10,1E6);
    end

    cMonod = c./(c+params.kc);     
    T = zeros(size(c,2),1);
    if(length(t)>1)
        for pp=1:size(c,2)
            T(pp) = trapz(t,cMonod(:,pp));
        end
    end
    T_distance(vv) = sum(sum((repmat(T,1,length(T)) - repmat(T',length(T),1)).^2));
%         
%         orderparam(vv,cc) = (C1-C2)/(C1+C2);
%         growth_factor = exp(params.Strategies(1,:)*[C1,C2]');
%         actual_growth = (params.n0(chosen_strategy)+sum(params.S'-c(end,:)))/params.n0(chosen_strategy);
%         massconserv(vv,cc) = growth_factor/actual_growth;        
end
% [~,mind] = min(abs(orderparam));
[~,mind] = min(T_distance);
remapped_vec = supply_vecs(mind,:);






