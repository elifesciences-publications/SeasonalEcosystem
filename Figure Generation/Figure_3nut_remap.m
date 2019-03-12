% Plot the remapped strategies in 3 nutrients, both stochastic and deterministic

addpath('alchemyst-ternplot');
newfigure(3.42/2,3.42/3);
ternplot(1,1,1,'majors',0)
hold on
x = xlim;

determ = load('3d_remapping.mat');


colors = jet(4);

ternplot(determ.s1(1), determ.s1(2), determ.s1(3),'o','MarkerFaceColor',colors(1,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(determ.s2(1), determ.s2(2), determ.s2(3),'o','MarkerFaceColor',colors(2,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(determ.s3(1), determ.s3(2), determ.s3(3),'o','MarkerFaceColor',colors(4,:), 'MarkerEdgeColor','k','MarkerSize',4)

% Convext hull for strategies:
ternplot([determ.s1(1) determ.s2(1)],[determ.s1(2) determ.s2(2)],[determ.s1(3) determ.s2(3)],'-k')
ternplot([determ.s2(1) determ.s3(1)],[determ.s2(2) determ.s3(2)],[determ.s2(3) determ.s3(3)],'-k')
ternplot([determ.s3(1) determ.s1(1)],[determ.s3(2) determ.s1(2)],[determ.s3(3) determ.s1(3)],'-k')

% Remapped nodes:
ternplot(determ.s1remap(1), determ.s1remap(2), determ.s1remap(3),'o','MarkerFaceColor',colors(1,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(determ.s2remap(1), determ.s2remap(2), determ.s2remap(3),'o','MarkerFaceColor',colors(2,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(determ.s3remap(1), determ.s3remap(2), determ.s3remap(3),'o','MarkerFaceColor',colors(4,:), 'MarkerEdgeColor','k','MarkerSize',4)

% "convext hull" for remapped nodes:
ternplot([determ.s1remap(1) determ.s2remap(1)],[determ.s1remap(2) determ.s2remap(2)],[determ.s1remap(3) determ.s2remap(3)],':k')
ternplot([determ.s2remap(1) determ.s3remap(1)],[determ.s2remap(2) determ.s3remap(2)],[determ.s2remap(3) determ.s3remap(3)],':k')
ternplot([determ.s3remap(1) determ.s1remap(1)],[determ.s3remap(2) determ.s1remap(2)],[determ.s3remap(3) determ.s1remap(3)],':k')


stoch = load('stoch_remapped_3nutrient.mat');
stoch1 = stoch.remapped_strategies{1};
stoch2 = stoch.remapped_strategies{2};
stoch3 = stoch.remapped_strategies{3};

ternplot(stoch1(1), stoch1(2), stoch1(3),'x','MarkerFaceColor','w', 'MarkerEdgeColor','w','MarkerSize',4)
ternplot(stoch2(1), stoch2(2), stoch2(3),'x','MarkerFaceColor','w', 'MarkerEdgeColor','w','MarkerSize',4)
ternplot(stoch3(1), stoch3(2), stoch3(3),'x','MarkerFaceColor','w', 'MarkerEdgeColor','w','MarkerSize',4)


set(gca,'FontSize',9);
print(gcf,'-depsc2','remap_3nut.eps');
print(gcf,'-dpng','remap_3nut.png','-r600');
