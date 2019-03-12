% Plots stochastic remapping

all_files = glob('Data/remap_2_nutrient/remap*.mat');
all_data = cell(length(all_files),1);
for ff=1:length(all_files)
    all_data{ff} = load(all_files{ff});
end

general_params = all_data{ff}.params;
tot_image = zeros(size(all_data{1}.remapped_hist));
for ff=1:length(all_files)
    val = all_data{ff}.remapped_hist;
    for ii=1:size(val,2)
        val(:,ii) = val(:,ii)/max(val(:,ii));
    end
    tot_image = tot_image+val;
end
newfigure(3.42/2, 3.42/1.3/2);
set(gca,'FontSize', 9);
set(gca, 'Position',[0.25    0.3      0.65      0.61]);
imagesc(log10(all_data{ff}.c0s/general_params.kc), all_data{ff}.supply, tot_image);
set(gca,'YDir', 'Normal');
cm = colormap(bone(256));
colormap(1-cm);
hold on

% Fancy colorbar
c = colorbar('TickLabels',{'$0$' '$0.5$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
c.Location = 'North';
c.Position(1) = 0.33;
c.Position(2) = 0.9;
c.Ticks=[];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
c.Label.String = 'Freq.';
c.Label.Interpreter = 'Latex';
c.Label.Position = [1.5,1.1,0];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;
box off


% Overlay deterministic results
remap = load('Data/deterministic/remappings_n0_0.001_m_21_c0_-4-4_num_100.mat');
remap.NumericCi = squeeze(remap.NumericCi);
colors = jet(size(remap.NumericCi,1));

for ff=1:length(all_files)
   fn = find(remap.s==all_data{ff}.params.Strategies(1,1));
   plot(log10(remap.Ct/remap.K), remap.NumericCi(fn,:),'-','Color', colors(fn+1,:), 'LineWidth',1)
end

set(gca,'FontSize', 9);
xticks([-3,0,3]);
xticklabels({'10^{-3}' '10^0', '10^{3}'});
xl = xlabel('Bolus size $c_0/K$', 'Interpreter', 'Latex');
xl.Position(2) = -0.29;
xlim([-3,3]);
yticks([0,1]);
ylim([0,1]);
ylabel('Remapping', 'Interpreter', 'Latex');
text(-5.3,1.0,'A', 'FontSize', 11, 'Interpreter', 'Latex');

print(gcf,'-dpng','Fig_stochremap.png', '-r600');
print(gcf,'-depsc2','Fig_stochremap.eps');