function [EA_1, EA_obj1,EA_gx1, EA_hx1, EA_cx1,best_sol,best_of,best_conv,History,Diversity_History] = SASS_BIN(lb,ub,Max_FES)
global initial_flag initial_flag2
initial_flag=0;
initial_flag2=0;

%EvalFunc = @(x,d) EvalFunctionsSS(f,g,h,x,d);
[~,bbb,ccc] = EvalFunc(lb,1);
D = length(lb);
gn = length(bbb);
hn = length(ccc);
I_fno = 1;
Par    = Introd_Par(I_fno);
Par.xmax = ub;
Par.xmin = lb;
Par.n = D;
Par.gn = gn;
Par.hn = hn;
iter   = 0;          
%stream = RandStream('mt19937ar','Seed',sum(100*clock)*run);
%RandStream.setGlobalStream(stream);
const_num = gn + hn; %% constraint number
%% define variables
current_eval=0;             %% current fitness evaluations
PS1 = 60;            %% define PS1
%% ====================== Initalize x ==================================
x=repmat(lb,PS1,1)+repmat((ub-lb),PS1,1).*lhsdesign(PS1,D);
%x   = repmat(Par.xmin,Par.PopSize,1)+repmat((Par.xmax-Par.xmin),Par.PopSize,1).*rand(Par.PopSize,Par.n);
%% calc. fit. and update FES
[fx,gx,hx] = EvalFunc(x,I_fno);
fx = fx';
gx = gx';
hx = hx';
% fx = EvalResult.FVal;
% gx = EvalResult.GVal;
% hx = EvalResult.HVal;

%[fx,gx,hx]   = cec20_func(x,I_fno); fx = fx';
current_eval = current_eval + PS1;
convx = (sum([sum(gx.*(gx>0),1);sum(abs(hx).*(abs(hx)>1e-4),1)],1)./const_num);
%% ================== Initalization of population for SS ===================================
EA_1= x(1:PS1,:);    EA_obj1= fx(1:PS1);   
EA_gx1 = gx(:,1:PS1); EA_hx1 = hx(:,1:PS1); EA_cx1 = convx(1:PS1);
%%%
Pop.x = EA_1';
Pop.f = EA_obj1;
Pop.g = EA_gx1;
Pop.h = EA_hx1;
Pop.conv = EA_cx1;
%% ================== Initalization of \epsilon-constrained ================================
[TC,Eg,Eh,CPg,CPh] = ETAintialization(Pop);
 Eg0 = Eg;
 Eh0 = Eh;  
 

%% ====================== store the best ==================
ranking = eta_sort(Pop,Eg,Eh);
best_sol = Pop.x(:,ranking(1));
best_of  = Pop.f(ranking(1));
best_conv = Pop.conv(ranking(1));
%% ===================== archive data ====================================
arch_rate = 2.6;
archive.NP = arch_rate * PS1; % the maximum size of the archive
archive.pop = zeros(0, D); % the solutions stored in te archive
archive.funvalues = zeros(0, 1); % the function value of the archived solutions
%% ==================== to adapt ci and ri =================================
hist_pos    = 1;
memory_size = 6;
archive_c  = ones(1,memory_size).*0.5;
archive_rp  = ones(1,memory_size).*0.5;
%%
stop_con=0; 
flag = zeros(1,10);
flag1 = 0;
flag2 = 0;
%% main loop
% HistoryArchive_pop=EA_1;
% HistoryArchive_obj=EA_obj1;
% HistoryArchive_cgx=EA_gx1;
% HistoryArchive_chx=EA_hx1;
% HistoryArchive_con=EA_cx1;

