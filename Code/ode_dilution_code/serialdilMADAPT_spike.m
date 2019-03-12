function [endb,endNr,bstore,Nrstore,bstore_spike,endb_spike,endb_spike_median,endb_median] = serialdilMADAPT_spike(Bt,Ct,s,P,m,p,plt,bo,K,spike,batch_limit)

%Jaime Lopez 9/28/17
%This function simulates serial dilutions
%Simulation ends dependent on extinction tolerance and RAE tolerance

%Bt - transfer biomass
%Ct - initial nutrient load 
%s - strategy matrix
%P - nutrient ratios
%m - number of species
%p - number of nutrient
%plt - 1 to generate plot, 0 to suppress
%bo - initial biomass ratio
%errype - 1 for abundance, 0 for diversity (note: diversity error is new 
            %and hasn't been thoroughly tested)
%K - half-velocity coefficient, default to 1
            
%SIMULATION SET-UP---------------------------------------------------------

if exist('bo') == 0 %Check if initial biomass ratio was specified
    b = zeros(m,1) + 1/m; %default to initial biomass ratio equal
else
    b = bo; %Specified initial biomass
end


if exist('K') == 0
    K = 1;
end

bstore = zeros(m,1e7);%Preallocate biomass ratio storage vector
bstore(:,1) = b; %Biomass ratio storage vector entry one
bstore_spike = bstore; %Preallocate biomass with spike vector
Nrstore = zeros(1e7,p); %Preallocate N storage

o = 0; %Main loop exit variable
i = 0; %Transfer tracking variable
from_batch = round((1-spike)*Bt);
from_spike = round(spike*Bt);
%SIMULATION----------------------------------------------------------------

while o == 0
    
    i = i + 1;
    
    %Simulate batch
    [bstore(:,i+1),Nrstore(i,:)] = multispeciesbatchMADAPT(bstore_spike(:,i),Bt,Ct,s,P,m,p,0,K);
    btemp = bstore(:,i+1)*(Ct+Bt);
    btemp = floor(btemp) + (btemp - floor(btemp) > rand(m,1));
    btemp = (my_hygernd(btemp,from_batch) + my_hygernd(b*Bt,from_spike))/Bt;
    bstore_spike(:,i+1) = btemp;
        
    if i > batch_limit %Exit loop if loop count exceeds limit
        o = 1;
    end
end


%PROCESS DATA--------------------------------------------------------------

bstore = bstore(:,1:(i+1)); %Eliminate additional zeroes
endb = mean(bstore(:,end-round(0.5*batch_limit):end),2); %Final biomass fraction
endb_median = median(bstore(:,end-round(0.5*batch_limit):end),2);

bstore_spike = bstore_spike(:,1:(i+1)); %Eliminate additional zeroes
endb_spike = mean(bstore_spike(:,end-round(0.5*batch_limit):end),2); %Final spiked biomass fraction
endb_spike_median = median(bstore_spike(:,end-round(0.5*batch_limit):end),2);

Nrstore = Nrstore(1:i,:); %Eliminate additional zeros
endNr = Nrstore(end,:); %Final N values

%PLOTTING------------------------------------------------------------------

if plt == 1
    
    %PLOT END BIOMASS RATIO DYNAMICS
    colors = jet(m);
    figure
    set(gcf, 'Position', [500 250 750 600]);
    for h=1:m  %Plot end-batch biomass ratios vs. transfer number
        hold on
        if p ==3
        semilogy(bstore(h,:), 'LineWidth',1.5,'color',s(h,:))
        else 
        semilogy(bstore(h,:), 'LineWidth',1.5,'color',colors(h,:))
        end
    end
    title(['Competition between ' num2str(m) ' species for ' num2str(p) ...
        ' nutrients at ' num2str(P(1)) '/' num2str(P(2))])
    xlabel('Transfer number')
    ylabel('Population fraction at batch start')
    leg = [];
    for h = 1:m %Generate legend from strategies
        legi = [];
        for k = 1:p
            if k < p
                legi = [legi num2str(s(h,k),'%5.2f') '/'];
            else
                legi = [legi num2str(s(h,k),'%5.2f')];
            end
        end
        leg = [leg; legi];
    end
    legend(leg)
    set(gca,'YScale', 'log')
    
    %SIMPLEX PLOTS IF P = 3
    if p == 3 %Plots this only when there are three nutrients
        figure %Plot strategies and nutrient supply on the simplex
        set(gcf, 'Position', [500 500 750 600]);
        for i = 1:m
        ternplot(s(i,1),s(i,2),s(i,3),'o','MarkerEdgeColor',s(i,:),'majors',...
            0,'MarkerFaceColor',s(i,:),'majors',0)
        hold on
        end
        ternplot(P(1),P(2),P(3),'kd','majors',0,'LineWidth',2)
    end
    
    %NR PLOTS
    figure
    if p == 2
        plot((Nrstore(:,1)-Nrstore(:,2))./(Nrstore(:,1)+Nrstore(:,2)))
        title('(N1-N2)/(N1+N2) vs. Transfer Number')
        xlabel('Transfer Number')
        ylabel('(N1-N2)/(N1+N2)')
    elseif p ==3
        plot((abs(Nrstore(:,1)-Nrstore(:,2)) + abs(Nrstore(:,1)-...
            Nrstore(:,3))+abs(Nrstore(:,2)-Nrstore(:,3)))./(Nrstore(:,1)+Nrstore(:,2)+Nrstore(:,3)))
        title('Absolute differences/sums vs. Transfer Number')
        xlabel('Transfer Number')
        ylabel('Absolute differences/sums')
    end
    
end

end
