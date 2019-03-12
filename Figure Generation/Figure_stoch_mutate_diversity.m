% Plots stochstic simulation diversity for Fig.5 in the manuscript

collected_dir = 'Data/collected_stoch_nus';

nameprefix = 'S_many_stoch_K_1000_N0_1008_nu_0.01_n0_uniform21_m_201_alpha_uniform';
figprefix = 'N0_1008_';

% nameprefix = 'S_many_stoch_K_100000_N0_100002_nu_0.001_n0_uniform21_m_201_alpha_uniform';
% figprefix = 'N0_100002_';

load([collected_dir filesep 'collected_' nameprefix '.mat']);
all_collected = {collected};
bigtable = all_collected{1}.tab;
bigtable = bigtable(bigtable.nu <= 0.01,:);
% bigtable = bigtable(bigtable.nu <= 0.001,:);
%% # species vs c0
fig = newfigure(3.42/2, 3.42/1.3/2);

% nSpecies vs c0

nus = unique(bigtable.nu);
N0s = unique(bigtable.N0);
S1s = unique(bigtable.S1);
Smap = colormap(cool(105));

for NN=1:length(N0s)
%     numap = colormap(gca, copper(length(nus)));
    N0tab = bigtable(bigtable.N0==N0s(NN),:);
    
    for ss=1:length(S1s)
        subtab = N0tab(N0tab.S1==S1s(ss),:);
        if(subtab.c0(end)==100000)
            subtab.median_nspecies(end) = NaN;
        end
        loglog(subtab.c0./subtab.kc,subtab.median_nspecies,'.-','LineWidth',1,'Color',Smap(1+floor(S1s(ss)*200),:),'DisplayName',['S_1' num2str(S1s(ss))]);
        hold on
    end
    yticks([1,100]);
    ylim([1,max(bigtable.m)]);
%     xlim(10.^[-3,3]);
    xlim([0.025, 10^3]);
    xticks(10.^[-3,0,3]);
    set(gca,'FontSize',9);
    xl = xlabel('Bolus size $c_0/K$','Interpreter','latex');
    yl = ylabel('\# Species', 'Interpreter', 'Latex');
end

figfile = 'StochMut_nspecies';
print(gcf,'-dpng',[figprefix figfile '.png'],'-r600');
print(gcf,'-depsc2',[figprefix figfile '.eps']);


%% Rank-abundance

N0s = unique(bigtable.N0);
% nus = unique(bigtable.nu);
NN=1;
nus = 0.01;

% fig = newfigure(3.42/2, 3.42/1.3/2);
fig = newfigure(3.42, 3.42/1.3/2);
subplot(1,2,2);

% S1s = [0.05, 0.5];
S1s = unique(bigtable.S1);
linestyles = {'-','-'};
markers = '..';
widths = [0.5,2];
Smap = colormap(cool(105));


for ss=[1, length(S1s)]
    subtab = bigtable(bigtable.S1==S1s(ss),:);    
  
%     c0s = [100, 1585, 39811];
%     c0s = [10, 100000];
    c0s = [100, 10000];
    cmap = colormap(gca, lines(length(c0s)));
    mx = 0;
    for cc=1:length(c0s)
        %             ind = subtab.Index(subtab.c0==c0s(cc));
        f = find(subtab.c0>=c0s(cc),1);
        ind = subtab.Index(f);
        val = all_collected{NN}.distributions.RankAbundance{ind};
        val = val / N0s(NN);
        if(isempty(val)), continue; end
        if(max(val)>mx), mx = max(val); end
        xx = 1:length(val);
        fn = find(val(xx));
        xx = xx(fn);
        p1 = loglog(xx, val(xx),'Color',Smap(1+floor(S1s(ss)*200),:),...
            'LineStyle', linestyles{cc}, 'LineWidth',widths(cc), ...%'MarkerFaceColor', Smap(1+floor(S1s(ss)*200),:),...
            'DisplayName', ['$c_0/K=' num2str(subtab.c0(f)/subtab.kc(f)) '$']);
        hold on
   
        if(ss==1)
           set(get(get(p1,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off') 
        end
    end
    set(gca,'FontSize',9);
    xlim([1,max(bigtable.m)]);
    xl = xlabel('Rank', 'Interpreter', 'Latex','FontSize',9);
%     xl.Position(2) = 0.000469;
    xticks([1 100]);
    
    ylim(10.^[-3.02,1]);
    yl = ylabel('Abundance', 'Interpreter', 'Latex','FontSize',9);
    yticks(10.^[-3,0]);
end
box off
l = legend('show','Location','northeast');
l.Position = [0.4472 0.5467 0.6859 0.4775];
l.Interpreter = 'Latex';
set(l.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[0;0;0;0]));
l.Box = 'off';
l = line(10.^[0.28,1.21], 10.^[1, 1], 'LineWidth', 0.5, 'Color', Smap(1+floor(S1s(1)*200),:));
set(get(get(l,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off') 
l = line(10.^[0.28,1.21], 10.^[-0.3, -0.3], 'LineWidth', 2, 'Color', Smap(1+floor(S1s(1)*200),:));
set(get(get(l,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off') 


tB = text(0.055,11.3,'B','FontSize',11, 'Interpreter', 'Latex');

print(gcf,'-dpng', 'Fig5_composite.png', '-r600');
print(gcf,'-depsc2', 'Fig5_composite.eps', '-r600');


%% m_eff vs. c0

nus = unique(bigtable.nu);
N0s = unique(bigtable.N0);
S1s = unique(bigtable.S1);

% fig = newfigure(3.42/2, 3.42/1.3/2);
subplot(1,2,1);
% hold on

Smap = colormap(cool(105));

for ss=1:length(S1s)
    subtab = bigtable(bigtable.S1==S1s(ss),:);
    loglog(subtab.c0./subtab.kc, 2.^subtab.median_S,'-','LineWidth',1,'Color',Smap(1+floor(S1s(ss)*200),:),'DisplayName',['S_1=' num2str(S1s(ss))]);    
    hold on
end
set(gca,'FontSize',9);

xl=xlabel('Bolus size $c_0/K$','Interpreter','Latex','FontSize',9);
xlim([0.025, 10^3]);
xticks(10.^[-3,0,3]);

yl = ylabel('Eff. species $m_{e}$','Interpreter','latex','FontSize',9);
ylim(10.^[0,2.2]);
c = colorbar('location','North');
c.Position = [0.22005       0.8975      0.19012     0.084081];
t0 = text(0.05, 170,'$0$', 'Interpreter', 'Latex');
text(10^(2.4), 170,'$\frac{1}{2}$', 'Interpreter', 'Latex');
c.Ticks=[];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
c.Label.String = 'Nutrient 1';
c.Label.Position = [0.5,1.1,0];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;
c.Label.Interpreter = 'Latex';
box off
tA = text(1e-04,178,'A','FontSize',11, 'Interpreter', 'Latex');


print(gcf,'-dpng', 'Fig5_composite.png', '-r600');
print(gcf,'-depsc2', 'Fig5_composite.eps', '-r600');