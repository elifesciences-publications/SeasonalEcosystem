function DilutionEnds=RunSimulateBatchDilution(params, outdir, nDilutions, c0Total)
% Runs the Gillespie simulation of the Birth-Death Bacteria process
% INPUTS:
% outdir - Directory where params.mat exists and where to write output
% nDilutions - number of dilutions before stopping simulation
% c0Total - Total amount of nutrient at time zero
% OUTPUT:
% DilutionEnds - structure

scurr = rng('shuffle'); % Essential !!! Shuffle random number generator

disp(['Random number generator ' scurr.Type ' seed ' num2str(scurr.Seed)]);

% rng(12345); % Always same seed

useMex = true; % If true, use mex (compiled) version
useMutation = true; % Mutate, so that nutrient consumed by pre-mutation species
if(~useMex)
    warning('Not using mex');
end
%if(~exist(outdir,'dir'))
%    mkdir(outdir);
%end

% MAX_OUTPUT_LENGTH = 2E6;
DISPLAY_EVERY = 1E5;

% spike_frac=0.05;
spike_frac=0;

% Read params:
newn0 = zeros(size(params.n0)); % For codegen
S1 = params.S(1);
params.S = params.S*c0Total;

% Random initial abundances:
% params.n0 = zeros(params.m+1,1);
% params.n0(1:params.m_initial) = round(randfixedsum(params.m_initial,1,sum(params.n0),0,sum(params.n0)));
% [mx,mind] = max(params.n0);
% params.n0(mind) = params.n0(mind)+(sum(params.n0)-sum(params.n0));

% Display simulation params
disp(params);

% Init output
DilutionEnds = struct;
DilutionEnds.nends = NaN(nDilutions,params.m); % Species Abundances (end of batch)
DilutionEnds.nbegins = NaN(nDilutions,params.m); % Species Abundances (beginning of batch)
DilutionEnds.Sends = NaN(nDilutions,1); % Species diversity entropies (end of batch)
DilutionEnds.Sbegins = NaN(nDilutions,1); % Species diversity entropies (beginning of batch)
DilutionEnds.cends = NaN(nDilutions,params.p); % Nutrients
DilutionEnds.nMigrations = NaN(nDilutions,1); % Migrations
DilutionEnds.tends = NaN(nDilutions,1); % Gillespie time
% DilutionEnds.contaminationFraction = 0;

% Get outfile
outfile = [outdir filesep 'out'];
outfile = [outfile '_K_' num2str(params.kc) '_c0_' num2str(c0Total) '_S1_' num2str(S1) ...
    '_nu_' num2str(params.nu) '_N0_' num2str(sum(params.n0)) '_dilutions_' num2str(nDilutions)];
if(params.isneutral==true)
    outfile = [outfile '_neutral'];
end
if(spike_frac>0)
    outfile = [outfile '_spike_' num2str(spike_frac)];
end
outfile = [outfile '.mat'];
disp(['Will write file ' outfile]);


newn0 = params.n0;
tDilutionEnds = DilutionEnds;

for nt=1:nDilutions
    if(mod(nt,100)==0)
        disp(['Dilution ' num2str(nt)]);
    end
    if(mod(nt,1001)==0)        
        do_save(nt-1,tDilutionEnds,outfile,params,spike_frac);
    end    
            
    tDilutionEnds.nbegins(nt,:) = newn0;
    P = nonzeros(newn0);
    P = P / sum(P);    
    tDilutionEnds.Sbegins(nt) = -sum(P.*log(P));

    % Run simulation        
    if(useMex)
        host = getenv('HOSTNAME');
        if(length(host)<5)
            [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies_mex(newn0,params,c0Total+100,DISPLAY_EVERY);
        elseif(strcmp(host(1:5),'tiger')==1)
            [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies_tiger_mex(newn0,params,c0Total+100,DISPLAY_EVERY);
        elseif(strcmp(host(1:5),'della')==1)
            [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies_della_mex(newn0,params,c0Total+100,DISPLAY_EVERY);
        end
    else
        [~,Sn,t,n,c,nMigrations] = SimulateBatchDilutionBacteriaMutationManySpecies(newn0,params,c0Total+10,DISPLAY_EVERY);
    end
    
    % Dilute for new initial conditions.     
%     newn0 = dilute(n,params,'round');
%     newn0 = dilute(n,params,'hypergeo');
%     newn0 = dilute(n,params,'ceil');
%     newn0 = dilute(n,params,'spike');
    newn0 = dilute(n,params,spike_frac);

      
    % Save current dilution
    tDilutionEnds.nends(nt,:) = n(end,:);
    tDilutionEnds.cends(nt,:) = c(end,:);
    tDilutionEnds.Sends(nt) = Sn(end);
    tDilutionEnds.tends(nt) = t(end);
    tDilutionEnds.nMigrations(nt) = nMigrations;
end

if(nDilutions>0)
    disp('Done.');
    disp('------------------------------');
    DilutionEnds=do_save(nt,tDilutionEnds,outfile,params,spike_frac);
end

function DilutionEnds=do_save(nt,tDilutionEnds,outfile,params, spike_frac)
    disp(['Saving ' outfile]);
    DilutionEnds.nends = tDilutionEnds.nends(1:nt,:);
    DilutionEnds.nbegins = tDilutionEnds.nbegins(1:nt,:);
    DilutionEnds.cends = tDilutionEnds.cends(1:nt,:);
    DilutionEnds.Sends = tDilutionEnds.Sends(1:nt);
    DilutionEnds.Sbegins = tDilutionEnds.Sbegins(1:nt);
    DilutionEnds.nMigrations = tDilutionEnds.nMigrations(1:nt);
    DilutionEnds.tends = tDilutionEnds.tends(1:nt);
    DilutionEnds.nends = sparse(DilutionEnds.nends);
    DilutionEnds.nbegins = sparse(DilutionEnds.nbegins);
    DilutionEnds.spike_frac = spike_frac;
    if(isempty(outfile))
        return;
        %        disp('Not saving');
    end
    save(outfile,'params','DilutionEnds');

                              
function newn0 = dilute(n,params,spike_frac)
    % Dilute by keeping exact fractions
    if(spike_frac>1 || spike_frac<0)
        error('Bad spike fraction');
    end
%     to_add = my_hygernd(params.n0,ceil(sum(params.n0)*spike_frac));    
    to_add = mnrnd(ceil(sum(params.n0)*spike_frac),params.n0/sum(params.n0))';
    newn0 = to_add + my_hygernd(n(end,:)',sum(params.n0)-sum(to_add));

