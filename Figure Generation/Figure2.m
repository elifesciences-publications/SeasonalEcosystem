%Plots figure 2

bolus4 = load('Data/deterministic/bolus4partialrobust.mat');
bolus4 = bolus4.bolus4results;
bolus05 = load('Data/deterministic/bolus05partialrobust.mat');
bolus05 = bolus05.bolus05results;
bolus100 = load('Data/deterministic/bolus100partialrobust.mat');
bolus100 = bolus100.bolus100results;

fig2 = newfigure(3.42,3.42/1.4);

[fig2ax,pos] = tight_subplot(3,2,0.04,0.03,0.06);

axes(fig2ax(1));
xticks([])
yticks([])
colors = jet(101);
set(gca,'YScale','log')
for h=1:length(bolus05.s(:,1))
    hold on
    semilogy(bolus05.bstore(h,:), 'LineWidth',1.5,'color',colors(100*bolus05.s(h,1),:))
end
xlim([0,length(bolus05.bstore(1,:))])
ylim([10^(log10(min(bolus05.bstore(:)))-1),10^(log10(max(bolus05.bstore(:)))+1)])
yl = ylabel('$\ln \rho_\sigma$','Interpreter','latex','Rotation',0);
yl.Position = [490, 0.93,-1];
t = text(-400, 0.65,'B','FontSize',11, 'Interpreter', 'Latex');

axes(fig2ax(3));
set(gca,'YScale','log')
xticks([])
yticks([])
for h=1:length(bolus4.s(:,1))
    hold on
    semilogy(bolus4.bstore(h,:), 'LineWidth',1.5,'color',colors(100*bolus4.s(h,1),:))
end
xlim([0,length(bolus4.bstore(1,:))])
ylim([1e-13,10])
t = text(-180, 0.65,'C','FontSize',11, 'Interpreter', 'Latex');

axes(fig2ax(5));
xticks([])
yticks([])
set(gca,'YScale','log')
for h=1:length(bolus100.s(:,1))
    hold on
    semilogy(bolus100.bstore(h,:), 'LineWidth',1.5,'color',colors(100*bolus100.s(h,1),:))
end
xlim([0,length(bolus100.bstore(1,:))])
ylim([10^(log10(min(bolus100.bstore(:)))-1),10^(log10(max(bolus100.bstore(:)))+1)])
t = text(-180, 0.65,'D','FontSize',11, 'Interpreter', 'Latex');

lx = xlabel('Batch','Interpreter','latex');
% disp(lx.Position);
lx.Position=[1700,1E-6,-1];


dotplotx = 0.53;
diamondplotx = 0.5;
schemo = bolus05.s;


%Ct = 0.5 1D representation
P = [0.23 0.77];
axes(fig2ax(2));
plot(linspace(0,1,100),repmat(0.5,100),'-','LineWidth',2,...
    'Color','k')
hold on
s = schemo;
m = length(s);
for i = 1:m
    plot([s(i), s(i)],[0.5,dotplotx],'k-')
    plot(s(i),dotplotx,'v','MarkerFaceColor',colors(100*bolus100.s(i,1),:), 'MarkerEdgeColor','k','MarkerSize',4)
end
plot([P(1), P(1)],[diamondplotx,diamondplotx+0.15],'k-', 'LineWidth',1)
plot(P(1),diamondplotx+0.15,'d','MarkerFaceColor','k', 'MarkerEdgeColor','k','MarkerSize',4);
xlim([0, 1]);
ylim([0.3,0.7]);
axis off
plot([P(1), P(1)],[diamondplotx,0.575],'k-', 'LineWidth', 1)
text(0.4,0.4,'$c_0 \ll K$','FontSize',11,'Interpreter','latex')
% plot(0.8, 0.415, 'vk','MarkerSize',4);
% text(0.83,0.4,'$=$','FontSize',11,'Interpreter','latex')
% plot(0.94, 0.41, 'ok','MarkerSize',4);

