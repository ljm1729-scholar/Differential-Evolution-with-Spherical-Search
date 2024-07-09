function Y = DESS %(f,g,h,lb,ub)

f = @(x) x(:,1).^2 +x(:,2).^2;
g = @(x) 1-x(:,1);
h = @(x) 1-x(:,2);
lb = [-10,-10];
ub = [10,10];

D = length(lb);
gn = length(g(lb));
hn = length(h(lb));

SASS_rate=0.7/10;
if D<=10
    MaxEvals=1e+5;
elseif D<=30
    MaxEvals=2e+5;
elseif D<=50
    MaxEvals=4e+5;
elseif D<=150
    MaxEvals=8e+5;
else
    MaxEvals=1e+6;
end


[SASS_1, EA_obj1,EA_gx1, EA_hx1, EA_cx1,best_sol,best_of,best_conv,History_SASS,Diversity] = SASS_BIN(lb,ub,SASS_rate*MaxEvals);
SASS_bests=SetInitialPopulaionOfCMODE(History_SASS,length(History_SASS.obj{length(History_SASS.obj)}));

[bestx,~,~,History_MODE]=IMODE_basic_constrained_modv2(f,g,h,length(lb), lb, ub,MaxEvals,SASS_bests,SASS_rate); %recordtemp(:,j)
x=1;