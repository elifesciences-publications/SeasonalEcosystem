function [nSteps,Sn,t,n,c,nMutations] = SimulateBatchDilutionBacteriaMutationManySpecies(n0,params, MAX_OUTPUT_LENGTH,DISPLAY_EVERY)
%#codegen
%   Simulates Gillespie dynamics of nutrient competition
%
%   Reference: 
%       Gillespie, D.T. (1977) Exact Stochastic Simulation of Coupled
%       Chemical Reactions. J Phys Chem, 81:25, 2340-2361.
%
%   Adapted by Amir Erez 2017 (amir.b.erez@gmail.com)
% 
% INPUTS:
%
%   n0 = vector of initial species abundances
%   params.Strategies = species strategies
%        Last species is reserved for "inhibitory" species
%
%
% OUTPUTS:
%
% nSteps = number of gillespie steps
% Sn = Shannon entropy at each time point
% t = time axis for reactions
% n = species abundances for reactions
% c = nutrient level for reactions (starts as C(t=0) = param.S, stops when nutrients finished)
% nMutations = number of migration events

%% Initialize

% No inhibitor species, so alphas are the actual strategies.
alphas = params.Strategies;
nSpecies = length(n0);

% There are actually a lot more "species" than the number that initially start
% That is because we allow for strategies that are currently unoccupied

t = zeros(MAX_OUTPUT_LENGTH, 1);
n = zeros(MAX_OUTPUT_LENGTH, nSpecies);
c = zeros(MAX_OUTPUT_LENGTH, length(params.S));
t(1)     = 0;
n(1,:)   = n0;
c(1,:)   = params.S';

nMutations = 0;
nSteps = 0;
prevn = n0;
prevc = params.S';
newc = NaN*prevc;
curt = 0;
rxn_count = 1;

Sn = zeros(MAX_OUTPUT_LENGTH, 1); % Entropy at each time point

if(MAX_OUTPUT_LENGTH<sum(params.S))
   disp('Error! MAX_OUTPUT_LENGTH < sum(S). Raise it.');
   return;
end

%% MAIN LOOP
      
while (rxn_count<MAX_OUTPUT_LENGTH && (rxn_count==1 || sum(abs(newc))>1))
    if(mod(rxn_count,DISPLAY_EVERY)==0)
        fprintf('t = %.2f\n',curt);
    end

    % Leave out last species for "inhibitor" one day
    nzspecies = find(prevn); 
    prevc(prevc<0) = 0;
    
    cMonod = prevc./(prevc+params.kc);

    if(~params.isneutral)
        growth = alphas(nzspecies,:)*(cMonod');
        a = prevn(nzspecies).*growth;
    else
        a = prevn(nzspecies);
    end
    
    a0 = sum(a);
    r = rand(1,3);
    tau = -log(r(1))/a0;
    mu = find((cumsum(a) >= r(2)*a0), 1,'first');
    mu = mu(1); %For codegen
    newmu = nzspecies(mu);
    DeltaNutrient = alphas(newmu,:).*cMonod;
    
    if(r(3)<params.nu) % Mutate !
        nMutations = nMutations+1;
        newmu = ceil(rand()*params.m);  
        newmu = newmu(1); %For codegen
    end
               
    % Update time and carry out reaction mu
    newn = prevn;
    newn(newmu) = newn(newmu)+1;
        
    s = sum(DeltaNutrient);
    if(s==0)
        disp('Warning! Zero nutrient consumption !');
        break;
    end
    dc = DeltaNutrient/s;
    if(any(isnan(dc)))
        disp('Error. Aborting');
        return;
    end
    newc = prevc - dc; % Remove one unit of nutrient
    
    curt = curt + tau;
    t(rxn_count+1)   = curt;
    n(rxn_count+1,:) = newn;
    c(rxn_count+1,:) = newc;
    
    nz = nonzeros(newn);
    Probs = nz/(sum(nz));
    Sn(rxn_count+1) = -sum(Probs.*log(Probs));
    
    rxn_count = rxn_count + 1;
    prevn = newn;
    prevc = newc;    
end  

if(rxn_count==MAX_OUTPUT_LENGTH)
   disp('Error! Reached MAX_OUTPUT_LENGTH');
   return;
end

nSteps = rxn_count;

% Return simulation time course
t = t(1:rxn_count);
n = n(1:rxn_count,:);
Sn = Sn(1:rxn_count,:);
c = c(1:rxn_count,:);

if(max(c(end,:))>1)
    fprintf('Warning: max(c) finished at %.3f\n',max(c(end,:)));
end

end

