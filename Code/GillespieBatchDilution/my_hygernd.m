function n_sigma = my_hygernd(n_sigmas_before,N)
s = sum(n_sigmas_before);
all_species = zeros(s,1);
% Order species
cnt = 1;
for sigma=1:length(n_sigmas_before)
    n_sigma = n_sigmas_before(sigma);
    if(n_sigma>0)
        all_species(cnt:(cnt+n_sigma-1)) = sigma;
    end
    cnt = cnt+n_sigma;
end

rp = randperm(s);

all_species = all_species(rp(1:N));
n_sigma = zeros(size(n_sigmas_before));
for nn=1:N
    n_sigma(all_species(nn)) = n_sigma(all_species(nn))+1;
end

