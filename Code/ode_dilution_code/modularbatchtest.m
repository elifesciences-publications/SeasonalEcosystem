clear;clc

%Specify variables
Bt = 1;
Ct = 1;
m = 3;
p = 2;
s = transpose(linspace(0,1,m));
s = [s , 1-s];

P = [1;0];
K = 1;
bo = 1/m;
chi = [0 0; 1 0];

%Simulate
tic
%[b,Nr,Bstore,Cstore,tstore] = multispeciesbatchMADAPT(bo,Bt,Ct,s,P,m,p,false,K);
[b,Nr,Bstore,Cstore,tstore] = multispeciesbatchMADAPT_troph(bo,Bt,Ct,s,P,m,p,true,K,chi);
toc

%Compute growth metrics
growth = s*transpose(Nr);
mult = exp(growth);
g = (Bt+Ct)/Bt;

%n_zero = Bt*exp(tstore);
%n_first = Bt*exp(tstore).*(1-((K./(Ct - Bt*exp(tstore) + Bt))).*tstore);

%figure; semilogx(tstore,exp(-tstore).*Bstore,'k-',tstore,exp(-tstore).*n_zero,'b--',tstore,exp(-tstore).*n_first,'r.')
%ylim([0.6,1.2])