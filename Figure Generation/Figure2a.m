fig2a = newfigure(3.42,3.42/(1.4*3));
[fig2ax,pos] = tight_subplot(1,1,0.01,0.03,0.03);

%Set up params
s1 = 0.2;
s1remap = 0.3;
s2 = 0.8;
s2remap = 0.7;

diamondplotx = 0.5;
rectheight = 0.2; 
transp = 0.5;
lines = [0,0.5,1];
dotplotx = lines + 0.1;
loffset = 0.08;
toffset = 0.025;

h_angle = 70;
h_den = 60;
h_back = [1 1 1];


%Plot simplex lines
plot(linspace(0,1,100),repmat(lines(1),100),'-','LineWidth',2,...
    'Color','k')
hold on
plot(linspace(0,1,100),repmat(lines(2),100),'-','LineWidth',2,...
    'Color','k')
plot(linspace(0,1,100),repmat(lines(3),100),'-','LineWidth',2,...
    'Color','k')

%Plot simplex 1 
plot([s2, s2],[lines(3),dotplotx(3)],'k-')
plot(s2,dotplotx(3),'o','MarkerFaceColor','r', 'MarkerEdgeColor',...
    'k','MarkerSize',4)
blue_inv = patch([s2remap 0 0 s2remap],[lines(3) - rectheight/2, ...
    lines(3) - rectheight/2, lines(3)+rectheight/2,...
    lines(3)+rectheight/2],'k');
hatchfill2(blue_inv,'single','HatchAngle',h_angle,'FaceColor',h_back,'HatchDensity',h_den);

%Plot simplex 2
plot([s1, s1],[lines(2),dotplotx(2)],'k-')
plot(s1,dotplotx(2),'o','MarkerFaceColor','b', 'MarkerEdgeColor','k',...
    'MarkerSize',4)
red_inv = patch([s1remap 1 1 s1remap],[lines(2) - rectheight/2,...
    lines(2) - rectheight/2, lines(2)+rectheight/2,...
    lines(2)+rectheight/2],'k'); 
hatchfill2(red_inv,'single','HatchAngle',180-h_angle,'FaceColor',h_back,'HatchDensity',h_den);

%Plot simplex 3
plot([s1, s1],[lines(1),dotplotx(1)],'k-')
plot([s2, s2],[lines(1),dotplotx(1)],'k-')
plot([s1remap, s1remap],[lines(1),dotplotx(1)],'k-')
plot([s2remap, s2remap],[lines(1),dotplotx(1)],'k-')
plot(s1,dotplotx(1),'o','MarkerFaceColor','b', 'MarkerEdgeColor','k',...
    'MarkerSize',4)
plot(s2,dotplotx(1),'o','MarkerFaceColor','r', 'MarkerEdgeColor','k',...
    'MarkerSize',4)
both_inv = patch([s1remap s2remap s2remap s1remap],...
    [lines(1) - rectheight/2, lines(1) - rectheight/2,...
    lines(1)+rectheight/2, lines(1)+rectheight/2],'k');
hatchfill2(both_inv,'single','HatchAngle',h_angle,'FaceColor',h_back,'HatchDensity',1.2*h_den);
hatchfill2(both_inv,'single','HatchAngle',180-h_angle,'FaceColor',h_back,'HatchDensity',1.2*h_den);
plot(s1remap,dotplotx(1),'v','MarkerFaceColor','b', 'MarkerEdgeColor','k',...
    'MarkerSize',4)
plot(s2remap,dotplotx(1),'v','MarkerFaceColor','r', 'MarkerEdgeColor','k',...
    'MarkerSize',4)

%Make legend
leg_red = patch([1+loffset, 1+loffset+rectheight/4,...
    1+loffset+rectheight/4, 1+loffset],[lines(3) - rectheight/2,...
    lines(3) - rectheight/2, lines(3)+rectheight/2,...
    lines(3)+rectheight/2],'k');
hatchfill2(leg_red,'single','HatchAngle',h_angle,'FaceColor',h_back,'HatchDensity',2*h_den);
%text(1+1.7*loffset,lines(3)-toffset,'B invades R','FontSize',11,'Interpreter','latex')
text(1+2.55*loffset,lines(3)-toffset,'invades','FontSize',11,'Interpreter','latex')
plot(1+2.1*loffset,lines(3),'o','MarkerFaceColor','b', 'MarkerEdgeColor','k',...
    'MarkerSize',4)
plot(1+5.9*loffset,lines(3),'o','MarkerFaceColor','r', 'MarkerEdgeColor','k',...
    'MarkerSize',4)


leg_blue = patch([1+loffset, 1+loffset+rectheight/4,...
    1+loffset+rectheight/4, 1+loffset],[lines(2) - rectheight/2,...
    lines(2) - rectheight/2, lines(2)+rectheight/2,...
    lines(2)+rectheight/2],'k');
hatchfill2(leg_blue,'single','HatchAngle',180-h_angle,'FaceColor',h_back,'HatchDensity',2*h_den);
text(1+2.55*loffset,lines(2)-toffset,'invades','FontSize',11,'Interpreter','latex')
plot(1+2.1*loffset,lines(2),'o','MarkerFaceColor','r', 'MarkerEdgeColor','k',...
    'MarkerSize',4)
plot(1+5.9*loffset,lines(2),'o','MarkerFaceColor','b', 'MarkerEdgeColor','k',...
    'MarkerSize',4)

leg_both = patch([1+loffset, 1+loffset+rectheight/4,...
    1+loffset+rectheight/4, 1+loffset],[lines(1) - rectheight/2,...
    lines(1) - rectheight/2, lines(1)+rectheight/2,...
    lines(1)+rectheight/2],'k');
%text(1+1.7*loffset,lines(1)-toffset,'Mut. invade','FontSize',11,'Interpreter','latex')
text(1+1.9*loffset,lines(1)+0.11,'mutual','FontSize',11,'Interpreter','latex')
text(1+1.9*loffset,lines(1)-0.11,'invasibility','FontSize',11,'Interpreter','latex')

hatchfill2(leg_both,'single','HatchAngle',h_angle,'FaceColor',h_back,'HatchDensity',2*h_den);
hatchfill2(leg_both,'single','HatchAngle',180-h_angle,'FaceColor',h_back,'HatchDensity',2*h_den);

%Plot arrows
plot([s2-0.02, s2remap + 0.02],[dotplotx(1) dotplotx(1)],'k')
plot(s2remap+0.027,dotplotx(1),'<k','MarkerSize',1.8,'MarkerFaceColor','k')
plot([s1+0.02, s1remap - 0.02],[dotplotx(1) dotplotx(1)],'k')
plot(s1remap-0.027,dotplotx(1),'>k','MarkerSize',1.8,'MarkerFaceColor','k')

%Add figure label
text(-0.08,1.1,'A','FontSize',11,'Interpreter','latex')

xlim([-0.03, 1.5]);
ylim([-0.2,1.2]);
axis off

print(gcf,'Fig2a.eps','-depsc2')
print(gcf,'Fig2a.png','-dpng','-r600');

