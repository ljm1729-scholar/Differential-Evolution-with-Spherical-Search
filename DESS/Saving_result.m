result_folder='Result';
if min(size(dir([result_folder])))==0
    mkdir(result_folder)
end

if min(size(dir([result_folder,'/',current_date])))==0
    mkdir([result_folder,'/',current_date])
end

if min(size(dir([result_folder,'/',current_date,'/',simulation_name])))==0
    mkdir([result_folder,'/',current_date,'/',simulation_name])
end

writematrix(summary_result,[result_folder,'/',current_date,'/',simulation_name,'/',num2str(current_time),'_Result_Summary_[from ',num2str(min(index)),' to ',num2str(max(index)),'].xlsx'],'Sheet',1,'Range',['A',num2str(ctr)]);
writematrix(summary_result_AD,[result_folder,'/',current_date,'/',simulation_name,'/',num2str(current_time),'_Result_Summary_AbsoluteDifference_[from ',num2str(min(index)),' to ',num2str(max(index)),'].xlsx'],'Sheet',1,'Range',['A',num2str(ctr)]);
writematrix(save_result,[result_folder,'/',current_date,'/',simulation_name,'/',num2str(current_time),'_Result_[from ',num2str(min(index)),' to ',num2str(max(index)),'].xlsx'],'Sheet',name);
writematrix(save_ranking_cost,[result_folder,'/',current_date,'/',simulation_name,'/',num2str(current_time),'_Result_Format_For_Comparison_[from ',num2str(min(index)),' to ',num2str(max(index)),'].xlsx'],'Sheet',1,'Range',[int2xlcol(ctr),'1']);
writematrix(save_ranking_cv,[result_folder,'/',current_date,'/',simulation_name,'/',num2str(current_time),'_Result_Format_For_Comparison_[from ',num2str(min(index)),' to ',num2str(max(index)),'].xlsx'],'Sheet',2,'Range',[int2xlcol(ctr),'1']);