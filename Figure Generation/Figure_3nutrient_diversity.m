%Script for processing 3d diversity sweep data
clear;clc

%%Uncomment to reaggregate data
% files = dir('3d_sweep_n0_0.001*.mat');
% nfiles = length(files);
% divsweep = zeros(6,nfiles);
% c0list = logspace(-4,4,200);
% for w = 1:nfiles
%     load(files(w).name);
%     divsweep(:,find(abs(c0list-c0)<1e-10)) = D(:,1);
% end
% save('3d_diversity_sweep.mat')

load('Data/deterministic/3d_diversity_sweep.mat')


newfigure(3.42/2, 3.42/1.3/2);
set(gca,'FontSize',9);
hold on
colors = cool(33); 
for i = 1:length(divsweep(:,1))
    loglog(c0list,2.^divsweep(i,:),'color',colors(floor(P(1,i)*100),:), 'LineWidth', 1)
end
plot(c0list, 55*ones(size(c0list)), '--k', 'LineWidth',2 );
ylim([1,100]);
yticks([1,4,16,64]);
xlim(10.^[-4,4]);
xticks(10.^[-4,0,4]);
set(gca,'XScale','log')
set(gca,'YScale','log')
xlabel('Bolus size $c_0/K$','Interpreter','latex', 'FontSize', 9);
ylabel('Eff. species $m_e$','Interpreter','latex', 'FontSize', 9);

%%Uncomment for chemostat diversity comparisons for all nutrient ratios
% for i = 1:6
% semilogx([1e-4,1e4],[chemD(i),chemD(i)],'k--') 
% end
%legend('0.05','0.1','0.15','0.2','0.25','0.3333')

% colormap(cool)
% c = colorbar;
% c.Ticks = [0,1];
% c.TickLabels = {'0','1/3'};
% c.Label.String = 'Nutrient Frac 1,2';

% Pretty colorbar
colormap(cool);
c = colorbar('TickLabels',{'$0$' '$1/3$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
c.Location = 'North';

c.Position = [0.33812      0.88694      0.46597      0.09681];
% c.Position(1) = 0.33;
% c.Position(2) = 0.9;

c.Ticks=[];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
c.Label.String = 'Nutrients 1,2';
c.Label.Interpreter = 'Latex';
c.Label.Position = [0.5,1,0];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;
text(10^(-3.5),100,'$0$', 'Interpreter','Latex');
text(10^(3.4),100,'$\frac{1}{3}$', 'Interpreter','Latex');

% tB = text(3.75e-7, 115,'B','FontSize', 11,'Interpreter', 'Latex');

print(gcf,'-depsc2', 'diversity_3nutrient.eps');
print(gcf,'-dpng', 'diversity_3nutrient.png', '-r600');
