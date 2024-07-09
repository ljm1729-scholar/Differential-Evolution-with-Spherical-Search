function Draw_The_Final_graph(History,lb,ub,option,name)

% CenterOfDomain=(ub+lb)/2; % COD
% normalizer=(ub-lb)/2;
% History.Dim=length(History.pop{1}(1,:));
% UnitDeg=2*pi/(2^(History.Dim+1));
% for i=1:History.iter
%     History.PopForVisualization{i}=(History.pop{i}-CenterOfDomain);
%     History.PopForVisualizationNormalized{i}=History.PopForVisualization{i}./normalizer;
%     History.PopForVisualizationLocaltion{i}=History.PopForVisualizationNormalized{i}>=0;
%     Location=num2str(History.PopForVisualizationLocaltion{i});
%     Location(Location==' ')=[];
%     Location=reshape(Location,[],History.Dim);
%     History.Location{i}=bin2dec(Location);
%     History.Deg{i}=-UnitDeg-2*History.Location{i}*UnitDeg;
%     History.DistanceFromCOD{i}=log(sum(History.PopForVisualizationNormalized{i}.^2,2).^0.5)/log(History.Dim);
% end
Draw_figure=figure(100000);
clf
set(gcf,"Units",'centimeters',"Position",[10,8,10,8])
tile=tiledlayout(1,1);
% 
generation_length = max(size(History.obj));
PopulationVector = zeros(generation_length+1,1); PopulationVector(1)=0;
for i=1:generation_length
    PopulationVector(i+1) = length(History.obj{i});
end
CumsumPopulationVector = cumsum(PopulationVector);
NumberPopulation = CumsumPopulationVector(end);

temp=find(diff(PopulationVector)>0); temp=temp(end);
SASSIndex=sum(PopulationVector(1:temp));

% Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))',zeros(NumberPopulation,1),1-((1:NumberPopulation)/CumsumPopulationVector(end))'];
% Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))'>0.63,zeros(NumberPopulation,1),(1-((1:NumberPopulation)/CumsumPopulationVector(end))')>0.37];
Plot3Color = [0*ones(SASSIndex,1),0*ones(SASSIndex,1),1*ones(SASSIndex,1);...
              1*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1)];


VisualizationMatrix = zeros(CumsumPopulationVector(end),6);
for i=1:generation_length
    VisualIndex=CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1);
    try
        VisualizationMatrix(VisualIndex,:) = [History.obj{i}', History.con{i}', i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    catch
        VisualizationMatrix(VisualIndex,:) = [History.obj{i}, History.con{i}, i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    end
end







switch option
    case 'movie'
        % I should initialize the struct
        % Figure_struct(History.iter) = struct('cdata',[],'colormap',[]); 
        minobj=[];
        mincon=[];
        %for i_frame=1:History.iter
            nexttile(1)
%             hold on
%             try
%                 minobj=min([minobj;History.obj{i_frame}]); mincon=min([mincon;History.con{i_frame}]);
%             catch
%                 minobj=min([minobj,History.obj{i_frame}]); mincon=min([mincon,History.con{i_frame}]);
%             end
%             figure_text=['generation: ',num2str(i_frame),',  best obj.: ',num2str(minobj),',  best con.: ',num2str(mincon)];
%             title(tile,figure_text)
            %p1=plot3(History.obj{i_frame},History.con{i_frame}+1.0e-8,i_frame+0*History.obj{i_frame},'o','Color',Plot3Color(i_frame,:),'MarkerSize',4);
            p1 = scatter3(VisualizationMatrix(:,1),max(VisualizationMatrix(:,2)+eps,1.0e-8),VisualizationMatrix(:,3),4,VisualizationMatrix(:,4:6));
            colormap(Plot3Color)
%             cbar=colorbar;
%             cbar.Label.String = 'Function evaluations'; cbar.Label.Rotation = -90; cbar.Label.VerticalAlignment = 'bottom';
%             cbar.Ruler.TickLabelRotation=-90; cbar.Ruler.TickDirection = 'out'; 
%             set(cbar,'Ticks',[0;0.5;1],'TickLabels',{"Start";"Transition";"End"})

            
            title([name])
            ylim([1.0e-8 inf])
            zlim([0 inf])
            %xlim([-inf inf])
            xlabel('Objective','Rotation',45,'VerticalAlignment','bottom','HorizontalAlignment','center','Units','normalized')
            ylabel('Total constraint','Rotation',-5,'VerticalAlignment','middle')
            zlabel('Generation')
            set(gca,'YScale','log','XScale','log','View',[110 25],'FontSize',10,'XDir','reverse')
%             
            %drawnow
            %Figure_struct(i_frame) = getframe(Draw_figure);
            pause(1)
            
%           
        %end
        %Figure_struct(History.iter+1:end)=[];
        %v = VideoWriter(['[',
        %char(datetime('now','TimeZone','Asia/Seoul','Format','d-MM-y (HH,mm,ss.SSS)')),']',name,'.mp4'],'MPEG-4');
        %v.FrameRate=60;
        %open(v) 
        %writeVideo(v,Figure_struct) 
        %close(v)
        %movefile(['[',char(datetime('now','TimeZone','Asia/Seoul','Format','d-MM-y (HH,mm,ss.SSS)')),']',name,'.mp4'],'video')

    otherwise
        
end