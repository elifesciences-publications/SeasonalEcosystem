
%Locates the Ri = Rj for both numeric and analytic low Ct

clear;clc

% a = 0.3; 
% 
% c0num = 100;
% n0num = 6;
% K = 1000;
% lowlim = -5;
% uplim = 0;
% c0 = logspace(lowlim,uplim,c0num);
% n0 = logspace(-3,2,n0num);
% NumericCi = zeros(n0num,c0num);
% AnalyticCi = zeros(n0num,c0num);
% 
% options = optimoptions('fsolve','FunctionTolerance',1e-30,'Display','off');
% 
% tic
% for i = 1:c0num
%     for j = 1:n0num
%         NumericCi(j,i) = fsolve(@(x) LowCtNumeric(a,x,K*c0(i),K*n0(j),K), a,options);
%         %AnalyticCi(i) = fsolve(@(x) LowCtAnalytic(a,x,Ct(i),n0), a,options);
%         AnalyticCi(j,i) = Lowc0AnalyticExplicit(a,c0(i),n0(j));
%     end
% end
% toc
% 
% save('low_c0_variable_n0/Figure_Numeric_vs_Analytic_remap.mat')

load('Data/deterministic/Figure_Numeric_vs_Analytic_remap.mat')

%%
newfigure(5,3);
for j = 1:n0num
    loglog(c0,NumericCi(j,:)-a,'b-','LineWidth',1.5);
    hold on
    loglog(c0,AnalyticCi(j,:)-a,'r--', 'LineWidth',1.5)
    text(c0(7+j),2*(AnalyticCi(j,7+j)-a),['$\rho_0/K = ', num2str(n0(j)) '$'],'Rotation',18, 'Interpreter','Latex')
end
set(gca,'YScale','log')
set(gca,'XScale','log')
xlim([10^lowlim, 10^uplim])
ylim([10^-9,10^1])
l = legend('Numerical','2\textsuperscript{nd} order in $c_0/K$');
l.Interpreter = 'Latex';
l.Location = 'southeast';
xlabel('$c_0/K$','Interpreter','Latex');
ylabel('Remapping', 'Interpreter', 'Latex');
% title(['Numeric vs. Analytic \DeltaRemap for \alpha_1 =  ' num2str(a)])

print(gcf,'-depsc2','low_c0_variable_n0_pert_theory.eps');
print(gcf,'-dpng','low_c0_variable_n0_pert_theory.png','-r600');
