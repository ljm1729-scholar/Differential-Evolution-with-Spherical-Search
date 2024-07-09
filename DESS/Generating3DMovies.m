 tic
timestone=toc
% for i=[1,3,4,5,6,11,12,14,15,16,22,24,26,27,28,33,44,46,47,48,49,50,51,56]
% for i=[2,7,8,9,10,13,17,18,19,20,21,23,25,29,30,31,32]
for i=[15]
close all
    timestone=[timestone,toc];


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

        
    if D<=10
        MaxEvals=1e+5;
        SASS_rate=0.3;
    elseif D<=30
        MaxEvals=2e+5;
        SASS_rate=0.4;
    elseif D<=50
        MaxEvals=4e+5;
        SASS_rate=0.9;
    elseif D<=150
        MaxEvals=8e+5;
        SASS_rate=0.9;
    else
        MaxEvals=1e+6;
        SASS_rate=0.9;
    end
    History=VisualizationHistory{i};
    Draw_The_Left_Optimizing_Process_v2(History,lb,ub,'movie',name);
end