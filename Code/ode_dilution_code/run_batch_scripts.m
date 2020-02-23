clear;clc
%Test script for batch codes

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
plt = 1;

%Simulate
tic
[b,Nr,Bstore,Cstore,tstore] = multispeciesbatchMADAPT(bo,Bt,Ct,s,P,m,p,plt,K);
%[b,Nr,Bstore,Cstore,tstore] = multispeciesbatchMADAPT_troph(bo,Bt,Ct,s,P,m,p,plt,K,chi);
toc

%Compute growth metrics
growth = s*transpose(Nr);
mult = exp(growth);
g = (Bt+Ct)/Bt;
