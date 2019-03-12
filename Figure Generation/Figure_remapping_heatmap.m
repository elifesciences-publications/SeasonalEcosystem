%Script for aggregating the results of the heatmap computation

rho0list = logspace(-4,4,200); %Range for rho0
c0list = rho0list; %Range for c0

%%% Uncomment to re-aggregate data %%%
% heatmap_remappings = zeros(200,21,200);
% files = dir('*.mat');
% for w = 1:200
%     load(files(w).name);
%     heatmap_remappings(find(abs(rho0list-rho0)<1e-10),:,:) = NumericCi;
% end

%%% Import aggregated data %%%
load('Data/deterministic/aggregated_remappings.mat')

i = 5;
newfigure(3.42/2,3.42/2/1.3);
cm = colormap(hot(256));
% cm = cm.*repmat(sum(cm,2).*(5*exp(-[1:length(cm)]'/length(cm)*10)+1),1,3);
% cm = cm./repmat(sum(cm,2),1,3)*3;
% cm(cm>1) = 1;
colormap(cm);

h = imagesc(flip(squeeze(heatmap_remappings(:,i,:)-s(i))));
% h = imagesc(log10(flip(squeeze(heatmap_remappings(:,i,:)-s(i)))));
set(gca,'FontSize', 9);
grid off
yl = ylabel({'Inoculum', 'size $\rho_0/K$'},'interpreter','latex');
yl.Position(1) = -1;
xlabel('Bolus size $c_0/K$','interpreter','latex');
set(gca,'XTick',[1,100.5,200]);
set(gca,'XTickLabels',{'10^{-4}','10^0','10^4'});
set(gca,'YTick',[1,200]);
set(gca,'YTickLabels',{'10^{4}','10^{-4}'});
% set(gca,'YTickLabels',[]);


set(gca,'Position', [0.25, 0.32, 0.64, 0.61]);
c = colorbar('TickLabels',{'$0$' '$0.5$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
% c.Location = 'North';
% c.Position(1) = 0.3;
% c.Position(2) = 0.9;
c.Location = 'East';
c.Position = [0.85, 0.419, 0.1, 0.4];
c.Ticks=[];
%     c.Ticks = [0,1];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
% c.TickLabels = c.Ticks*0.01;
%     c.TickLabels = c.Ticks*10;
% c.Label.String = 'Nutrient ratio';
% c.Label.Position = [0.5,1.5,0];
% c.Label.Rotation = 0;
% c.Label.Color='w';
% c.Label.FontSize = 9;
tx = text(-75,-3,'B','FontSize', 11, 'Interpreter', 'Latex');
tx2 = text(170,152, 'Remap', 'Interpreter', 'latex',...
    'Rotation', 90, 'Color', 'w');

tx3 = text(181, 186, '$0$', 'Interpreter', 'latex',...
           'Color', 'w');

tx4 = text(162, 21, '$0.2$', 'Interpreter', 'latex',...
           'Color', 'w');

print(gcf,'-dpng', 'remapping_heatmap.png', '-r600');
print(gcf,'-depsc2', 'remapping_heatmap.eps');
