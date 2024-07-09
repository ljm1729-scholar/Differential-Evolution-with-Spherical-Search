function [f1,g] = testf(x)
% Calculate objective f
global I_fno f
f1 = f(x);

if nargout > 1 % gradient required
    g = Jocob_Ana(x,I_fno);
end
end