function PrepareRuns(outdir, S1, kc, n0Total, nu)
% Runs the Gillespie simulation of the Birth-Death Bacteria process
% INPUTS:
% outdir - Directory run will execute
% nDilutions - number of dilutions before stopping simulation
% S1 - fraction from [0,1] for nutrient 1 of the two
% c0Total - Total amount of nutrient at time zero
% n0Total - Total population size at time zero
% contaminationFraction - Fraction of population that is a contaminating species at start of dilution. Set zero for no contamination.
% nu - the probabiliy for a new species to be born  

rng('shuffle'); % Essential !!! Shuffle random number generator

if(~exist(outdir,'dir'))
    mkdir(outdir);
else
    disp(['Directory ' outdir ' exists. Continuing.']);
end
    

% number of nutrients and their ratio
p = 2;
if(S1<0||S1>1)
   disp('Bad S1 value! Aborting');
   return;
end
S = [S1,1-S1]';

useMex = true; % If true, use mex (compiled) version
if(~useMex)
    warning('Not using mex');
end
%if(~exist(outdir,'dir'))
%    mkdir(outdir);
%end

m = 200; % number of species
m_initial = 20; % number of initial species

MAX_OUTPUT_LENGTH = 2E6;
DISPLAY_EVERY = 1E5;

% All params:

% params = InitParams(m,m_initial,S);
% disp('Loading strategies from savedStrategies.mat');
% load('savedStrategies.mat');
% % params.Strategies = Strategies;
% params.Strategies(1:200,:) = Strategies(1:200,:);

params = struct;
params.isneutral = false; % "Neutral" Theory

params.m = m; % Number of species
params.m_initial = m_initial; % Number of initial species <= m
if(params.m_initial > params.m)
   error('m_initial cannot be larger than m'); 
end

% Nutrient related:
params.E = 1;
params.S = zeros(length(S1)+1,1);
params.S(1:length(S1)) = S1; % Vector of size p for nutrient supply
params.S(end) = params.E - sum(S1);
params.p = length(S); % Number of nutrients
params.kc = kc; % nutrient halfmax


% Species related:
params.nu = nu;
% Strategies (columns - nutrients, rows - species)
params.uniformStrategies = true;
if(params.uniformStrategies)
    params.Strategies = randfixedsum(params.p,params.m,1,0,1)';
    params.Strategies(1:params.m_initial,1) = linspace(1E-6,1-1E-6,params.m_initial);
    params.Strategies(1:params.m_initial,2) = 1 - params.Strategies(1:params.m_initial,1);
else
    % When p>2, we need to use Dirichlet distribution. Currently unsupported
    if(params.p>2)
        error('Currently not supporting Dirichlet numbers. Please implement');
    end
    BetaParam = 4;
    params.Strategies(1:params.m,1) = betarnd(BetaParam,BetaParam,params.m,1);
    params.Strategies(1:params.m,2) = 1-params.Strategies(1:params.m,1);
end


% Add keystone species as specialists
params.withSpecialists = false;
if(params.withSpecialists)
    params.Strategies(1:params.p,:) = eye(params.p);
end

% Initial abundances:
params.n0 = zeros(params.m,1);
params.randomInitialn0 = false;
if(params.randomInitialn0)    
    params.n0(1:params.m_initial) = round(randfixedsum(params.m_initial,1,n0Total,0,n0Total));
    [mx,mind] = max(params.n0);
    params.n0(mind) = params.n0(mind)+(n0Total-sum(params.n0));
else
    params.n0(1:params.m_initial) = round(n0Total/params.m_initial);
end
% Display simulation
disp(params);
save([outdir '/params.mat']);


                              
                              
