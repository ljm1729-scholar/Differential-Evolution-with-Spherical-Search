function Draw_The_3DRight_Optimizing_Process_v2(History,lb,ub,option,name)

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
Draw_figure=figure(100000);
clf
tile=tiledlayout(1,1);
% 
generation_length = max(size(History.obj));
PopulationVector = zeros(generation_length+1,1); PopulationVector(1)=0;
for i=1:generation_length
    PopulationVector(i+1) = length(History.obj{i});
end
CumsumPopulationVector = cumsum(PopulationVector);

Plot3Color = [linspace(0,1,generation_length)',zeros(generation_length,1),linspace(1,0,generation_length)'];
VisualizationMatrix = zeros(CumsumPopulationVector(end),6);
for i=1:generation_length
%     try
        r = vecnorm(History.pop{i},2,2);
        
        Ntheta = zeros(length(History.obj{i}),History.Dim-1);
        for j=1:History.Dim-1
            [Ntheta(:,j),~]=cart2pol(History.pop{i}(:,j+1),History.pop{i}(:,j));
        end
        theta = mean(Ntheta,2);
        [PlotX,PlotY] = pol2cart(theta,r);
        

        % VisualizationMatrix(CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1),:) = [PlotX, PlotY, i*ones(PopulationVector(i+1),1), Plot3Color(i,:).*ones(PopulationVector(i+1),1)];
        VisualizationMatrix(CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1),:) = [History.pop{i}(:,1), History.pop{i}(:,2), i*ones(PopulationVector(i+1),1), Plot3Color(i,:).*ones(PopulationVector(i+1),1)];

%     catch
%         VisualizationMatrix(CumsumPopulationVector(i)+1:CumsumPopulationVector(i+1),:) = [History.obj{i}, History.con{i}, i*ones(PopulationVector(i+1),1), Plot3Color(i,:).*ones(PopulationVector(i+1),1)];
%     end
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
            p1 = scatter3(VisualizationMatrix(:,1),VisualizationMatrix(:,2),VisualizationMatrix(:,3),4,VisualizationMatrix(:,4:6))
            colormap(Plot3Color)
            colorbar

            xlabel('X axis')
            ylabel('Y axis')
            zlabel('Generation')
            title('Low dimentionalize')
            set(gca,'YScale','linear','View',[30 70])
%             
            %drawnow
            %Figure_struct(i_frame) = getframe(Draw_figure);
            pause(0.001)
            
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
        hold on
        for i=1:History.iter
        plot(History.obj{i},History.con{i}+1.0e-8,'o','Color',[0.8,0.8,0.8],'MarkerFaceColor',[0.8,0.8,0.8],'MarkerSize',5)
        end
        xlabel('Objective Functional value')
        ylabel('Total Constraint value')
        zlabel('Generation')
        
        set(gca,'YScale','log')
end