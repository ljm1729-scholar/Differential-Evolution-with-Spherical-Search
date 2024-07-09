function Draw_The_Optimizing_Process(History,option,name)
Draw_figure=figure;
tile=tiledlayout(1,1);
switch option
    case 'movie'
        hold on
        % I should initialize the struct
        Figure_struct(History.iter) = struct('cdata',[],'colormap',[]); 
        minobj=[];
        mincon=[];
        for i_frame=1:History.iter
            minobj=min([minobj;History.obj{i_frame}]); mincon=min([mincon;History.con{i_frame}]);
            figure_text=['generation: ',num2str(i_frame),',  best obj.: ',num2str(minobj),',  best con.: ',num2str(mincon)];
            title(tile,figure_text)
            p1=plot(History.obj{i_frame},History.con{i_frame}+1.0e-8,'o','Color',[0.9,0.2,0.2],'MarkerFaceColor',[0.9,0.2,0.2],'MarkerSize',4);
            xlabel('Objective Functional value')
            ylabel('Total Constraint value')
            set(gca,'YScale','log')
            %disp(figure_text)
            drawnow
            Figure_struct(i_frame) = getframe(Draw_figure);
            pause(0.001)
            delete(p1)
            plot(History.obj{i_frame},History.con{i_frame}+1.0e-8,'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',5)
        end
        %Figure_struct(History.iter+1:end)=[];
        v = VideoWriter(['[',char(datetime('now','TimeZone','Asia/Seoul','Format','d-MM-y (HH,mm,ss.SSS)')),']',name,'.mp4'],'MPEG-4');
        v.FrameRate=60;
        open(v) 
        writeVideo(v,Figure_struct) 
        close(v)
    otherwise
        hold on
        for i=1:History.iter
        plot(History.obj{i},History.con{i}+1.0e-8,'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',5)
        end
        xlabel('Objective Functional value')
        ylabel('Total Constraint value')
        set(gca,'YScale','log')
end