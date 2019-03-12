remap = load('Data/deterministic/2d_diversity_sweep.mat');
D = remap.D;
P = remap.Plist;
n0=remap.n0;
K=remap.K;
nSpecies=remap.m;
Ct = remap.diversity_c0_index;


newfigure(3.42/2, 3.42/1.25/2);
sigmamap = colormap(jet(201));
ha = tight_subplot(2,1,[0.03 0],[.312 0.04],[.25 0.1]);
to_plot = [6,1];

for tp=1:length(to_plot)
    axes(ha(tp));
    S1 = P(to_plot(tp));
    for ss=1:length(remap.s)
        loglog(Ct, squeeze(remap.blist(to_plot(tp),:,ss))*n0, '-', 'Color', sigmamap(1+(ss-1)*10,:),'DisplayName',['\sigma=' num2str(remap.s(ss,1))]);
        hold on
    end
    plot(Ct(1), 1E-19,'.w'); % For plotting function to not be wierd
    set(gca,'FontSize', 9);
    text(10^(-4), 10^-18, ['Nut1=' num2str(S1)], 'Interpreter', 'Latex', 'FontSize', 8);
    xlim(10.^[-4,4]);
    xlabel('Bolus size $c_0/K$', 'Interpreter','Latex');
    xticks(10.^[-4,0,4]);
    
    yticks(10.^[-20,0]);
    ylim(10.^[-20,5]);
    yl = ylabel('$\rho_{\sigma}$', 'Interpreter', 'Latex');
    yl.Position(1) = yl.Position(1)+1E-6;
    box off
    if(tp==1)
        text(10^(-7), 10^3.3,'D', 'FontSize', 11, 'Interpreter', 'Latex');
        xticklabels([]);
        xlabel('');
        text(10^(-3.8),10^4.5,'$0$', 'Interpreter','Latex');
        text(10^(2),10^4.5,'$1$', 'Interpreter','Latex');
    end    
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

figfile = ['determ_nsigma'];    
set(gcf, 'Name', figfile);
print(gcf,'-dpng',[figfile '.png'],'-r600');
print(gcf,'-depsc2',[figfile '.eps']);