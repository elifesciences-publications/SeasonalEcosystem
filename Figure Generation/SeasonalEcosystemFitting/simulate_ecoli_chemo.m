function [predict_equi] = simulate_ecoli_chemo(alpha,params,Y,K)

%This function simulates chemostats for all datapoints and returns
%equilibria

tspan = [0,100000];
predict_equi = zeros(length(params(:,1)),4);
for i = 1:length(predict_equi(:,1))
    y0 = [47000 100 100 100];
    d = params(i,4);
    s = params(i,1:3)*d;
    [~,y] = ode15s(@(t,y) simple_chemo(t,y,alpha,d,s,Y,K), tspan, y0);
    predict_equi(i,:) = y(end,:);
end



end

