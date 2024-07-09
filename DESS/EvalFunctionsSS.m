function [fitx_f,fitx_g,fitx_h]=EvalFunctionsSS(f,g,h,x,d)
PopSize=length(x(:,1));
num_g=length(g(x(1,:))); num_h=length(h(x(1,:)));

fitx_f = zeros(PopSize, 1);
fitx_gc = zeros(PopSize, num_g);
fitx_hc = zeros(PopSize, num_h);
const_num=num_g+num_h;
for i = 1 : PopSize
        fitx_f(i) = f(x(i,:))';
        fitx_gc(i,:) = g(x(i,:))';
        fitx_hc(i,:) = h(x(i,:))';
end
fitx_g=max(fitx_gc,0); % not a vector
fitx_h=max(abs(fitx_hc)-1e-4,0); % not a vector
InfeasibleVal=sqrt(sum(fitx_g.^2,2)+sum(fitx_h.^2,2));%(sum([sum(fitx_gc'.*(fitx_gc'>0),1);sum(abs(fitx_hc').*(abs(fitx_hc')>1e-4),1)])./const_num);
Infeasibility=[fitx_g~=0,fitx_h~=0];
% %% sorting
% [~,InfeasibleIndex]=sort(InfeasibleVal,'ascend');
% [~,FeasibleIndex]=sort(fitx_f(InfeasibleIndex),'ascend');
% Index=InfeasibleIndex(FeasibleIndex);
%% assign result
result.x = x;
result.FVal = fitx_f;
result.GVal = fitx_g;
result.HVal = fitx_h;
result.InfeasibleVal = InfeasibleVal;
result.Infeasibility = Infeasibility;
result.NumberOfFeasible = sum(InfeasibleVal==0);
% disp(result.NumberOfFeasible)

% result.Feasible_x = result.x(1:result.NumberOfFeasible,:);
% result.Feasible_FVal = result.FVal(1:result.NumberOfFeasible);
% 
% result.Infeasible_x = result.x((result.NumberOfFeasible+1):end,:);
% result.Infeasible_FVal = result.FVal((result.NumberOfFeasible+1):end);
% result.Infeasible_GVal = result.GVal((result.NumberOfFeasible+1):end);
% result.Infeasible_HVal = result.HVal((result.NumberOfFeasible+1):end);
% result.Infeasible_InfeasibleVal = result.InfeasibleVal((result.NumberOfFeasible+1):end);