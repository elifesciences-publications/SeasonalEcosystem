function [endb,endNr,bstore,Nrstore] = serialdilMADAPT(Bt,Ct,s,P,m,p,plt,bo,errtype,K)

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

if exist('errtype') == 0 %Check if errtype was specified
    errtype = 1; %Default to abundance
end

if exist('K') == 0
    K = 1;
end

bstore = zeros(m,1e7);%Preallocate biomass ratio storage vector
bstore(:,1) = b; %Biomass ratio storage vector entry one
Nrstore = zeros(1e7,p); %Preallocate N storage

tol = 1e-8; %Relative absolute error tolerance for stopping transfers
extol = 1e-75; %Extinction tolerance for stopping transfers

o = 0; %Main loop exit variable
i = 0; %Transfer tracking variable
er = 100;%Absolute relative error variable

%SIMULATION----------------------------------------------------------------

while o == 0
    
    i = i + 1;
    
    %Simulate batch
    [bstore(:,i+1),Nrstore(i,:)] = multispeciesbatchMADAPT(bstore(:,i),Bt,Ct,s,P,m,p,0,K);
    
    %Compute relative error between batches of populations or diversity
    if errtype == 1
        er = abs((bstore(:,i+1) - bstore(:,i))./bstore(:,i+1));
    else
        Dcurr = -sum(bstore(:,i+1).*log2(bstore(:,i+1)));
        Dprev = -sum(bstore(:,i).*log2(bstore(:,i)));
        er = abs((Dcurr - Dprev)/Dcurr);
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
