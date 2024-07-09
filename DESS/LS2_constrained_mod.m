%% ============EBOwithCMAR ============
% Should you have any queries, please contact
% Mr.Abhishek Kumar
% emailid: abhishek.kumar.eee13@iitbhu.ac.in
% =========================================================================
function [x,f,bestcon,current_eval,succ] = LS2_constrained_mod(func,g,h,bestx,f,Par,current_eval,Max_FES,xmin,xmax)
Par.LS_FE=min(ceil(20.0000e-003*Max_FES ),(Max_FES-current_eval));
%Par.LS_FE=ceil(20.0000e-003*Max_FES ); %% Max FFEs_LS
% Par.LS_FE = 20*Par.n;
%sqp, interior-point, active-set
try
options=optimoptions('fmincon','Display','off','algorithm','interior-point','UseParallel',false,'MaxFunEvals',Par.LS_FE,'ConstraintTolerance',1.0e-4,'HonorBounds',true) ;

%     'BarrierParamUpdate','predictor-corrector',...
%     'SubproblemAlgorithm','factorization',...

%     'HessianApproximation','bfgs','HonorBounds',true) ;
c = @(x) g(x);
ceq = @(x) h(x);
nonlinfcn = @(x) deal(c(x),ceq(x));

[Xsqp, FUN , ~ , details]=fmincon(func, bestx(1,:),[],[],[],[],xmin,xmax,nonlinfcn,options);
catch
    options=optimoptions('fmincon','Display','off','algorithm','interior-point','UseParallel',false,'MaxFunEvals',Par.LS_FE,'ConstraintTolerance',1.0e-4,'HonorBounds',false) ;

%     'BarrierParamUpdate','predictor-corrector',...
%     'SubproblemAlgorithm','factorization',...

%     'HessianApproximation','bfgs','HonorBounds',true) ;
c = @(x) g(x);
ceq = @(x) h(x);
nonlinfcn = @(x) deal(c(x),ceq(x));

[Xsqp, FUN , ~ , details]=fmincon(func, bestx(1,:),[],[],[],[],xmin,xmax,nonlinfcn,options);
end
EvalResult=EvalFunctions(func,g,h,[bestx;Xsqp]);
%% check if there is an improvement in the fitness value and update P_{ls}


if ((EvalResult.InfeasibleVal(2)<EvalResult.InfeasibleVal(1)) || ((EvalResult.FVal(2) < EvalResult.FVal(1)) && (EvalResult.InfeasibleVal(2)==0)))
    x(1,:)=Xsqp;
    f=EvalResult.FVal(2);
    bestcon=EvalResult.InfeasibleVal(2);
    succ=1;
else
    succ=0;
    x=bestx;  
    bestcon=EvalResult.InfeasibleVal(1);
end

%% update FFEs
current_eval=current_eval+details.funcCount+2;
% details.funcCount
end


