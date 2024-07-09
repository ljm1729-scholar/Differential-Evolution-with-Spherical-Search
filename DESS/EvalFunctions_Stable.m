function [fitx, fitx_f, fitx_g, fitx_h, x, feasibility, lambda_temp]=EvalFunctions_Stable(f,g,h,x,lambda_input)
PopSize=length(x(:,1));
num_g=length(g(x(1,:))); num_h=length(h(x(1,:)));
%fitx = zeros(Par.PopSize, 1);
fitx_f = zeros(PopSize, 1);
fitx_gs = zeros(PopSize, num_g); %fitx_g = zeros(Par.PopSize, num_g);
fitx_hs = zeros(PopSize, num_h); %fitx_h = zeros(Par.PopSize, num_h);
%Feasibility = zeros(Par.PopSize, 1);
for i = 1 : PopSize
        %[f,g,h] = CEC2017(x(i,:)',num);
        fitx_f(i) = f(x(i,:))';
        fitx_gs(i,:) = g(x(i,:))';
        fitx_hs(i,:) = h(x(i,:))';
end
fitx_g=max(fitx_gs,0); % not a vector
fitx_h=max(abs(fitx_hs)-1e-4,0); % not a vector
fitx_g_NaN=abs(log10(abs(fitx_g))); fitx_g_NaN(isinf(fitx_g_NaN))=0;
fitx_h_NaN=abs(log10(abs(fitx_h))); fitx_h_NaN(isinf(fitx_h_NaN))=0;
feasibility=(sum(fitx_g,2)+sum(fitx_h,2)==0);
lambda_temp=ceil(abs(log10(abs(max(fitx_f))))) + sum(max(max(ceil(fitx_g_NaN)))) + sum(max(max(ceil(fitx_h_NaN))));
lambda=10^(16+lambda_input); lambda=lambda_input;
%lambda=1e10;

%f_main = @(x) f(x) +lambda*10.^min(max(-log(abs(g(x))),0),16)*max(g(x),0)' +lambda*10.^min(max(-log(abs(abs(h(x))-1e-4)),0),16)*max(abs(h(x))-1e-4,0)';%  sum(lambda.^(max(-log(abs(),0)).*max(abs(h(x))-1e-4,0));
%f_main = @(x) f(x) + lambda*sum(max(g(x),0))^2 + lambda*sum(max(abs(h(x))-1e-4,0))^2;
        %[f,g,h] = CEC2017(x(i,:)',num);
fitx = fitx_f'+lambda*sum(fitx_g,2)'+lambda*sum(fitx_h,2)';