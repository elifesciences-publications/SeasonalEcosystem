%This script generates figure 1bc of Lopez et al. 

fig3 = newfigure(3.42,3.42/3);

[fig1ax,pos] = tight_subplot(1,2,0.01,0.03,0.03);
addpath('alchemyst-ternplot');

P = [0.20 0.8];
s = transpose(linspace(0,1,4));
axes(fig1ax(1));
dotplotx = 0.53;
diamondplotx = 0.5;
plot(linspace(0,1,100),repmat(0.5,100),'-','LineWidth',2,...
    'Color','k')
hold on
m = length(s);
colors = jet(4);
for i = 1:m
    plot([s(i), s(i)],[0.5,dotplotx],'k-')
    plot(s(i),dotplotx,'o','MarkerFaceColor',colors(i,:), 'MarkerEdgeColor','k','MarkerSize',4)
end
plot([P(1), P(1)],[diamondplotx,diamondplotx+0.1],'k-', 'LineWidth', 1)
plot(P(1),diamondplotx+0.1,'d','MarkerFaceColor','k', 'MarkerEdgeColor','k','MarkerSize',4);
xlim([0, 1]);
ylim([0.3,0.7]);
text(0,0.3 + 0.4*0.85,'\textbf{B}','FontSize',11,'Interpreter','latex');
axis off

axes(fig1ax(2))
ternplot(1,1,1,'majors',0)
hold on
x = xlim;
text(0.1,x(2)*0.85,'\textbf{C}','FontSize',11,'Interpreter','latex');
ternplot(0.1, 0.1, 0.8,'d','MarkerFaceColor','k', 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(0, 0, 1,'o','MarkerFaceColor',colors(1,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(0.2, 0.3, 0.5,'o','MarkerFaceColor',colors(2,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(0.1, 0.7, 0.2,'o','MarkerFaceColor',colors(3,:), 'MarkerEdgeColor','k','MarkerSize',4)
ternplot(1, 0, 0,'o','MarkerFaceColor',colors(4,:), 'MarkerEdgeColor','k','MarkerSize',4)

saveas(gcf,'Fig1bc','epsc')
print(gcf, '-dpng', 'Fig1bc.png', '-r600')