% text(0, 0.65,'B','FontSize',11, 'Interpreter', 'Latex');

%Ct = 4 1D representation
axes(fig2ax(4));
plot(linspace(0,1,100),repmat(0.5,100),'-','LineWidth',2,...
    'Color','k')
hold on
%s = [0.248496993987976;0.362725450901804;...  %Remappings from n0 = 1; 
%    0.460921843687375;0.507014028056112;...
%    0.595190380761523;0.743486973947896;0.917835671342685];
s = [0.384465979624639; 0.446066913203218; 0.485229551688219; 0.502935883619789; 0.536578987133076; 0.609381236952106; 0.798243544353202]; %Remapping from n0 = 1e-3

m = length(s);
for i = 1:m
    plot([s(i), s(i)],[0.5,dotplotx],'k-')
    plot(s(i),dotplotx,'v','MarkerFaceColor',colors(100*bolus100.s(i,1),:), 'MarkerEdgeColor','k','MarkerSize',4)
end
plot([P(1), P(1)],[diamondplotx,diamondplotx+0.15],'k-', 'LineWidth',1)
plot(P(1),diamondplotx+0.15,'d','MarkerFaceColor','k', 'MarkerEdgeColor','k','MarkerSize',4);
plot([P(1), P(1)],[diamondplotx,0.575],'k-', 'LineWidth', 1)
xlim([0, 1]);
ylim([0.3,0.7]);
axis off
text(0.4,0.4,'$c_0 \approx K$','FontSize',11,'Interpreter','latex')
% plot(0.8, 0.415, 'vk','MarkerSize',4);
% text(0.83,0.4,'$\ne$','FontSize',11,'Interpreter','latex')
% plot(0.94, 0.41, 'ok','MarkerSize',4);

% text(0, 0.65,'C','FontSize',11, 'Interpreter', 'Latex');

%Ct = 100 1D representation
axes(fig2ax(6));
plot(linspace(0,1,100),repmat(0.5,100),'-','LineWidth',2,...
    'Color','k')
hold on
s = schemo; 
m = length(s);
for i = 1:m
    plot([s(i), s(i)],[0.5,dotplotx],'k-')
    plot(s(i),dotplotx,'v','MarkerFaceColor',colors(100*bolus100.s(i,1),:), 'MarkerEdgeColor','k','MarkerSize',4)
end
plot([P(1), P(1)],[diamondplotx,diamondplotx+0.15],'k-', 'LineWidth',1)
plot(P(1),diamondplotx+0.15,'d','MarkerFaceColor','k', 'MarkerEdgeColor','k','MarkerSize',4);
plot([P(1), P(1)],[diamondplotx,0.575],'k-', 'LineWidth',1)
xlim([0, 1]);
ylim([0.3,0.7]);
axis off
text(0.4,0.4,'$c_0 \gg K$','FontSize',11,'Interpreter','latex')
% plot(0.8, 0.415, 'vk','MarkerSize',4);
% text(0.83,0.4,'$=$','FontSize',11,'Interpreter','latex')
% plot(0.94, 0.41, 'ok','MarkerSize',4);
% text(0, 0.65,'D','FontSize',11, 'Interpreter', 'Latex');


ar = annotation('arrow','X',[0.595, 0.68], 'Y', [0.8, 0.55]);
ar.Color = 'k';
ar.LineStyle = ':';
ar.HeadLength = 6;
ar.HeadWidth = 6;

% ar = annotation('arrow','X',[0.945, 0.935], 'Y', [0.8, 0.6]);
% ar.Color = 'k';
% ar.LineStyle = ':';
% ar.HeadLength = 6;
% ar.HeadWidth = 6;


ar = annotation('arrow','X',[0.68, 0.605], 'Y', [0.48, 0.21]);
ar.Color = 'k';
ar.LineStyle = ':';
ar.HeadLength = 6;
ar.HeadWidth = 6;


print(gcf,'Fig2.eps','-depsc2')
print(gcf,'Fig2.png','-dpng','-r600');