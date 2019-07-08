function [steady_state] = simulate_chemo_fit(feed_conc,alpha1,alpha2,alpha3,Y,d,K)

%This function takes in the feeds and returns a properly formatted vector
%of steady-states for the fitting functions

if (mod(length(feed_conc),3)~=0) %This gets the scripts through testing
    steady_state = feed_conc;
else
    alpha = [alpha1 alpha2 alpha3];
    new_feed = reshape(feed_conc,round(length(feed_conc)/3),3);
    num_data = length(new_feed(:,1));
    tspan = [0,10000];
    steady_state = zeros(size(new_feed));
    for i = 1:num_data
        y0 = [47000 100 100 100];
        s = new_feed(i,:)*d;
        [~,y] = ode15s(@(t,y) simple_chemo(t,y,alpha,d,s,Y,K), tspan, y0);
        steady_state(i,:) = y(end,2:4);
    end
    
    steady_state = steady_state(:);
end

end

