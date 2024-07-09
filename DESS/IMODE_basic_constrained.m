function  [bestx_final, bestold_final, res_det,History] = IMODE_basic_constrained(f,g,h,D, Space_min, Space_max,max_iter)

Par.n=D;
Par.n_opr=4;  %% number of operators 

if ~exist('max_iter','var')
    if Par.n == 1
        Par.Max_FES = 10000;
        Par.Gmax = 500;
    elseif Par.n == 2
        Par.Max_FES = 20000;
        Par.Gmax = 1000;
    elseif Par.n==5
        Par.CS=100; %% cycle
        Par.Max_FES=50000;
        Par.Gmax = 2163;
    elseif Par.n==10
        Par.CS=100; %% cycle
        Par.Gmax = 2745;
        Par.Max_FES=1000000;
    elseif Par.n==15
        Par.CS=100; %% cycle
        Par.Gmax = 3022;
        Par.Max_FES=3000000;
    elseif Par.n==20
        Par.Max_FES=10000000;
        Par.CS=100; %% cycle
        Par.Gmax = 3401;
    else
        error('Dimension D can only be 1, 2, 5, 10, 15, 20')
    end
else
    Par.Max_FES = max_iter;
    Par.CS=100; %% cycle
    Par.Gmax = 500*Par.n;
end

Par.xmin = Space_min;
Par.xmax = Space_max;

Par.PopSize=6*Par.n*Par.n; %% population size
Par.MinPopSize=4;

Par.prob_ls=0.1;

%% printing the detailed results- this will increase the computational time
Par.Printing=1; %% 1 to print; 0 otherwise

run = 1;
iter=0;             %% current generation
current_eval=0;             %% current fitness evaluations
PS1=Par.PopSize;            %% define PS1

%% Initalize x 

x=repmat(Par.xmin,Par.PopSize,1)+repmat((Par.xmax-Par.xmin),Par.PopSize,1).*lhsdesign(Par.PopSize,Par.n);
%[size_Sass,~]=size(SASS_1);
%[size_x,~]=size(x);

%x(1:size_Sass,:)=SASS_1;
% DomainIndex=repmat(char(0),Par.Max_FES,1);
% CenterOfDomain=(Par.xmax+Par.xmin)/2;
% TempDomainIndex=num2str(((x-CenterOfDomain)>=0)+0);
% TempDomainIndex(isspace(TempDomainIndex))=[];
% DomainIndex(current_eval+1:PS1,:)=reshape(TempDomainIndex,[],D);

%% calc. fit. and update FES

EvalResult = EvalFunctions(f,g,h,x);

current_eval =current_eval + Par.PopSize;
res_det= min(repmat(min(EvalResult.FVal),Par.PopSize,1),EvalResult.FVal); %% used to record the convergence

%% store the best
index=sorting(EvalResult.FVal,EvalResult.InfeasibleVal);
bestcon = EvalResult.InfeasibleVal(index(1));
bestold = EvalResult.FVal(index(1));
bestx = EvalResult.x(index(1),:);

%% IMODE
EA_1= EvalResult.x(1:PS1,:);
EA_obj1= EvalResult.FVal(1:PS1);
EA_obj2= EvalResult.InfeasibleVal(1:PS1,:);
EA_1old= EvalResult.x(randperm(PS1),:);

%% ===== prob. of each DE operator =====
probDE1=1./Par.n_opr .* ones(1,Par.n_opr);

%% ===================== archive data ====================================
arch_rate=2.6;
archive.NP = arch_rate * PS1; % the maximum size of the archive
archive.pop = zeros(0, Par.n); % the solutions stored in the archive
archive.funvalues = zeros(0, 1); % the function value of the archived solutions

HistoryArchive.NP = arch_rate * PS1; % the maximum size of the archive
HistoryArchive.pop = zeros(0, Par.n); % the solutions stored in the archive
HistoryArchive.funvalues = zeros(0, 1); % the function value of the archived solutions
HistoryArchive.convalues = zeros(0, 1);

%% ==================== to adapt CR and F =================================
hist_pos=1;
memory_size=20*Par.n;
archive_f= ones(1,memory_size).*0.2;
archive_Cr= ones(1,memory_size).*0.2;
archive_T = ones(1,memory_size).*0.1;
archive_freq = ones(1, memory_size).*0.5;

%%
stop_con=0;
avgFE=Par.Max_FES; 
InitPop=PS1; 
thrshold=1e-08;