History.pop{1}=EA_1;
History.obj{1}=EA_obj1;
History.con{1}=EA_cx1;
History.iter=1;
Diversity_History.iter=1;
while stop_con==0
    %% update Eg and Eh
        if(iter>1 && iter<TC)
          Eg=Eg0.*((1-iter./TC).^CPg);
          Eh=Eh0.*(1-iter./TC).^CPh;
        elseif(iter+1>=TC)
          Eg = 0;
          Eh = 0;
        end 
    iter=iter+1;
    %% ====================== SS main algorithm ============================
    if (current_eval<Max_FES)
            %% apply MODE
            [EA_1, EA_obj1,EA_gx1, EA_hx1, EA_cx1,best_sol,best_of,best_conv,archive,hist_pos,memory_size, archive_c,archive_rp, current_eval] = ...
                SASS( EA_1, EA_obj1,EA_gx1, EA_hx1, EA_cx1,best_sol, best_of, best_conv,archive,hist_pos,memory_size, archive_c,archive_rp,....
                 lb, ub,  D,  PS1,  current_eval, I_fno, iter, const_num, Eg, Eh, Par);
    end
    %% ====================== Repair best solution ========================
    
    problem.constr_fun_name = @EvalFunc;
    problem.gn              = gn;
    problem.hn              = hn;        
    problem.I_fno           = I_fno;
    problem.xmin            = lb;
    problem.xmax            = ub;
    problem.n               = D;
    problem.maxiter         = 5000;
    if  best_conv ~= 0 && mod(iter,D) == 0 && D >= 20 && problem.hn(I_fno) > 0 
          [~,gx,hx]           = EvalFunc(best_sol(:)',I_fno); 
          [new_mutant,fes]     = QNrepair(problem, best_sol', gx, hx);
          best_new_sol        = han_boun_SASS(new_mutant', ub, lb, new_mutant',1,3);
          current_eval        = current_eval+fes;
          [fval, gv, hv]      = EvalFunc(best_new_sol,I_fno);
          best_new_of         = fval;                                                               
          best_new_conv       = (sum([sum(gv.*(gv>0),1); sum(abs(hv).*(abs(hv)>1e-4),1)])./const_num);
          if ((best_of-best_new_of)>0 && best_conv == best_new_conv)|| best_new_conv < best_conv
              best_sol  = best_new_sol;
              best_of   = best_new_of;
              best_conv = best_new_conv;
          end
    end 
    %% ====================== stopping criterion check ====================
    if (current_eval>=Max_FES)
        stop_con=1;
    end
%     %% calculation of Data
%     if flag(1) == 0 && current_eval >= 0.1*Max_FES
%        dta(1,:) = [best_of best_conv];
%        flag(1) = 1;
%     elseif flag(2) == 0 && current_eval >= 0.2*Max_FES
%        dta(2,:) = [best_of best_conv];
%        flag(2) = 1; 
%     elseif flag(3) == 0 && current_eval >= 0.3*Max_FES
%        dta(3,:) = [best_of best_conv];
%        flag(3) = 1;
%     elseif flag(4) == 0 && current_eval >= 0.4*Max_FES
%        dta(4,:) = [best_of best_conv];
%        flag(4) = 1; 
%     elseif flag(5) == 0 && current_eval >= 0.5*Max_FES
%        dta(5,:) = [best_of best_conv];
%        flag(5) = 1;
%     elseif flag(6) == 0 && current_eval >= 0.6*Max_FES
%        dta(6,:) = [best_of best_conv];
%        flag(6) = 1;
%     elseif flag(7) == 0 && current_eval >= 0.7*Max_FES
%        dta(7,:) = [best_of best_conv];
%        flag(7) = 1; 
%     elseif flag(8) == 0 && current_eval >= 0.8*Max_FES
%        dta(8,:) = [best_of best_conv];
%        flag(8) = 1;
%     elseif flag(9) == 0 && current_eval >= 0.9*Max_FES
%        dta(9,:) = [best_of best_conv];
%        flag(9) = 1; 
%     elseif flag(10) == 0 && current_eval >= 1*Max_FES
%        dta(10,:) = [best_of best_conv];
%        flag(10) = 1;
%     end
%     %% calculation of Tab
%     % log global best after having used 10%, and 50% of the evaluation budget
%         if current_eval>= Max_FES*10/100 && flag1==0
%             fit10=best_of;
%             con10=best_conv;
%             [ff,gg,hh]=feval(@cec20_func,best_sol,I_fno);
%             c10_1    = sum(gg>1)                  + sum(abs(hh)>1);
%             c10_2    = sum((gg>0.01) & (gg<1))    + sum(abs(hh)>0.01 & abs(hh)<1);
%             c10_3    = sum((gg>0.0001)&(gg<0.01)) + sum(abs(hh)>0.0001 & abs(hh)<0.01);  
%             flag1=1;
%         elseif current_eval>=Max_FES*50/100 && flag2==0
%             fit50=best_of;
%             con50=best_conv;
%             [ff,gg,hh]=feval(@cec20_func,best_sol,I_fno);
%             c50_1    = sum(gg>1)                  + sum(abs(hh)>1);
%             c50_2    = sum((gg>0.01)&(gg<1))      + sum(abs(hh)>0.01 & abs(hh)<1);
%             c50_3    = sum((gg>0.0001)&(gg<0.01)) + sum(abs(hh)>0.0001 & abs(hh)<0.01)  ;
%             flag2=1;
%         end
%% diversity
if (std(EA_cx1) < 1e-8 && min(EA_cx1) > 0) || (std(EA_obj1) < 1e-8)
%% ====================== Initalize x ==================================
Diversity_History.pop{Diversity_History.iter}=EA_1(1,:);
Diversity_History.obj{Diversity_History.iter}=EA_obj1(1);
Diversity_History.con{Diversity_History.iter}=EA_cx1(1);
Diversity_History.iter=Diversity_History.iter+1;
x   = repmat(lb,PS1,1)+repmat((ub-lb),PS1,1).*rand(PS1,D);
%% calc. fit. and update FES
[fx,gx,hx] = EvalFunc(x,I_fno); fx = fx';
current_eval = current_eval+PS1;
convx = (sum([sum(gx.*(gx>0),1); sum(abs(hx).*(abs(hx)>1e-4),1)],1)./const_num);
%% ================== fill in for each  individual ===================================
%% SS
EA_1= x(1:PS1,:);    EA_obj1= fx(1:PS1); 
EA_gx1 = gx(:,1:PS1); EA_hx1 = hx(:,1:PS1); EA_cx1 = convx(1:PS1);           
end
% HistoryArchive_pop=[HistoryArchive_pop;EA_1];
% HistoryArchive_obj=[HistoryArchive_obj,EA_obj1];
% HistoryArchive_cgx=[HistoryArchive_cgx,EA_gx1];
% HistoryArchive_chx=[HistoryArchive_chx,EA_hx1];
% HistoryArchive_con=[HistoryArchive_con,EA_cx1];
% [~,ia,~]=unique(HistoryArchive_pop,'rows');
% HistoryArchive_pop=HistoryArchive_pop(ia,:);
% HistoryArchive_obj=HistoryArchive_obj(ia);
% HistoryArchive_cgx=HistoryArchive_cgx(:,ia);
% HistoryArchive_chx=HistoryArchive_chx(:,ia);
% HistoryArchive_con=HistoryArchive_con(ia);
% HA_index=sorting(HistoryArchive_obj',HistoryArchive_con');
% HistoryArchive_pop=HistoryArchive_pop(HA_index,:); HistoryArchive_pop=HistoryArchive_pop(1:length(EA_obj1),:);
% HistoryArchive_obj=HistoryArchive_obj(HA_index); HistoryArchive_obj=HistoryArchive_obj(1:length(EA_obj1));
% HistoryArchive_cgx=HistoryArchive_cgx(:,HA_index); HistoryArchive_cgx=HistoryArchive_cgx(:,1:length(EA_obj1));
% HistoryArchive_chx=HistoryArchive_chx(:,HA_index); HistoryArchive_chx=HistoryArchive_chx(:,1:length(EA_obj1));
% HistoryArchive_con=HistoryArchive_con(HA_index); HistoryArchive_con=HistoryArchive_con(1:length(EA_obj1));

History.pop{1+iter}=EA_1;
History.obj{1+iter}=EA_obj1;
History.con{1+iter}=EA_cx1;
History.iter=1+History.iter;

end
if Diversity_History.iter==1
    Diversity_History.pop{Diversity_History.iter}=EA_1;
    Diversity_History.obj{Diversity_History.iter}=EA_obj1;
    Diversity_History.con{Diversity_History.iter}=EA_cx1;
end
% HistoryArchive_pop=[HistoryArchive_pop;EA_1];
% HistoryArchive_obj=[HistoryArchive_obj,EA_obj1];
% HistoryArchive_cgx=[HistoryArchive_cgx,EA_gx1];
% HistoryArchive_chx=[HistoryArchive_chx,EA_hx1];
% HistoryArchive_con=[HistoryArchive_con,EA_cx1];
% [~,ia,~]=unique(HistoryArchive_pop,'rows');
% HistoryArchive_pop=HistoryArchive_pop(ia,:);
% HistoryArchive_obj=HistoryArchive_obj(ia);
% HistoryArchive_cgx=HistoryArchive_cgx(:,ia);
% HistoryArchive_chx=HistoryArchive_chx(:,ia);
% HistoryArchive_con=HistoryArchive_con(ia);
% %% dta size
% while size(dta,1) < 10
%     dta(end+1,:) = dta(end,:);
% end
%     fit100=best_of;
%     con100=best_conv;
%     [ff,gg,hh]=feval(@cec20_func,best_sol,I_fno);
%     c100_1    = sum(gg>1)                   + sum(abs(hh)>1);
%     c100_2    = sum((gg>0.01)&(gg<1))       + sum(abs(hh)>0.01 & abs(hh)<1);
%     c100_3    = sum((gg>0.0001)&(gg<0.01))  + sum(abs(hh)>0.0001 &abs(hh)<0.01);
% 
% 
%     tab = [fit10 con10 c10_1 c10_2 c10_3;
%              fit50 con50 c50_1 c50_2 c50_3;
%              fit100 con100 c100_1 c100_2 c100_3];
% end
