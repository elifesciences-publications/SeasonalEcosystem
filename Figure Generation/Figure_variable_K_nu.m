%Plot variable K and nu figure
load('Data/deterministic/variable_K_nu.mat')

colors = jet(m);
figure
set(gcf, 'Position', [500 250 750 600]);
for h=1:m  %Plot end-batch biomass ratios vs. transfer number
    hold on
    semilogy(bstore(h,:), 'LineWidth',1.5,'color',colors(h,:))
end
xlabel('Transfer number')
ylabel('Population fraction at batch start')

set(gca,'YScale', 'log')

print(gcf,'variable_K_nu_fig.png','-dpng','-r600');