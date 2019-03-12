function remapped_vals = RunFindRemapped(params, c0s, nRepeats, outdir)
% Runs the Gillespie simulation of the Birth-Death Bacteria process

rng('shuffle'); % Essential !!! Shuffle random number generator
% rng(12345); % Always same seed

if(~exist(outdir,'dir'))
   mkdir(outdir);
end

scan_vals = linspace(0,1,201);
if(params.p == 3)
    supply_vecs = NaN*zeros(length(scan_vals)^2,params.p);
    cnt = 0;
    for v1=1:length(scan_vals)
        for v2=1:length(scan_vals)
            sum2 = scan_vals(v1)+scan_vals(v2);
            if(sum2>1), continue; end
            cnt = cnt+1;
            supply_vecs(cnt,:) = [scan_vals(v1), scan_vals(v2), abs(1-sum2)];
        end
    end
elseif(params.p == 2)
    supply_vecs = NaN*zeros(length(scan_vals),params.p); 
    cnt = 0;
    for v1=1:length(scan_vals)
        cnt = cnt+1;
        supply_vecs(cnt,:) = [scan_vals(v1), abs(1-scan_vals(v1))];
    end
else
    disp('Error!');
    return ;
end

disp('Strategies')
params.Strategies


supply_vecs = supply_vecs(1:cnt,:);
outfile = [outdir filesep 'remap'];
outfile = [outfile  '_a1_' num2str(params.Strategies(1,1)) '_K_' num2str(params.kc) ...
    '_nu_' num2str(params.nu) '_n0_' num2str(params.n0) '_repeats_' num2str(nRepeats)];
if(params.isneutral==true)
    outfile = [outfile '_neutral.mat'];
else
    outfile = [outfile '.mat'];
end

disp(['Will write file ' outfile]);

remapped_vals = NaN*zeros(nRepeats,length(c0s),params.p);
for cc=1:length(c0s)
    c0=c0s(cc);
    disp('---------------------------------------------');
    disp(['c0 ' num2str(c0)]);
    disp('---------------------------------------------');
    for nt=1:nRepeats
        if(mod(nt,10)==0)
            disp(['--Done ' num2str(nt-1)]);
            %         do_save(nt-1,supply_vecs,c0s,remapped_vals,outfile,params);
        end        
        % Run simulation
        remapped_vec = FindRemapped(params.n0,params,c0,supply_vecs);
        remapped_vals(nt,cc,:) = remapped_vec;
    end

   if(nRepeats>0)
       disp(['Done c0 ' num2str(c0)]);
       disp('------------------------------');
       do_save(nt,supply_vecs,c0s,remapped_vals,outfile,params);
   end
end

function do_save(nt,supply_vecs,c0s,remapped_vals,outfile,params)
    supply = supply_vecs(:,1);
    nc0s = length(c0s);
    remapped_hist = zeros(length(supply),nc0s);
    centers = supply_vecs(:,1)';
    d = diff(centers)/2;
    edges = [centers(1)-d(1), centers(1:end-1)+d, centers(end)+d(end)];
    for cc=1:nc0s
        remapped_hist(:,cc) = histcounts(remapped_vals(1:nt,cc,1),edges);
    end
    disp(['Saving ' outfile]);
    save(outfile,'params','remapped_vals','remapped_hist','c0s','supply');

    
                              
                              
