function integrated_converging(History,lb,ub,name)

Draw_figure=figure(100000);
clf
set(gcf,"Units",'centimeters',"Position",[10,8,20,8])
tile=tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
%title(tile,name)
%%
generation_length = max(size(History.obj));
PopulationVectorSASS = zeros(generation_length+1,1); PopulationVectorSASS(1)=0;
PopulationVector = zeros(generation_length+1,1); PopulationVector(1)=0;
minValue=Inf;
for i=1:generation_length
    PopulationVectorSASS(i+1) = length(History.obj{i});
    FeasiblePoints=(History.con{i}==0);
    History.conmodi{i}=History.con{i}(FeasiblePoints);
    History.objmodi{i}=History.obj{i}(FeasiblePoints);
    History.popmodi{i}=History.pop{i}(FeasiblePoints,:);
    PopulationVector(i+1) = length(History.objmodi{i});
    try 
        minValue=mink(unique([minValue(1);minValue(end);History.objmodi{i}]),2);
    catch 
        minValue=mink(unique([minValue(1),minValue(end),History.objmodi{i}]),2);
    end
end
min1Value=minValue(1); epseps=abs(diff(minValue));
unit = min(1,max(epseps,0));
for i=1:generation_length
    History.objmodi{i}=History.objmodi{i}-min1Value+unit;
end
CumsumPopulationVector = cumsum(PopulationVector);
NumberPopulation = CumsumPopulationVector(end);
%temp=find(diff(PopulationVectorSASS)>0); temp=temp(end);
%SASSIndex=sum(PopulationVectorSASS(1:temp));

SASSIndex=sum(PopulationVector(1:(min(find(diff(PopulationVectorSASS)<0))-1)));

% Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))',zeros(NumberPopulation,1),1-((1:NumberPopulation)/CumsumPopulationVector(end))'];
% Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))'>0.63,zeros(NumberPopulation,1),(1-((1:NumberPopulation)/CumsumPopulationVector(end))')>0.37];
Plot3Color = [0*ones(SASSIndex,1),0*ones(SASSIndex,1),1*ones(SASSIndex,1);...
              0*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1),1*ones(NumberPopulation-SASSIndex,1)];


VisualizationMatrix = zeros(CumsumPopulationVector(end),5);
for i=1:generation_length
    VisualIndex=CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1);
    try
        VisualizationMatrix(VisualIndex,:) = [History.objmodi{i}', i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    catch
        VisualizationMatrix(VisualIndex,:) = [History.objmodi{i}, i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    end
end
%%
% I should initialize the struct
        % Figure_struct(History.iter) = struct('cdata',[],'colormap',[]); 
        minobj=[];
        mincon=[];
        %for i_frame=1:History.iter
            nexttile(2)
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

            

            ylim([1 inf])
            try
                xlim([10^(min(0,floor(log10(unit)))) inf])
            catch
                xlim([0 1])
            end
            xlabel('Absolute error')
            ylabel('Generation')
            %title('Feasible area')
            set(gca,'XScale','log','FontSize',10,'FontName','Times')
%             
            %drawnow
            %Figure_struct(i_frame) = getframe(Draw_figure);
            pause(0.1)


%%
generation_length = max(size(History.obj));
PopulationVectorSASS = zeros(generation_length+1,1); PopulationVectorSASS(1)=0;
PopulationVector = zeros(generation_length+1,1); PopulationVector(1)=0;
minValue=Inf;
for i=1:generation_length
    PopulationVectorSASS(i+1) = length(History.obj{i});
    PopulationVector(i+1) = length(History.obj{i});
    try 
        minValue=mink(unique([minValue(1);minValue(end);History.obj{i}]),2);
    catch 
        minValue=mink(unique([minValue(1),minValue(end),History.obj{i}]),2);
    end
end
min1Value=minValue(1); epseps=abs(diff(minValue));
unit = min(1,max(epseps,0));
% for i=1:generation_length
%     History.obj{i}=History.obj{i}-min1Value+unit;
% end


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
              0*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1),1*ones(NumberPopulation-SASSIndex,1)];


VisualizationMatrix = zeros(CumsumPopulationVector(end),6);
for i=1:generation_length
    VisualIndex=CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1);
    try
        VisualizationMatrix(VisualIndex,:) = [History.obj{i}', History.con{i}', i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    catch
        VisualizationMatrix(VisualIndex,:) = [History.obj{i}, History.con{i}, i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
    end
end
%%
% 
% generation_length = max(size(History.obj));
% PopulationVector = zeros(generation_length+1,1); PopulationVector(1)=0;
% for i=1:generation_length
%     PopulationVector(i+1) = length(History.obj{i});
% end
% CumsumPopulationVector = cumsum(PopulationVector);
% NumberPopulation = CumsumPopulationVector(end);
% 
% temp=find(diff(PopulationVector)>0); temp=temp(end);
% SASSIndex=sum(PopulationVector(1:temp));
% 
% % Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))',zeros(NumberPopulation,1),1-((1:NumberPopulation)/CumsumPopulationVector(end))'];
% % Plot3Color = [((1:NumberPopulation)/CumsumPopulationVector(end))'>0.63,zeros(NumberPopulation,1),(1-((1:NumberPopulation)/CumsumPopulationVector(end))')>0.37];
% Plot3Color = [0*ones(SASSIndex,1),0*ones(SASSIndex,1),1*ones(SASSIndex,1);...
%               1*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1),0*ones(NumberPopulation-SASSIndex,1)];
% 
% 
% VisualizationMatrix = zeros(CumsumPopulationVector(end),6);
% for i=1:generation_length
%     VisualIndex=CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1);
%     try
%         VisualizationMatrix(VisualIndex,:) = [History.pop{i}(:,1)', History.pop{i}(:,2)', i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
%     catch
%         VisualizationMatrix(VisualIndex,:) = [History.pop{i}(:,1), History.pop{i}(:,2), i*ones(PopulationVector(i+1),1), Plot3Color(VisualIndex,:)];
%     end
% end
%%

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

            

            xlim([-inf inf])
            ylim([1.0e-8 inf])
            zlim([0 inf])
            %xlim([-inf inf])
            xlabel('$f (\vec x)$','Rotation',45,'VerticalAlignment','bottom','HorizontalAlignment','center','Interpreter','latex') % 
            ylabel('$c_v (\vec x)$','Rotation',-5,'VerticalAlignment','middle','Interpreter','latex')
            zlabel('Generation')
            %title('3D constraint-objective plot')
            set(gca,'YScale','log','XScale','log','View',[110 25],'FontSize',10,'XDir','reverse','FontName','Times')
%             
            %drawnow
            %Figure_struct(i_frame) = getframe(Draw_figure);
            pause(1)