cy=0;
indx = 0;
F = normrnd(0.5,0.15,1,PS1);
cr= normrnd(0.5,0.15,1,PS1);
History.pop{1}=EA_1;
History.obj{1}=EA_obj1;
History.con{1}=EA_obj2;
History.iter=1;
%% main loop
while stop_con==0
    %lambda=100+(10^(lambda_input))*(current_eval/Par.Max_FES)+(1-current_eval/Par.Max_FES)*10^(30+lambda_input);
    iter=iter+1;
    cy=cy+1; % to control CS
    
    %% ======================Applying IMODE ============================
    if (current_eval<Par.Max_FES)
            
            %% =============================== Linear Reduction of PS1 ===================================================
            UpdPopSize = round((((Par.MinPopSize - InitPop) / Par.Max_FES) * current_eval) + InitPop);
            if PS1 > UpdPopSize
                reduction_ind_num = PS1 - UpdPopSize;
                if PS1 - reduction_ind_num <  Par.MinPopSize
                    reduction_ind_num = PS1 - Par.MinPopSize;
                end
                %% remove the worst ind.
                for r = 1 : reduction_ind_num
                    vv=PS1;
                    EA_1(vv,:)=[];
                    EA_1old(vv,:)=[];
                    EA_obj1(vv)=[];
                    EA_obj2(vv,:)=[];
                    PS1 = PS1 - 1;
                end
                archive.NP = round(arch_rate * PS1);
                if size(archive.pop, 1) > archive.NP
                    rndpos = randperm(size(archive.pop, 1));
                    rndpos = rndpos(1 : archive.NP);
                    archive.pop = archive.pop(rndpos, :);
                    archive.funvalues = archive.funvalues(rndpos, :);
                end
                HistoryArchive.NP = round(arch_rate * PS1);
                if size(HistoryArchive.pop, 1) > HistoryArchive.NP
                    numpos = (1 : ceil(HistoryArchive.NP));
                    HistoryArchive.pop = HistoryArchive.pop(numpos, :);
                    HistoryArchive.funvalues = HistoryArchive.funvalues(numpos, :);
                    HistoryArchive.convalues = HistoryArchive.convalues(numpos, :);
                end
            end
            

    
            
            %% apply IMODE
            [EA_1, EA_1old, EA_obj1,EA_obj2,probDE1,bestcon,bestold,bestx,HistoryArchive,archive,hist_pos,memory_size, archive_f,archive_Cr,archive_T,archive_freq, current_eval,res_det,F,cr,IMODEResult,History,NumOffeasible] = ...
                IMODE_constrained(f,g,h,EA_1,EA_1old, EA_obj1,EA_obj2,probDE1,bestcon,bestold,bestx,HistoryArchive,archive,hist_pos,memory_size, archive_f,archive_Cr,archive_T,....
                archive_freq, Par.xmin, Par.xmax,  Par.n,  PS1,  current_eval,res_det,Par.Printing,Par.Max_FES, Par.Gmax, iter,F,cr,History);
            
            %disp([num2str(IMODEResult.NumberOfFeasible),'    ',num2str(round(100*(IMODEResult.NumberOfFeasible/length(IMODEResult.FVal))))])
   
    %%
