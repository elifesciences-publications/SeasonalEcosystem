clear;clc

%This script uses the fit function to fit parameters to the batch dynamics
%of glucose-grown E coli in multisubstrate batch

%Import data, order: glucose galactose biomass
data = csvread('experimental_dynamics_1.csv');

xData = data(:,1); %Time data
yData = data(:,2); %Concentration data
n_p = find(~xData);

%mg per od546 conversion from Lendenmann 1996
mg_per_od = 0.0626*1000;
yData(n_p(3):end) = mg_per_od*yData(n_p(3):end);

%Find start points for fit
startY = (yData(end) - yData(n_p(3)))/(n_p(1) + n_p(2)); %mg/L biomass per mg/L nutrient
startAlpha1 = 0.44;
startAlpha2 = 0.3971;

%ICs and time
IC(1) = yData(1); %Glucose mg/L
IC(2) = yData(n_p(2)); %Galactose mg/L
IC(3) = yData(n_p(3)); %Biomass OD
t_c = 5.7;
K = [0.073; 0.098]; %From Lendenmann 1998, mg/L

%Define fit
ft = fittype('simulate_ecoli_batch(x,alpha1,alpha2,Y,K,IC,t_c)','coefficients',...
    {'alpha1','alpha2','Y'},'independent',{'x'},'problem',{'K','IC','t_c'});
opts = fitoptions( 'Method', 'NonlinearLeastSquares');
opts.Lower = [0,0,0.2];
opts.StartPoint = [startAlpha1, startAlpha2, startY];
opts.Upper = [100,100,1];

%Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts,'problem',{K,IC,t_c});
c_ints = confint(fitresult);
confints = [fitresult.alpha1,fitresult.alpha2,fitresult.Y] -c_ints;


%Simulate time courses from best fit process into vectors
[state_vec,batch_series] = simulate_ecoli_batch(xData,fitresult.alpha1,fitresult.alpha2,fitresult.Y,K,IC,t_c);
sim_data = squeeze(batch_series.Data);
sim_t = squeeze(batch_series.Time);
sim_total = fitresult.Y*(sim_data(:,1) + sim_data(:,2)) + sim_data(:,3);


% %Get confidence intervals from solving ODEs
% [~,batch_up_series] = simulate_ecoli_batch_1(xData,c_ints(1,2),c_ints(1,3),c_ints(1,1));
% [~,batch_low_series] = simulate_ecoli_batch_1(xData,c_ints(2,2),c_ints(2,3),c_ints(2,1));
% up_data = squeeze(batch_up_series.Data);
% up_t = squeeze(batch_up_series.Time);
% low_data = squeeze(batch_low_series.Data);
% low_t = squeeze(batch_low_series.Time);


%Get confidence intervals from matlab predint
n_time = 100;
new_t = transpose(linspace(0,t_c,n_time));
new_t = [new_t; new_t; new_t]; %New time variable for function

%Run to get confidence intervals
uplow = predint(fitresult,new_t,0.95,'functional','on'); 

%Remove nans and negative numbers
row_trunc = sum(sum(isnan(uplow)))/6;
up_t = new_t(1:n_time-row_trunc);
up_data = reshape(uplow(:,2),[n_time,3]);
up_data = up_data(1:end-row_trunc,:);
up_data(up_data < 0) = 0;
low_t = up_t;
low_data = reshape(uplow(:,1),[n_time,3]);
low_data = low_data(1:end-row_trunc,:);
low_data(low_data < 0) = 0;

%Spline all data and extract mass balance
spline_t = linspace(0,xData(end),1000);
gluc_spline = interp1(xData(1:n_p(2)-1),yData(1:n_p(2)-1),spline_t);
gal_spline =  interp1(xData(n_p(2):n_p(3)-1),yData(n_p(2):n_p(3)-1),spline_t);
bio_spline =  interp1(xData(n_p(3):end),yData(n_p(3):end),spline_t);
total_spline = fitresult.Y*(gluc_spline+gal_spline)+bio_spline;
total_series = timeseries(total_spline,spline_t);
total_series = resample(total_series,xData(n_p(3):end));

