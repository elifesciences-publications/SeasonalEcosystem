%% FigA

load('Data/deterministic/SuppBitrophic_A.mat')

fig=newfigure(2*3.42, 3.42/1.3);
subplot(1,2,1);

set(gca,'FontSize',9);
hold on

cmap = colormap(copper(length(Cts)));

for cc=1:length(Cts)
    plot(bstores{cc}(1,:), 'Color', cmap(cc,:), 'DisplayName', ['$c_0/K=$', num2str(Cts(cc)*2), '$, c_0/\rho_0=$', num2str(2*Cts(cc)/Bts(cc))]);
    l = plot(bstores{cc}(2,:), 'Color', cmap(cc,:));
    set(get(get(l,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
end
xlim([1,9]);
xticks([1,5,9]);
l = legend('show');
l.Interpreter = 'Latex';
xlabel('Batch \#', 'Interpreter', 'Latex');
ylabel('$\rho_\sigma$', 'Interpreter', 'Latex');
text(1.4,0.67,'A','FontSize',11, 'Interpreter', 'Latex');

%% FigB

load('Data/deterministic/SuppBitrophic_B.mat')

subplot(1,2,2);
set(gca,'FontSize',9);
hold on

cmap = colormap(copper(length(Cts)));

for cc=1:length(Cts)
    plot(bstores{cc}(1,:), 'Color', cmap(cc,:), 'DisplayName', ['$c_0/K=$', num2str(Cts(cc)*2), '$, c_0/\rho_0=$', num2str(2*Cts(cc)/Bts(cc))]);
    l = plot(bstores{cc}(2,:), 'Color', cmap(cc,:));
    set(get(get(l,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
end
xlim([1,9]);
xticks([1,5,9]);
l = legend('show');
l.Interpreter = 'Latex';
xlabel('Batch \#', 'Interpreter', 'Latex');
text(1.4,0.67,'B','FontSize',11, 'Interpreter', 'Latex');

print(gcf,'-dpng', 'SuppBitrophic2Species.png', '-r600');
