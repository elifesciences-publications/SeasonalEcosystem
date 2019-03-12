%Generates figure 3a


% remap = load('Data/deterministic/n0_div_K=1e-3_remapping_and_diversity.mat');
remap = load('Data/deterministic/remappings_n0_0.001_m_21_c0_-4-4_num_100.mat');
NumericCi = squeeze(remap.NumericCi);
n0=remap.n0;
K=remap.K;
Ct = remap.Ct/K;

fig3a = newfigure(3.42/2, 3.42/1.3/2);

% [fig3ax,pos] = tight_subplot(1,2,0.01,0.01,0.01);

%Plot inward remapping
% axes(fig3ax(1));
axes('Position',[0.25    0.3      0.65      0.61]);
% axes('Position',[0.25/2+0.015    0.3      0.65/2      0.61]);

n1 = length(NumericCi(:,1));
colors = jet(n1);

for i = 1:n1-1
    semilogx(Ct,NumericCi(i,:),'Color',colors(i+1,:),'LineWidth',1)
    hold on
end
semilogx(Ct,zeros(size(Ct)),'Color',colors(1,:),'LineWidth',1)
semilogx(Ct,zeros(size(Ct))+1,'Color',colors(n1,:),'LineWidth',1)
set(gca,'FontSize',9);
ylabel('Remapping','Interpreter','latex');
% xlim([min(Ct),max(Ct)])
xlim(10.^[-4,4]);
% yticks([0.5]);
xticks(10.^[-4:4:4]);
% xticks([]);
yticks([0,1]);
xlabel('Bolus size $c_0/K$','Interpreter','latex')
% xticks([]);
% title(['$N_0/K=' num2str(n0/K,3) '$'],'Interpreter','Latex');
% set(gca,'Position',[0.25      0.3      0.65      0.61]);
% set(gca,'Position',[0.25/.6*.5      0.3      0.65/.6*.5      0.61]);

text(10^(-6.6),1.06,'A', 'FontSize', 11, 'Interpreter', 'Latex');

print(gcf,['Fig3a.png'],'-dpng','-r600');
print(gcf,['Fig3a.eps'],'-depsc2');

