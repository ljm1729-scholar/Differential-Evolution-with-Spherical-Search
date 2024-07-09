function Draw_The_2DFeasible_Optimizing_Process_v2(History,lb,ub,option,name)

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

generation_length = max(size(History.obj));
PopulationVectorSASS = zeros(generation_length+1,1); PopulationVectorSASS(1)=0;
PopulationVector = zeros(generation_length+1,1); PopulationVector(1)=0;
minValue=Inf;
for i=1:generation_length
    PopulationVectorSASS(i+1) = length(History.obj{i});
    FeasiblePoints=(History.con{i}==0);
    History.con{i}=History.con{i}(FeasiblePoints);
    History.obj{i}=History.obj{i}(FeasiblePoints);
    History.pop{i}=History.pop{i}(FeasiblePoints,:);
    PopulationVector(i+1) = length(History.obj{i});
    try 
        minValue=mink(unique([minValue(1);minValue(end);History.obj{i}]),2);
    catch 
        minValue=mink(unique([minValue(1),minValue(end),History.obj{i}]),2);
    end
end
min1Value=minValue(1); epseps=abs(diff(minValue));
unit = min(1,max(epseps,0));
for i=1:generation_length
    History.obj{i}=History.obj{i}-min1Value+unit;
end
CumsumPopulationVector = cumsum(PopulationVector);
NumberPopulation = CumsumPopulationVector(end);
%temp=find(diff(PopulationVectorSASS)>0); temp=temp(end);
%SASSIndex=sum(PopulationVectorSASS(1:temp));

SASSIndex=sum(PopulationVector(1:(min(find(diff(PopulationVectorSASS)<0))-1)));

% Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))',zeros(NumberPopulation,1),1-((1:NumberPopulation)/CumsumPopulationVector(end))'];
% Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))'>0.63,zeros(NumberPopulation,1),(1-((1:NumberPopulation)/CumsumPopulationVector(end))')>0.37];
Plot3Color = [0*ones(SASSIndex,1),0*ones(SASSIndex,1),1*ones(SASSIndex,1);...
              1*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1)];


VisualizationMatrix = zeros(CumsumPopulationVector(end),5);
for i=1:generation_length
    VisualIndex=CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1);
    try
        VisualizationMatrix(VisualIndex,:) = [History.obj{i}', i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    catch
        VisualizationMatrix(VisualIndex,:) = [History.obj{i}, i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    end
end


VisualizationMatrix(SASSIndex+1:SASSIndex+10,:)=[];



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
            p1 = scatter(VisualizationMatrix(:,1),VisualizationMatrix(:,2),4,VisualizationMatrix(:,3:5));
            colormap(Plot3Color)
%             cbar=colorbar;
%             cbar.Label.String = 'Function evaluations'; cbar.Label.Rotation = -90; cbar.Label.VerticalAlignment = 'bottom';
%             cbar.Ruler.TickLabelRotation=-90; cbar.Ruler.TickDirection = 'out'; 
%             set(cbar,'Ticks',[0;0.5;1],'TickLabels',{"Start";"Transition";"End"})

            
            title([name])
            ylim([1 inf])
            xlim([10^(min(0,floor(log10(unit)))) inf])
            xlabel('Absolute error in objective')
            ylabel('Generation')
            set(gca,'XScale','log','FontSize',10,'FontName','Times')
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