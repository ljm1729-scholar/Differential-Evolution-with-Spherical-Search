  %QN Repair
  function [bestx,fes,succc,f_val,best_new_conv]=QN_repairfunc(I_fno,bestcon,bestx,f,g,h)
    PaR    = Introd_Par(I_fno);
    problem.constr_fun_name = @cec20_func;
    problem.g              = PaR.g;
    problem.h              = PaR.h;   
    problem.gn              = PaR.gn;
    problem.hn              = PaR.hn;
    problem.I_fno           = I_fno;
    problem.xmin            = PaR.xmin;
    problem.xmax            = PaR.xmax;
    problem.n               = PaR.n;
    problem.maxiter         = 3000;

    [fx,gx,hx]           = cec20_func(bestx,I_fno); 
          [new_mutant,fes]     = QNrepair(problem, bestx', gx, hx);
          best_new_sol        = han_boun(new_mutant', PaR.xmax, PaR.xmin, new_mutant',1,3);
          %current_eval        = current_eval+fes;
          %[~, gv, hv]      = cec20_func(best_new_sol,I_fno);
          %best_new_of         = fval;       
          temp_infeasible=EvalFunctions(f,g,h,best_new_sol);
          best_new_conv       = temp_infeasible.InfeasibleVal;
      if isequal(min(bestcon-best_new_conv,0),0)%(isequal(0,best_new_conv))%(isequal(min(bestold-best_new_of,0),0) && isequal(bestcon,best_new_conv))|| isequal(min(bestcon-best_new_conv,0),0)
              bestx  = best_new_sol;
              f_val=temp_infeasible.FVal;
              succc=1;
              %EA_1(2,:)=best_new_sol;
              %disp(best_new_sol);
              %bestold  = best_new_of;
              %bestcon = best_new_conv; 
      else
              succc=0;
              f_val=fx;
      end
