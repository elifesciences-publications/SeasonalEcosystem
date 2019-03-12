
clear;clc


Bt = 1008;
Ct = 1000;
m = 21;
p = 2;
s = transpose(linspace(0,1,m));
s = [s , 1-s];

P = [0.3;0.7];
K = 1000;
bo = zeros(m,1) + 1/m;
%chi = [0 0; 0.5 0];


%Simulate
tic
[b,Nr] = serialdilMADAPT_spike(Bt,Ct,s,P,m,p,1,bo,K,0.05);
toc

%Verification
growth = s*transpose(Nr); %Compute the fitnesses
mult = exp(growth); %Verifying that the growth factors are all the same
g = log((Ct+Bt)/Bt);  %Theoretical fitness prediction
