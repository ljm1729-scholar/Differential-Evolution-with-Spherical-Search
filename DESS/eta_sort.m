function [ranking]= eta_sort(pop,Eg,Eh)
f = pop.f;
g = pop.g;
h = pop.h;
G = sum(max(0,g-Eg*ones(size(g))),1);
H = sum(max(0,abs(h)-(Eh*ones(size(h))+0.0001)),1);
conv = G+H;
ranking = eps_sort(f,conv,0);
end
