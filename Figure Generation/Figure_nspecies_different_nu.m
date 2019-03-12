% Plots stochstic simulation results for multiple nu 

% Uniform
collected_dir = 'Data/collected_stoch_nus';
% nameprefix = 'S_0.005_stoch_K_1000_N0_1008_n0_uniform21_m_201_alpha_uniform';
nameprefix = 'S_0.05_stoch_K_1000_N0_1008_n0_uniform21_m_201_alpha_uniform';

% N0s = 1008;
load([collected_dir filesep 'collected_' nameprefix '.mat']);
all_collected = {collected};
bigtable = all_collected{1}.tab;
bigtable = bigtable(bigtable.nu <= 0.01,:);
% # species vs c0
fig = newfigure(3.42/2, 3.42/1.3/2);

% nSpecies vs c0
nus = unique(bigtable.nu);
N0s = unique(bigtable.N0);

for NN=1:length(N0s)
%     newfigure(6,4);
    numap = colormap(gca, copper(length(nus)));
    N0tab = bigtable(bigtable.N0==N0s(NN),:);
    
    for nn=1:length(nus)
        subtab = N0tab(N0tab.nu==nus(nn),:);
        if(subtab.c0(end)==100000)
            subtab.median_nspecies(end) = NaN;
        end
        loglog(subtab.c0./subtab.kc,subtab.median_nspecies,'.-','LineWidth',1,'Color',numap(nn,:),'DisplayName',['\nu=' num2str(nus(nn))]);
        hold on
    end
    yticks([1,10,100]);
    ylim([1,201]);
    xlim(10.^[-3,3]);
    xticks(10.^[-3,0,3]);
    set(gca,'FontSize',9);
    xl = xlabel('Bolus size $c_0/K$','Interpreter','latex');
    yl = ylabel('\# Species', 'Interpreter', 'Latex');
    colormap(copper(length(nus)));
    c = colorbar('location','North');
    c.Position = [0.35      0.78925        0.39868      0.10974];
    text(10^(-2.7), 100,'$0$', 'Interpreter', 'Latex');
    text(10^(1.6), 100,'$0.01$', 'Interpreter', 'Latex');
    
    c.Ticks=[];
    c.AxisLocationMode='manual';
    c.AxisLocation = 'in';
    c.TickLabels = c.Ticks*0.01;
    c.Label.String = '\nu';
    c.Label.Position = [0.2,1.5,0];
    c.Label.Rotation = 0;
    c.Label.Color='w';
    c.Label.FontSize = 12;
    box on
    figfile = 'nspecies_different_nu';
    print(gcf,'-dpng',[figfile '.png'],'-r600');
    print(gcf,'-depsc2',[figfile '.eps']);
end

