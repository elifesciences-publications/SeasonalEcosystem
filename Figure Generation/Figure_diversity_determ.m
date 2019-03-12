%% m_e (2^entropy) vs c0
% remap = load('Data/deterministic/n0_div_K=1e-3_remapping_and_diversity.mat');
remap = load('Data/deterministic/2d_diversity_sweep.mat');
D = remap.D;
P = remap.Plist;
rho0=remap.n0;
K=remap.K;
nSpecies=remap.m;
Ct = remap.diversity_c0_index;

colors = cool(105);
newfigure(3.42/2,3.42/2/1.3);

for i = 1:size(D,1)
    plot(Ct,2.^(D(i,:)), 'LineWidth', 1, 'Color', colors(P(i)*200,:)) 
    hold on
end
set(gca,'FontSize',9);
plot(Ct,nSpecies*ones(size(Ct)),'--k', 'LineWidth',2);
set(gca,'XScale','log');
set(gca,'YScale','log');
xlim(10.^[-4,4]);
ylim(2.^[0,5]);
yticks(2.^[0:1:6]);
xticks(10.^[-4:4:4]);

yl = ylabel('Eff. species $m_{e}$','Interpreter','latex');%,'Interpreter','latex')
xl = xlabel('Bolus size $c_0/K$','Interpreter','Latex');


colormap(colors);
c = colorbar('TickLabels',{'$0$' '$0.5$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
c.Location = 'North';
c.Position = [0.33812      0.88694      0.46597      0.09681];
% c.Position(1) = 0.33;
% c.Position(2) = 0.9;
c.Ticks=[];
%     c.Ticks = [0,1];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
% c.TickLabels = c.Ticks*0.01;
%     c.TickLabels = c.Ticks*10;
c.Label.String = 'Nutrient 1';
c.Label.Interpreter = 'Latex';
c.Label.Position = [0.5,1,0];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;
text(10^(-3.7),36,'$0$', 'Interpreter','Latex');
text(10^(3.1),36,'$\frac{1}{2}$', 'Interpreter','Latex');
text(10^(-7.1),39,'C', 'FontSize', 11, 'Interpreter', 'Latex');
set(gca,'Position',[0.25      0.3      0.65      0.61]);
box off
% vec = get(fig3ax(1),'position');
% set(fig3ax(1), 'position', [vec(1)*1.6, vec(2), vec(3)*1.7, vec(4)] );
% 
% vec = get(fig3ax(2),'position');
% set(fig3ax(2), 'position', [vec(1)*1.15, vec(2), vec(3)/2, vec(4)] );

print(gcf,['Fig_diversity_determ.png'],'-dpng','-r600');
print(gcf,['Fig_diversity_determ.eps'],'-depsc2');

