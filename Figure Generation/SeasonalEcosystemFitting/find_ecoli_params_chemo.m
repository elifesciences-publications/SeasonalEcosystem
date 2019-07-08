clear;clc

%Import data and process
%Glucose,Ribose,Fructose,Dil rate,Biomass,Glucose SS, Ribose SS,Fructose SS
data = csvread('direct_experimental_chemostat.csv');
params = data(:,1:4);
true_equi = data(:,5:8);
xData = data(:,1:3);
x = xData(:);
yData = data(:,6:8);
y = yData(:);

%Input known parameters
Y = 0.45; %ug biomass/ug sugar, Lendenmann 1996
d = params(1,4); %h^-1, Lendenmann 1996 chemostat experiments
K = [73 132 125]; %Glucose ribose fructose Ks, ug/L, Lendenmann 1998

%Get fit to data
ft = fittype('simulate_chemo_fit(x,alpha1,alpha2,alpha3,Y,d,K)','coefficients',...
    {'alpha1','alpha2','alpha3'},'independent',{'x'},'problem',{'Y','d','K'});
opts = fitoptions( 'Method', 'NonlinearLeastSquares');
opts.Lower = [0,0,0];
opts.StartPoint = 8e0*[0.54, 0.11, 0.35];
opts.Upper = [1e5,1e5,1e5];
opts.TolFun = 1e-10;
opts.TolX = 1e-10;
[fitresult, gof] = fit( x, y, ft, opts, 'problem', {Y,d,K});

%Prepare new input data for predicted intervals
n1 = 50;
n2 = 40;
new_d = zeros(n1 + n2,1) + 0.6;
new_gluc = [transpose(linspace(1e5,0,n1));transpose(linspace(1e5,1e4,n2))];
new_rib = [zeros(n1,1) ; transpose(linspace(0,9e4,n2))]; 
new_fruc = [transpose(linspace(0,1e5,n1)); zeros(n2,1)];
new_params = [new_gluc, new_rib, new_fruc, new_d];

%Compute actual best fit and confidence intervals
best_predict = simulate_ecoli_chemo([fitresult.alpha1,fitresult.alpha2,fitresult.alpha3],new_params,Y,K);
c_ints = confint(fitresult);
confints = [fitresult.alpha1,fitresult.alpha2,fitresult.alpha3] -c_ints;


%%Uncomment to get lower and upper from odes
%up_predict = simulate_ecoli_chemo(conf_ints(2,:),new_params,Y);
%low_predict = simulate_ecoli_chemo(conf_ints(1,:),new_params,Y);

%Uncomment to get lower and upper from matlab
new_x = new_params(:,1:3);
new_x = new_x(:);
uplow = predint(fitresult,new_x,0.95,'functional','on'); 
up_predict = [zeros(n1+n2,1),reshape(uplow(:,1),[n1+n2,3])];
low_predict = [zeros(n1+n2,1),reshape(uplow(:,2),[n1+n2,3])];



%Plot 
fill_between_lines = @(X,Y1,Y2,C) fill( [transpose(X) fliplr(transpose(X))],  [transpose(Y1) fliplr(transpose(Y2))], C,'EdgeColor','none','FaceAlpha',0.2);