%     %QN Repair
%     PaR    = Introd_Par(I_fno);
%     problem.constr_fun_name = @cec20_func;
%     problem.g              = PaR.g;
%     problem.h              = PaR.h;   
%     problem.gn              = PaR.gn;
%     problem.hn              = PaR.hn;
%     problem.I_fno           = I_fno;
%     problem.xmin            = PaR.xmin;
%     problem.xmax            = PaR.xmax;
%     problem.n               = PaR.n;
%     problem.maxiter         = 1000;
%     const_num = PaR.gn + PaR.hn;
%     %NumOffeasible=sum(EA_obj2==0);
%     if  ((~isequal(bestcon,0)) &&  (~isequal(problem.h,0)) )
%     [~,gx,hx]           = cec20_func(bestx,I_fno); 
%           [new_mutant,fes]     = QNrepair(problem, bestx', gx, hx);
%           best_new_sol        = han_boun(new_mutant', Par.xmax, Par.xmin, new_mutant',1,3);
%           current_eval        = current_eval+fes;
%           [fval, gv, hv]      = cec20_func(best_new_sol,I_fno);
%           best_new_of         = fval;                                                               
%           best_new_conv       = (sum([sum(gv.*(gv>0),1); sum(abs(hv).*(abs(hv)>1e-4),1)])./const_num);
%           if isequal(0,best_new_conv)%(isequal(min(bestold-best_new_of,0),0) && isequal(bestcon,best_new_conv))|| isequal(min(bestcon-best_new_conv,0),0)
%               %bestx  = best_new_sol;
%               EA_1(2,:)=best_new_sol;
%               disp(best_new_sol);
%               %bestold  = best_new_of;
%               %bestcon = best_new_conv;
%           end
%     end
%             
            
            

     %% ============================ LS2 ====================================
    if current_eval>0.85*Par.Max_FES && current_eval<Par.Max_FES
        if rand<Par.prob_ls
            old_fit_eva=current_eval;
            [bestx,bestold,bestcon,current_eval,succ] = LS2_constrained_mod(f,g,h,bestx,bestold,Par,current_eval,Par.Max_FES,Par.xmin,Par.xmax);
            if succ==1 %% if LS2 was successful
                EA_1(PS1,:)=bestx';
                EA_obj1(PS1)=bestold;
                EA_obj2(PS1)=bestcon;
                sort_indx=sorting(EA_obj1,EA_obj2);
                EA_obj1=EA_obj1(sort_indx);
                EA_obj2=EA_obj2(sort_indx);
                EA_1= EA_1(sort_indx,:);
                
%                 EA_2=repmat(EA_1(1,:), PS2, 1);
%                 [setting]= init_cma_par(setting,EA_2, Par.n, PS2);
%                 setting.sigma=1e-05;
%                 EA_obj2(1:PS2)= EA_obj1(1);
                Par.prob_ls=0.1;
            else
                Par.prob_ls=0.01; %% set p_LS to a small value it  LS was not successful
            end
            %% record best fitness -- set Par.Printing==0 if not
            if Par.Printing==1
                res_det= [res_det;repmat(bestold,(current_eval-old_fit_eva),1)];
            end
            
        end
    end
    History.pop{1+iter}=EA_1;
    History.obj{1+iter}=EA_obj1;
    History.con{1+iter}=EA_obj2;
    History.iter=1+iter;
    %% ====================== best point in the History ===================
    if (HistoryArchive.convalues(1)>=bestcon) && (HistoryArchive.funvalues(1)>=bestold)
        HistoryArchive.pop=[bestx;HistoryArchive.pop];
        HistoryArchive.funvalues=[bestold;HistoryArchive.funvalues];
        HistoryArchive.convalues=[bestcon;HistoryArchive.convalues];
    end
    %HistoryArchive = updateHistoryArchive(HistoryArchive, EA_1, EA_obj1, EA_obj2);
%     ArchiveIndex=sorting(HistoryArchive.funvalues,HistoryArchive.convalues);
%     HistoryArchive.pop=HistoryArchive.pop(ArchiveIndex,:);
%     HistoryArchive.funvalues=HistoryArchive.funvalues(ArchiveIndex,:);
%     HistoryArchive.convalues=HistoryArchive.convalues(ArchiveIndex,:);
    bestx_final=HistoryArchive.pop(1,:);%bestx;%
    bestold_final=HistoryArchive.funvalues(1,:);%bestold;%
    bestcon_final=HistoryArchive.convalues(1,:);%bestcon;%
    %% ====================== stopping criterion check ====================
    if (current_eval>=Par.Max_FES-4*UpdPopSize)
        stop_con=1;
        avgFE=current_eval;
    end
    
%     if ( (abs (Par.f_optimal - bestold)<= thrshold))
%         stop_con=1;
%         bestold=Par.f_optimal;
%         avgFE=current_eval;
%     end
    
    %% =============================== Print ==============================
    %          fprintf('current_eval\t %d fitness\t %d \n', current_eval, abs(Par.f_optimal-bestold));
    if stop_con
        %com_time= toc;%cputime-start_time;
 %       fprintf('solution\t %d  %d, fitness\t %d, avg.FFE\t %d\t\n', bestx, bestold,avgFE);
        %outcome= abs(Par.f_optimal-bestold);
%         if (min (bestx))< -100 || (max(bestx))>100 %% make sure  that the best solution is feasible
%             fprintf('in problem: %d, there is  a violation',I_fno);
%         end
        %SR= (outcome==0);
    end
    end
end