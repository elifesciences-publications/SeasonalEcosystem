% Plots stochstic simulation results for multiple nu 

% determ_spike = load('Data/deterministic/n0_spike_1008_diversity_vs_c0_parallel.mat');
determ_spike_nonfixedE = load('Data/deterministic/n0_spike_different_budget_1008_diversity_vs_c0_parallel.mat');



determ_nospike = load('Data/deterministic/n0_1008_diversity_vs_c0_parallel.mat');


newfigure(3.42/2, 3.42/1.3/2);
Smap = colormap(cool(105));
    
for SS=1:length(determ_spike_nonfixedE.P)    
    loglog(determ_spike_nonfixedE.diversity_c0_index, 2.^determ_spike_nonfixedE.D(:,SS),'-','LineWidth',1,'Color',Smap(1+floor(determ_spike_nonfixedE.P(SS)*200),:),'DisplayName',['S=' num2str(determ_spike_nonfixedE.P(SS))]);
    hold on
%     loglog(determ_nospike.diversity_c0_index, 2.^determ_nospike.D(:,SS),':','LineWidth',1,'Color',Smap(1+floor(determ_spike_nonfixedE.P(SS)*200),:),'DisplayName',['S=' num2str(determ_spike_nonfixedE.P(SS))]);
end
loglog(determ_spike_nonfixedE.diversity_c0_index, 21*ones(size(determ_spike_nonfixedE.diversity_c0_index)),'--k','LineWidth',2,'DisplayName','m');
        
% Axes labels
set(gca,'FontSize',9);
xl=xlabel('Bolus size $c_0/K$','Interpreter','Latex','FontSize', 9);
xlim(10.^[-3,3]);
xticks(10.^[-3,0,3]);
yld = ylabel('Eff. species $m_e$','Interpreter','latex','FontSize', 9);
ylim([1, 32]);
yticks([1,2,4, 8, 16, 32]);
%     yld.Position(2) = yld.Position(2);

% Pretty colorbar
colormap(Smap);
c = colorbar('TickLabels',{'$0$' '$0.5$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
c.Location = 'North';
c.Position = [0.33812      0.88694      0.46597      0.09681];
c.Ticks=[];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
c.Label.String = 'Nutrient 1';
c.Label.Interpreter = 'Latex';
c.Label.Position = [0.5,1,0];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;
text(10^(-2.7),33,'$0$', 'Interpreter','Latex');
text(10^(2.6),33,'$\frac{1}{2}$', 'Interpreter','Latex');

epsilon=0.1;
text(10^(-2.7),2,['$\varepsilon = ' num2str(epsilon,2), '$'],'Interpreter','Latex');
    
box off
figfile = ['Diversity_collected_spike_0.05_stdE_0.05'];
set(gcf, 'Name', figfile);
text(10^(-4.82), 35,'C', 'FontSize', 11, 'Interpreter', 'Latex');
print(gcf,'-dpng',[figfile '.png'],'-r600');
print(gcf,'-depsc2',[figfile '.eps']);
    
%% n_{\sigma} all strategies
    
newfigure(3.42/2, 3.42/1.25/2);
sigmamap = colormap(jet(length(determ_spike_nonfixedE.bo)));
ha = tight_subplot(2,1,[0.03 0],[.312 0.04],[.25 0.1]);
to_plot = [6,1];
    
for tp=1:length(to_plot)
    % Get max strategy
    Esigma = sum(determ_spike_nonfixedE.s,2);
    [maxE, mxsigma_ind] = max(Esigma);
    SS = to_plot(tp);
    axes(ha(tp));

    for sigma=1:length(determ_spike_nonfixedE.s)
        loglog(determ_spike_nonfixedE.diversity_c0_index, determ_spike_nonfixedE.n0*determ_spike_nonfixedE.blist(SS,:,sigma), '-', 'Color', sigmamap(sigma,:),'DisplayName',['\sigma=' num2str(sigma)]);
        hold on
        if(maxE>1 && sigma==mxsigma_ind)
            loglog(determ_spike_nonfixedE.diversity_c0_index(end), determ_spike_nonfixedE.n0*determ_spike_nonfixedE.blist(SS,end,sigma), '*', 'Color', sigmamap(sigma,:));
        end
    end
    set(gca,'FontSize', 9);
    text(10^(-3), 10^0.4, ['Nut1=' num2str(determ_nospike.P(SS))], 'Interpreter', 'Latex', 'FontSize', 8);
    xlabel('Bolus size $c_0/K$', 'Interpreter','Latex','FontSize', 9);
    xticks(10.^[-3,0,3]);
    yl = ylabel('$\rho_{\sigma}$', 'Interpreter', 'Latex','FontSize', 9);
    yticks(10.^[0,2]);
    yticklabels({'10^0', '10^2'});
    xlim(10.^[-3,3]);
    ylim(10.^[0, 3.5]);
    box off
    if(tp==1)
        text(10^(-5), 10^3.3,'D', 'FontSize', 11, 'Interpreter', 'Latex');
        xticklabels([]);
        xlabel('');
        text(10^(-2.8),10^3.4,'$0$', 'Interpreter','Latex');
        text(10^(1.7),10^3.4,'$1$', 'Interpreter','Latex');
    end
    %     box on
end

% Pretty colorbar
colormap(sigmamap);
c = colorbar('TickLabels',{'$0$' '$1$'},'Ticks',[0 1],'TickLabelInterpreter','latex');
c.Location = 'North';
c.Position(1) = 0.33;
c.Position(2) = 0.93;
c.Position(3) = 0.4;
c.Position(4) = 0.07;
c.Ticks=[];
c.AxisLocationMode='manual';
c.AxisLocation = 'in';
c.Label.String = '$\alpha_{\sigma,1}$';
c.Label.Interpreter = 'Latex';
c.Label.Position = [0.15,1.35,0];
c.Label.Rotation = 0;
c.Label.Color='w';
c.Label.FontSize = 9;

figfile = 'med_nsigma_spike_collected_spike_0.05_stdE_0.05';    
set(gcf, 'Name', figfile);
print(gcf,'-dpng',[figfile '.png'],'-r600');
print(gcf,'-depsc2',[figfile '.eps']);