%Define plotting function
fill_between_lines = @(X1,X2,Y1,Y2,C) fill( [transpose(X1) fliplr(transpose(X2))],  [transpose(Y1) fliplr(transpose(Y2))], C,'EdgeColor','none','FaceAlpha',0.2);

%Plot
my_orange = [0.9100,0.4100,0.1700];
my_purple = [0.5 0 0.5];
marker_size = 4;
fig = newfigure(3.42,3.42/(2));
set(gca,'FontSize',9)
plot(sim_t,sim_data(:,1),'-','LineWidth',1,'Color','r');
hold on
plot(sim_t,sim_data(:,2),'-','LineWidth',1,'Color',my_orange);
plot(sim_t,sim_data(:,3),'-','LineWidth',1,'Color',my_purple);
plot(sim_t,sim_total,'-','LineWidth',1,'Color','k');
%plot(spline_t,total_spline,'-','LineWidth',1,'Color','k');
fill_between_lines(up_t,low_t, up_data(:,1),low_data(:,1),'r')
fill_between_lines(up_t,low_t, up_data(:,2),low_data(:,2),my_orange)
fill_between_lines(up_t,low_t, up_data(:,3),low_data(:,3),my_purple)
plot(xData(1:n_p(2)-1),yData(1:n_p(2)-1),'ro','MarkerFaceColor','r','MarkerSize',marker_size);
plot(xData(n_p(2):n_p(3)-1),yData(n_p(2):n_p(3)-1),'^','MarkerFaceColor',my_orange, 'Color',my_orange,'MarkerSize',marker_size);
plot(xData(n_p(3):end),yData(n_p(3):end),'d','MarkerFaceColor',my_purple, 'Color',my_purple,'MarkerSize',marker_size);
plot(xData(n_p(3):end),squeeze(total_series.Data),'s','MarkerFaceColor','None', 'Color','k','MarkerSize',marker_size);
box off
xlabel('Time (hours)','FontSize', 9, 'Interpreter','latex')
ylabel({'Sugar and biomass';'concentration (mg/L)'},'FontSize', 9, 'Interpreter','latex')
yticks([0 1 2 3])
xticks([0 2 4 6])
yticklabels({'0','1','2','3'})
xticklabels({'0','2','4','6'})
set(gca,'TickLabelInterpreter','latex')
xlim([0,6])
ylim([0,3])


%Legend
set(gca,'OuterPosition',[0.01,0,0.8,1]);
x_pos = 6.6;
gal_y = 2.4;
balance_offset = 3.75;
offset = 0.5;
point_offset = 0.2;
text(x_pos,gal_y,'Galactose','Interpreter','latex')
text(x_pos,gal_y-offset,'Glucose','Interpreter','latex')
text(x_pos,gal_y-2*offset,'Biomass','Interpreter','latex')
text(x_pos,gal_y-3*offset,'Effective','Interpreter','latex')
text(x_pos,gal_y-balance_offset*offset,'biomass','Interpreter','latex')
set(gca,'Clipping','off');
plot(x_pos - point_offset,gal_y - offset,'ro','MarkerFaceColor','r','MarkerSize',marker_size);
plot(x_pos - point_offset,gal_y,'^','MarkerFaceColor',my_orange, 'Color',my_orange,'MarkerSize',marker_size);
plot(x_pos - point_offset,gal_y - 2*offset,'d','MarkerFaceColor',my_purple, 'Color',my_purple,'MarkerSize',marker_size);
plot(x_pos - point_offset,gal_y - 3*offset,'s','MarkerFaceColor','None', 'Color','k','MarkerSize',marker_size);
rectangle('Position',[6.2,gal_y - (balance_offset-0.1)*offset - 0.2,2.25,(4/3)*1.68])

text(-1.3,3.1,'C','FontSize',11,'Interpreter','latex');

%Save
print(gcf,'-dpng','experimental_dynamics_1.png','-r300');
