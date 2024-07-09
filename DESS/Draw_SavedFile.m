index=1:57;
for i = index
    load(['[RC',num2str(i),'] [153453(053)].mat'])
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
    Solution = (ub-lb).*rand(1,D)+lb;...
    f_optimalvalue=Par.fsol;
    integrated_converging(History_SASSMODE,lb,ub,name)
    %saveas(gcf,['RC_Visualization/',name,'_integrated.png'])
    exportgraphics(gcf,['RC_Visualization/',name,'_integrated.png'],"Resolution",600)
    pause(0.1)
%     Draw_The_3DLeft_Optimizing_Process_v2(History_SASSMODE,lb,ub,'movie',name)
%     saveas(gcf,['RC_Visualization/',name,'.png'])
%     pause(0.1)
% 
%     Draw_The_2DFeasible_Optimizing_Process_v2(History_SASSMODE,lb,ub,'movie',name)
%     saveas(gcf,['RC_Visualization/',name,'_feasible.png'])
%     pause(0.1)

%     Draw_The_Final_graph(History_SASSMODE,lb,ub,'movie',name)
%     saveas(gcf,['RC_Visualization/',name,'_final.png'])
%     pause(0.1)
end