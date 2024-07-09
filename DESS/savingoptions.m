current_date=char(datetime('now','TimeZone','Asia/Seoul','Format','yMMdd'));
current_time=char(datetime('now','TimeZone','Asia/Seoul','Format','[HHmmss(sss)]'));
simulation_name='ApplicationTest';
log_file_name=[current_date,'_',current_time,'_',simulation_name,'.log'];
%diary(log_file_name)