fig2a = newfigure(3.42,3.42/(2));
[fig2ax,pos] = tight_subplot(1,2,0.15,[0.3 0.12],[0.2,0.05]);
set(gca,'FontSize',9)
axes(fig2ax(1))
mygreen = [0 0.5 0];
marker_size = 4;
plot(new_params(1:n1,1)/1e5,best_predict(1:n1,2),'r-','LineWidth',1);
hold on
plot(new_params(1:n1,1)/1e5,best_predict(1:n1,4),'-','LineWidth',1,'Color',mygreen);
fill_between_lines(new_params(1:n1,1)/1e5,low_predict(1:n1,2), up_predict(1:n1,2),'r')
fill_between_lines(new_params(1:n1,1)/1e5,low_predict(1:n1,4), up_predict(1:n1,4),mygreen)
plot(params(1:5,1)/1e5,true_equi(1:5,2),'ro','MarkerFaceColor','r','MarkerSize',marker_size);
plot(params(1:5,1)/1e5,true_equi(1:5,4),'^','MarkerFaceColor',mygreen, 'Color',mygreen,'MarkerSize',marker_size);
xlabel({'Feed fraction of glucose';'(balance fructose)'},'FontSize', 9, 'Interpreter','latex')
ylabel({'Steady-state sugar'; 'concentration ($\mu$g/L)'},'Interpreter','Latex', 'FontSize', 9)
ylim([0,300])
yticks([0 150 300])
xticks([0 0.5 1])
xticklabels({'0','0.5','1'})
set(gca,'TickLabelInterpreter','latex')
box off
lim1 = 300;
del1 = 0.03;
del2 = lim1/90;
gluc1 = 280 - del2;
label_spacing = 6.5;
rec_size = 3.35;
rec_lower = 17;
fruc = gluc1 - lim1/label_spacing;
legmarker = 4;
text(0.5-del1,fruc,'Fructose','Interpreter','latex')
plot(0.45-del1,gluc1,'ro','MarkerFaceColor','r','MarkerSize',legmarker)
text(0.5-del1,gluc1,'Glucose','Interpreter','latex')
plot(0.45-del1,fruc,'^','Color',mygreen,'MarkerFaceColor',mygreen,'MarkerSize',legmarker)
rectangle('Position',[0.4-del1,fruc-lim1/rec_lower,0.62,lim1/rec_size])
xlim([0,1])
label_offset = 335;
text(-0.67,label_offset,'A','FontSize',11,'Interpreter','latex');
set(gca,'clipping','off')

axes(fig2ax(2))
plot(new_params(n1+1:end,1)/1e5,best_predict(n1+1:end,2),'r-','LineWidth',1);
hold on
plot(new_params(n1+1:end,1)/1e5,best_predict(n1+1:end,3),'b-','LineWidth',1);
hold on
fill_between_lines(new_params(n1+1:end,1)/1e5,low_predict(n1+1:end,2), up_predict(n1+1:end,2),'r')
fill_between_lines(new_params(n1+1:end,1)/1e5,low_predict(n1+1:end,3), up_predict(n1+1:end,3),'b')
plot(params(6:end,1)/1e5,true_equi(6:end,2),'ro','MarkerFaceColor','r','MarkerSize',marker_size);
plot(params(6:end,1)/1e5,true_equi(6:end,3),'b^','MarkerFaceColor','b','MarkerSize',marker_size);
xlabel({'Feed fraction of glucose';'(balance ribose)'},'FontSize', 9, 'Interpreter','latex')
ylim([0,800])
xlim([0,1])
yticks([0 400 800])
xticks([0 0.5 1])
xticklabels({'0','0.5','1'})
set(gca,'TickLabelInterpreter','latex')
box off
lim2 = 800;
del2 = lim2/90;
gluc2 = lim2*(280/lim1)-del2;
ribo = gluc2 - lim2/label_spacing;
legmarker = 4;
text(0.5-del1,ribo,'Ribose','Interpreter','latex')
plot(0.45-del1,gluc2,'ro','MarkerFaceColor','r','MarkerSize',legmarker)
text(0.5-del1,gluc2,'Glucose','Interpreter','latex')
plot(0.45-del1,ribo,'b^','MarkerFaceColor','b','MarkerSize',legmarker)
rectangle('Position',[0.4-del1,ribo-lim2/rec_lower,0.58,lim2/rec_size])
xlim([0,1])
text(-0.4,label_offset*(800/300),'B','FontSize',11,'Interpreter','latex');
set(gca,'clipping','off')

print(gcf,'-dpng','direct_experimental_chemostat.png','-r300');
