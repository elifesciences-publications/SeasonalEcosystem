
%Test script for dilution codes

Bt = 1000;
Ct = 1000;
m = 5;
p = 2;
s = transpose(linspace(0,1,m));
s = [s , 1-s];
P = [0.7; 0.3];
K = 1000;
bo = zeros(m,1) + 1/m;
chi = [0 0; 0.5 0];
spike = 0.05;
batch_limit = 100; 

%Simulate
tic
[b,Nr] = serialdilMADAPT(Bt,Ct,s,P,m,p,1,bo,1,K);
%[b,Nr] = serialdilMADAPT_spike(Bt,Ct,s,P,m,p,1,bo,K,spike,batch_limit);
%[b,Nr] = serialdilMADAPT_troph(Bt,Ct,s,P,m,p,1,bo,1,K,chi);
toc

%Verification
growth = s*transpose(Nr); %Compute the fitnesses
mult = exp(growth); %Verifying that the growth factors are all the same
g = log((Ct+Bt)/Bt);  %Theoretical fitness prediction
