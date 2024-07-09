for SRate=[0]
addpath(genpath(pwd))
savingoptions
%% Setting the current time
ctr = 0;

%index = [1:33,45:50];
index=59;%[2,7,8,12,15,16,23,24,25,35,36,37,38,39,50,52,53,54]; % 22, 26
format longG;
summary_result=[];
timestone=[];
tic;
global initial_flag
global initial_flag2
for i = index
    timestone=[timestone,toc];
    ctr = ctr+1;

        name = ['RC',num2str(i)];
        fname = ['RC',num2str(i),'_f'];
        gname = ['RC',num2str(i),'_g'];
        hname = ['RC',num2str(i),'_h'];
        X=['f=@',fname,';']; eval(X)
        X=['g=@',gname,';']; eval(X)
        X=['h=@',hname,';']; eval(X)
        Par     = Cal_par(i);
        D       = Par.n;
        gn       = Par.g;
        hn       = Par.h;
        lb    = Par.xmin;
        ub    = Par.xmax;
        Solution = (ub-lb).*rand(1,D)+lb;
        f_optimalvalue=Par.fsol;

        SASS_rate=SRate/10;
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

%[c,ceq] = @mycon06(x);
%%
runs=1;
bestx=zeros(runs,D);
cost=zeros(runs,1);
const_g=zeros(runs,1);
const_h=zeros(runs,1);
for j = 1:runs
  disp([num2str(ctr),'-th function: ',name,'(',num2str(j),'/',num2str(runs),')']);
  [SASS_1, EA_obj1,EA_gx1, EA_hx1, EA_cx1,best_sol,best_of,best_conv,History_SASS,Diversity] = SASS_BIN(i,SASS_rate*MaxEvals);
  SASS_bests=SetInitialPopulaionOfCMODE(History_SASS,length(History_SASS.obj{length(History_SASS.obj)}));
  %SASS_bests=Diversity.pop{1};
  %SR_SASS(j)=(abs(cost(j)-f_optimalvalue)<1e-8);
  [bestx(j,:),~,~,History_MODE]=IMODE_basic_constrained_modv2(f,g,h,length(lb), lb, ub,MaxEvals,SASS_bests,SASS_rate); %recordtemp(:,j)
  cost(j)=real(f(bestx(j,:)));
  %cost(j)=best_of;
  const_g(j)=sum(max(g(bestx(j,:)),0));
  const_h(j)=sum(max(abs(h(bestx(j,:)))-1e-4,0));
  SR(j)=((cost(j)-f_optimalvalue)<1e-8) & ((const_g(j)+const_h(j))==0);
% SR(j)=(abs(cost(j)-f_optimalvalue)<1e-8) & ((const_g(j)+const_h(j))==0); [before]
  if j==1
      History_SASSMODE=MergeTwoHistory(History_SASS,History_MODE);
  end
end
initial_flag=0;
initial_flag2=0;
% VisualizationHistory{i}=History_SASSMODE;
%record{i}=recordtemp;
ResultIndex=sorting(cost,const_g+const_h);
bestx=bestx(ResultIndex,:);
cost=cost(ResultIndex);
const_g=const_g(ResultIndex);
const_h=const_h(ResultIndex);

save_result=[bestx cost const_g const_h];
save_ranking_cost=cost;
save_ranking_cv=(const_g+const_h)/(gn+hn);

Compare=cost;
Worst_err=Compare(end);
Best_err=Compare(1);
Median_err=median(Compare);
Mean_err=mean(Compare);
Std_err=std(Compare);
Number_feasible_solution=length(find(const_g+const_h==0))/runs*100;
Success_rate=sum(SR)/runs*100;
MVR=const_g/length(g(lb));
summary_result=[string(name) Worst_err Best_err Median_err Mean_err Std_err Number_feasible_solution Success_rate];
summary_result_AD=[string(name) Worst_err-f_optimalvalue Best_err-f_optimalvalue Median_err-f_optimalvalue Mean_err-f_optimalvalue Std_err Number_feasible_solution Success_rate];

%disp([bestx cost' const_g' const_h']);
disp([Worst_err Best_err Median_err Mean_err Std_err Number_feasible_solution Success_rate]);
Saving_result
if j==runs
save(['[',name,'] ',current_time,'.mat'],'History_SASSMODE')
Draw_The_3DRight_Optimizing_Process_v3(History_SASSMODE,lb,ub,'movie',name)
saveas(gcf,['RC_Visualization/',name,'test.png'])
pause(0.1)
end
end

% save([current_time,'Jongmin.mat'])
timestone=[timestone,toc]
diary off


%movefile(log_file_name,['Result/',current_date,'/',simulation_name])
end
