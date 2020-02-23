function [endb,endNr,bstore,Nrstore] = serialdilMADAPT_bolus_cycling(Bt,Ct,s,P_cycle,m,p,plt,bo,K)

%Jaime Lopez 9/28/17
%This function simulates serial dilutions with cycles of boluses
%Simulation ends dependent on extinction tolerance and RAE tolerance

%Bt - transfer biomass
%Ct - initial nutrient load 
%s - strategy matrix
%P_cycle - cycle of nutrient ratios
%m - number of species
%p - number of nutrient
%plt - 1 to generate plot, 0 to suppress
%bo - initial biomass ratio
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
Nrstore = zeros(1e7,p); %Preallocate N storage

cycle_length = size(P_cycle,2);
repeated_P_cycle = repmat(P_cycle,1,ceil(1e7/cycle_length));

tol = 1e-8; %Relative absolute error tolerance for stopping transfers
extol = 1e-75; %Extinction tolerance for stopping transfers

o = 0; %Main loop exit variable
i = 0; %Transfer tracking variable
er = 100;
%SIMULATION----------------------------------------------------------------

while o == 0
    
    i = i + 1;
    
    %Simulate batch
    [bstore(:,i+1),Nrstore(i,:)] = multispeciesbatchMADAPT(bstore(:,i),Bt,Ct,s,repeated_P_cycle(:,i),m,p,0,K);
    
    if mod(i-1,cycle_length) == 0 && i > 2*cycle_length
        b_cycle_curr = mean(bstore(:,i+2-cycle_length:i+1),2);
        b_cycle_prev = mean(bstore(:,i+2-2*cycle_length:i+1-cycle_length),2);
        er = abs((b_cycle_curr - b_cycle_prev)./b_cycle_curr);
    end
    
    if max(er) < tol %Exit loop of error below threshold
        o = 1;
        disp(['The model has been ended due to an RAE of '...
            num2str(transpose(er))])
        disp('The populations are')
        disp(bstore(:,i+1))
    end
    
    if min(bstore(:,i+1)) < extol %Exit loop if an organism has died
        o = 1;
        disp(['The model has been ended due to an population of '...
            num2str(min(bstore(:,i+1)))])
    end
end


%PROCESS DATA--------------------------------------------------------------

bstore = bstore(:,1:(i+1)); %Eliminate additional zeroes
endb = bstore(:,end); %Final biomass fraction
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
        ' nutrients'])
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
    if min(endb) < extol
    ylim([extol, 1.5]);
    end
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
