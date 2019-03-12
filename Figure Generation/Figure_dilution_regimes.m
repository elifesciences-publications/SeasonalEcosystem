datadir = 'Data/DilutionRegimes/';

load([datadir 'params.mat']);

files = { ...
{ [datadir 'out_K_1000_c0_100_S1_0.05_nu_0_N0_1008_dilutions_10000.mat']
[datadir 'out_K_1000_c0_1000_S1_0.05_nu_0_N0_1008_dilutions_10000.mat']
[datadir 'out_K_1000_c0_10000_S1_0.05_nu_0_N0_1008_dilutions_10000.mat'] },...
{ [datadir 'out_K_1000_c0_100_S1_0.05_nu_0_N0_1008_dilutions_10000_spike_0.05.mat']
[datadir 'out_K_1000_c0_1000_S1_0.05_nu_0_N0_1008_dilutions_10000_spike_0.05.mat']
[datadir 'out_K_1000_c0_10000_S1_0.05_nu_0_N0_1008_dilutions_10000_spike_0.05.mat']}...
{ [datadir 'out_K_1000_c0_100_S1_0.05_nu_0.005_N0_1008_dilutions_10000.mat']
[datadir 'out_K_1000_c0_1000_S1_0.05_nu_0.005_N0_1008_dilutions_10000.mat']
[datadir 'out_K_1000_c0_10000_S1_0.05_nu_0.005_N0_1008_dilutions_10000.mat']
}};

toptext = {'$\nu=0$, no spike', '$\nu=0$, spike 0.05', '$\nu=0.005$, no spike'};

c0=[100,1000,10000];
fig = newfigure(6,8);
[ha,pos] = tight_subplot(4,3,0.01,0.12,0.12);

% \rho_sigma(dilution) trajectories

for ii=1:3
    for ff=1:3
        load(files{ii}{ff});
        smap = colormap(jet(size(params.Strategies,1)));
        axes(ha(ii+(ff-1)*3));
        set(gca,'FontSize',11);
        for ss=1:size(DilutionEnds.nbegins,2)
            loglog(DilutionEnds.nbegins(:,ss),'-', 'Color', smap(ss,:),'LineWidth',1)
            hold on
        end
        if(ii==1)
            ylabel(['$\rho_\sigma$'], 'Interpreter','Latex');
            yticks(10.^[0,1,2]); 
            t = text(0.018, 10^2.6,[{'$c_0/K$', ['=' num2str(c0(ff)/params.kc)]}], 'Interpreter', 'Latex',...
                'EdgeColor','k');
        else
            yticks([]);
        end
        xticks([]);
        
        ylim([1,1100]);
        
        if(ff==1)
            text(5, 10^3.4,toptext{ii}, 'Interpreter', 'Latex','EdgeColor','k');
        end
    end
end

%
c = colorbar();
c.Position = [0.9, 0.17, 0.03, 0.65];
c.Label.String = {'Strategy' '$\alpha_{\sigma,1}$'};
c.Label.Interpreter = 'latex';
c.Label.Rotation = 0;
c.Label.Position = [1.2, 1.1];

% ---------------------------------------------
% nspecies summary
syms = {'.-', '-', '-'};

for ii=1:3
    for cc=1:length(c0)
        load(files{ii}{cc});
        axes(ha(9+ii));
        set(gca,'FontSize',11);
        vals = sum(DilutionEnds.nbegins>0,2);
        vals = movmean(vals,21);
        semilogx(vals, syms{cc},...
            'LineWidth',1, ...
            'DisplayName', ['$c_0/K=' num2str(c0(cc)/params.kc,2) '$']);
        hold on
    end
    if(ii==1)
        ylabel('\# Species','Interpreter','Latex');
        yticks([0:10:30]);
        l = legend('Show');
        l.Interpreter = 'Latex';
        l.Position(2) = 0.227;
    else
        yticks([]);
    end
    ylim([0,40]);
    xticks([10,1000]);
    xlabel('Batch','Interpreter','Latex');
end

print(gcf,'-dpng','SupplDilutionRegimes.png','-r600');
print(gcf,'-depsc2','SupplDilutionRegimes.eps');