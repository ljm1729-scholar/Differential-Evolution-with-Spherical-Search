function [fitx_f,fitx_g,fitx_h] = EvalFunc(x,d)

f = @(x) x(:,1).^2 +x(:,2).^2;
g = @(x) 1-x(:,1);
h = @(x) 1-x(:,2);

[fitx_f,fitx_g,fitx_h]=EvalFunctionsSS(f,g,h,x,d);