function [b,Nr,Bstore,Cstore,tstore] = multispeciesbatchMADAPT_variable_K_nu_time(bo,Bt,Ct,s,P,m,p,plt,K,nu,time_cutoff)

%Jaime Lopez 9/27/17
%This function computes one batch of m microbes competing for p substrates
%Saturated monod growth, all growth parameters unity, adaptive timestepping

%bo - initial biomass ratio
%Bt - transfer biomass
%Ct - initial nutrient load 
%s - strategy matrix
%P - nutrient ratios
%m - number of species
%p - number of nutrient
%plt - 1 to generate plot, 0 to suppress
%K - half-velocity coefficient

%PARAMETERS----------------------------------------------------------------

maxchange = 0.01; %Maximum ratio of change in one step
tn = 1; %Timestep tracking variable 
u = 0; %Loop exit variable
if exist('K') == 0 %Check if half-velocity constant was specified
    K = 1; 
end

%INITIAL VALUES AND STORAGE------------------------------------------------

B = Bt.*bo; %Initial biomass
C = Ct.*P; %Initial nutrient concentration
Co = C; %Storing initial nutrient concentration
Cstore = zeros(p,1e7); %Concentration tracking variable
Bstore = zeros(m,1e7); %Biomass tracking variable
tstore = zeros(1,1e7); %Time tracking variable

Bstore(:,tn) = B; %Store initial biomass
Cstore(:,tn) = C; %Store initial nutrient

%SET GROWTH FUNCTION-------------------------------------------------------

gr = @(Bvar,Cvar) Bvar.*(s*(nu.*Cvar./(K + Cvar)));

%SET CONSUMPTION FUNCTION--------------------------------------------------

if m > 1
    con = @(Bvar,Cvar) (Cvar./(K + Cvar)).*transpose(sum(s.*repmat(Bvar,1,p)));
else
    con = @(Bvar,Cvar) (Cvar./(K + Cvar)).*transpose(s.*repmat(Bvar,1,p));
end

%SIMULATION----------------------------------------------------------------

while u == 0
    
    tn = tn + 1; %Advance timestep number
    
    %COMPUTE K1
    Ci = C;
    Bi = B;
    gr1 = gr(Bi,Ci);
    con1 = con(Bi,Ci);
    
    relchange = abs([gr1./B ; con1./C]);
    relchange = relchange(~isinf(relchange) & ~isnan(relchange));
    relchange = max(relchange);
    if relchange == 0
        relchange = 1;
    end
    dt = maxchange/relchange; %Set time step
    
    tstore(tn) = tstore(tn-1) + dt; %Store time
    
    %COMPUTE K2
    Bii = Bi + 0.5*dt.*gr1;
    Cii = Ci - 0.5*dt.*con1;
    gr2 = gr(Bii,Cii);
    con2 = con(Bii,Cii);
    
    %COMPUTE K3
    Biii = Bi + 0.5*dt*gr2;
    Ciii = Ci - 0.5*dt*con2;
    gr3 = gr(Biii,Ciii);
    con3 = con(Biii,Ciii);
    
    %COMPUTE K4
    Biv = Bi + dt*gr3;
    Civ = Ci - dt*con3;
    gr4 = gr(Biv,Civ);
    con4 = con(Biv,Civ);
    
    %TRUE TIMESTEP
    B = Bi + dt*((1/6)*gr1 + (1/3)*gr2 + (1/3)*gr3 + (1/6)*gr4);
    C = Ci - dt*((1/6)*con1 + (1/3)*con2 + (1/3)*con3 + (1/6)*con4);
    
    
    C(C > 0 & C < 1e-50) = 0; 
    
    %STORAGE
    Bstore(:,tn) = B;
    Cstore(:,tn) = C;
    
    
    %EXIT CHECKS
    if min(C) < 0 %Check for negative concentration
        disp('NEGATIVE CONCENTRATIONS. SIMULATION ENDED. REDUCE STEP SIZE');
        u = 1;
        disp(C);
        disp(P(1));
    end
    if tstore(tn) > time_cutoff %Check for depletion below determined threshold
        u = 1; %Loop exit variable    
    end
    
end

%PROCESS DATA--------------------------------------------------------------

b = B./sum(B); %Determine new initial fraction
Bstore = Bstore(:,1:tn); %Remove zeros from storage vectors
Cstore = Cstore(:,1:tn); %Remove zeros from storage vectors
tstore = tstore(1:tn); %Remove zeros from time vector
Nr = simps(tstore,transpose((Cstore./(K+Cstore)))); %Compute integral of growth
%Nr = trapz(tstore,transpose((Cstore./(K+Cstore)))); %Compute integral of growth


%PLOTTING(Activated with plt = 1)------------------------------------------

if plt == 1
    
    %PLOTTING BIOMASS
    figure
    colors = jet(m);
    for h=1:m
        hold on
        plot(tstore,Bstore(h,:),'Color',colors(h,:))
    end
    title('Biomass vs. Time')
    xlabel('Time')
    ylabel('Biomass')
    leg = [];
    for h = 1:m %Generate legend from strategies
        legi = [];
        for k = 1:(p-1)
            if k < (p-1)
                legi = [legi num2str(s(h,k),'%5.2f') '/'];
            else
                legi = [legi num2str(s(h,k),'%5.2f')];
            end
        end
        leg = [leg; legi];
    end
    legend(leg)    
    
    %PLOT CONCENTRATIONS
    figure
    colors2 = lines(p);
    for l=1:p
        hold on
        plot(tstore,Cstore(l,:)./(K+Cstore(l,:)),'Color',colors2(l,:))
    end
    title('Growth Function vs. Time')
    xlabel('Time')
    ylabel('Growth Function')
    leg = [];
    for h = 1:p
        leg = [leg; 'Nutrient ' num2str(h)];
    end
    legend(leg)
    
    %PLOT TOTAL MASS
    figure
    if m > 1
        plot(tstore, sum(Cstore) + sum(Bstore))
    elseif m == 1
        plot(tstore, sum(Cstore) + Bstore)
    end
    title('Total Mass vs. Time')
    xlabel('Time')
    ylabel('Mass')
end


end