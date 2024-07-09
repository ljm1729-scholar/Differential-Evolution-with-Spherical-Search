function Draw_The_Optimizing_Process_v2(History,lb,ub,option,name)
CenterOfDomain=(ub+lb)/2; % COD
normalizer=(ub-lb)/2;
History.Dim=length(History.pop{1}(1,:));
UnitDeg=2*pi/(2^(History.Dim+1));
for i=1:History.iter
    History.PopForVisualization{i}=(History.pop{i}-CenterOfDomain);
    History.PopForVisualizationNormalized{i}=History.PopForVisualization{i}./normalizer;
    History.PopForVisualizationLocaltion{i}=History.PopForVisualizationNormalized{i}>=0;
    Location=num2str(History.PopForVisualizationLocaltion{i});
    Location(Location==' ')=[];
    Location=reshape(Location,[],History.Dim);
    History.Location{i}=bin2dec(Location);
    History.Deg{i}=-UnitDeg-2*History.Location{i}*UnitDeg;
    History.DistanceFromCOD{i}=log(sum(History.PopForVisualizationNormalized{i}.^2,2).^0.5)/log(History.Dim);
end
Draw_figure=figure;
tile=tiledlayout(1,2);
switch option
    case 'movie'
        % I should initialize the struct
        Figure_struct(History.iter) = struct('cdata',[],'colormap',[]); 
        minobj=[];
        mincon=[];
        for i_frame=1:History.iter
            nexttile(1)
            hold on
            try
                minobj=min([minobj;History.obj{i_frame}]); mincon=min([mincon;History.con{i_frame}]);
            catch
                minobj=min([minobj,History.obj{i_frame}]); mincon=min([mincon,History.con{i_frame}]);
            end
            figure_text=['generation: ',num2str(i_frame),',  best obj.: ',num2str(minobj),',  best con.: ',num2str(mincon)];
            title(tile,figure_text)
            p1=plot(History.obj{i_frame},History.con{i_frame}+1.0e-8,'o','Color',[0.9,0.2,0.2],'MarkerFaceColor',[0.9,0.2,0.2],'MarkerSize',4);
            xlabel('Objective Functional value')
            ylabel('Total Constraint value')
            set(gca,'YScale','log')
            nexttile(2)
            %polaraxes
            p2=polarplot(History.Deg{i_frame},History.DistanceFromCOD{i_frame}+1.0e-8,'o','Color',[0.9,0.2,0.2],'MarkerFaceColor',[0.9,0.2,0.2],'MarkerSize',4);
            hold on
            %xlabel('Objective Functional value')
            %ylabel('Total Constraint value')
            %disp(figure_text)
            drawnow
            Figure_struct(i_frame) = getframe(Draw_figure);
            pause(0.001)
            nexttile(1)
            delete(p1)
            plot(History.obj{i_frame},History.con{i_frame}+1.0e-8,'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',5)
            nexttile(2)
            delete(p2)
            polarplot(History.Deg{i_frame},History.DistanceFromCOD{i_frame}+1.0e-8,'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',4)
        end
        %Figure_struct(History.iter+1:end)=[];
        v = VideoWriter(['[',char(datetime('now','TimeZone','Asia/Seoul','Format','d-MM-y (HH,mm,ss.SSS)')),']',name,'.mp4'],'MPEG-4');
        v.FrameRate=60;
        open(v) 
        writeVideo(v,Figure_struct) 
        close(v)
        %movefile(['[',char(datetime('now','TimeZone','Asia/Seoul','Format','d-MM-y (HH,mm,ss.SSS)')),']',name,'.mp4'],'video')
        
    otherwise
        hold on
        for i=1:History.iter
        plot(History.obj{i},History.con{i}+1.0e-8,'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',5)
        end
        xlabel('Objective Functional value')
        ylabel('Total Constraint value')
        set(gca,'YScale','log')
end