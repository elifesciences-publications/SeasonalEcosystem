%Script for processing remapping vs. strategy data 

%%%Uncomment to reimport data%%%

% files = dir('remappings_*.mat');
% nfiles = length(files);
% remappings = zeros(nfiles,501);
% c0list = logspace(-4,4,200);
% for w = 1:nfiles
%     load(files(w).name);
%     remappings(find(abs(c0list-Ct)<1e-10),:) = NumericCi;
%     %remappings(w,:) = NumericCi;
%     %c0list(w) = Ct;
% end
% remappings(:,end) = 1;  
% save('aggregated_remappings_vs_strategy.mat')

load('Data/deterministic/aggregated_remappings_vs_strategy.mat')


%%%Plotting in a line graph%%%

%c0list = c0list(5:5:end);
%remappings = remappings(5:5:end,:);
% figure 
% hold on
% colormp = cool(300);
% for i = 1:length(c0list)
%     color = colormp(floor((log10(c0list(i))+4)/8*299)+1,:);
%     plot(transpose(s),abs(transpose(s) - remappings(i,:)),'Color',color)
% end
% %set(gca,'XScale','log')
% %set(gca,'YScale','log')
% xlabel('Strategy')
% ylabel('Degree of remapping')
% xlim([0,max(s)])
% h = colorbar('TickLabels',{'10^{-4}','10^{4}'},'Ticks',[0,1]);
% colormap(cool)
% ylabel(h,'$c_{0}/K$','interpreter','latex','rotation',0)

%%%Heatmap plot%%%
newfigure(3.42/2,3.42/2/1.3);
colormap(hot(256));
set(gca,'FontSize', 9);


h = imagesc(transpose(abs(remappings-repmat(transpose(s),200,1))));
grid off
set(gca,'FontSize', 9);
yl = ylabel({'Strategy' '$\alpha_{\sigma,1}$'},'interpreter','latex');
yl.Position = [-2 250 1];

xl = xlabel('Bolus size $c_{0}/K$','interpreter','latex');
xl.Position = [100  660 1];
set(gca,'XTick',[1,100,200])
set(gca,'XTickLabels',{'10^{-4}','10^0','10^4'})
set(gca,'YTick',[1,500])
set(gca,'YTickLabels',{'1','0'})

set(gca,'Position', [0.25, 0.32,0.64, 0.61]);
c = colorbar('TickLabels',{'$0$' '$0.5$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
c.Location = 'East';
c.Position = [0.85, 0.4, 0.1, 0.4];
c.Ticks=[];
%     c.Ticks = [0,1];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
% c.TickLabels = c.Ticks*0.01;
%     c.TickLabels = c.Ticks*10;
% c.Label.Position = [0.75, 0.4, 0.1, 0.4];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;
% tx = text(-75,-10,'B', 'FontSize', 11, 'Interpreter', 'Latex');

tx2 = text(170,406, 'Remap', 'Interpreter', 'latex',...
    'Rotation', 90, 'Color', 'w');

print(gcf,'-dpng', 'remappings_vs_strategy.png', '-r600');
print(gcf,'-depsc2', 'remappings_vs_strategy.eps');
