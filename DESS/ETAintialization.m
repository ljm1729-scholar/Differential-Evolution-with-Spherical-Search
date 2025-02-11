function [TC,Eg,Eh,CPg,CPh] = ETAintialization(pop)
TC = 500;
f = pop.f;
g = max(0,pop.g);
h = max(0,abs(pop.h)-0.0001);
conv = pop.conv;
i = eps_sort(f,conv,0);
n=ceil(0.9*size(pop.conv,2));  
% Eg = mean(g(:,i(1:n)),2);
% Eh = mean(h(:,i(1:n)),2);

Eg = mean(conv(:,i(1:n)),2);
Eh = mean(conv(:,i(1:n)),2);
CPg=max(3,(-5-log(Eg))./log(0.05));
CPh=max(3,(-5-log(Eh))/log(0.05));
end