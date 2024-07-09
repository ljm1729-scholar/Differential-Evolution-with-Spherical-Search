%%
load Without_infeasible_operator.mat
%%
% for j=1:History_SASSMODE.iter
%     try
%         [~,index]=min(sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j}'));
%     catch
%         [~,index]=min(sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j}));
%     end
%     BestSoFar(j,:)=History_SASSMODE.pop{j}(index,:);
% end

for j=1:History_SASSMODE.iter
    try
        index=sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j}');
    catch
        index=sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j});
    end
    BestSoFar(j,:)=History_SASSMODE.pop{j}(4,:);
end


rng(3)
xlimit=[-4,4];
ylimit=[-1,4.5];
randX=(xlimit(2)-xlimit(1))*rand(1,100)+xlimit(1);
randY=(ylimit(2)-ylimit(1))*rand(1,100)+ylimit(1);


%ff=@(x,y) sin(x/2).^2 + y.*cos(y/2).^4;% +2*(y-2).^2 -2*(x-2).^4+x.*y;
ff=@(x,y) sin(x/2).^2 + y.*cos(y/2).^4;

gg=@(x,y) x.^2+(y-2).^2-4.1;
[cX,cY,cZ]=cylinder(sqrt(4.1),100);
cY=cY+2; cZ=1.4*cZ;


xx=linspace(xlimit(1),xlimit(2),101);
yy=linspace(ylimit(1),ylimit(2),1001);

FVal=ff(randX,randY);
CVal=gg(randX,randY);
IndexFeasible=gg(randX,randY)<=0;

FontSSize= 13;

figure4 = figure(4);
clf
set(figure4,"Units",'centimeters',"Position",[10 10 12 8.2])


tiledlayout(1,1,"TileSpacing","loose","Padding","compact")
% nexttile(1,[1,7])
% hold on
% %plot(ff(randX_bound,randY_bound),gg(randX_bound,randY_bound),'ko','MarkerSize',1)
% randX_bound=(xlimit(2)-xlimit(1))*rand(1,100000)+xlimit(1);
% randY_bound=(ylimit(2)-ylimit(1))*rand(1,100000)+ylimit(1);
% Yrange=[0,20]; YrangeLine=linspace(Yrange(1),Yrange(2),101);%YrangeLine(1)=-100000000;
% FVal_bound=ff(randX_bound,randY_bound);
% CVal_bound=gg(randX_bound,randY_bound);
% for i=1:length(YrangeLine)-1
%     BoundLine(i)=min(FVal_bound(CVal_bound>=YrangeLine(i) & CVal_bound<=YrangeLine(i+1)));
% end
% 
% plot(BoundLine(1:100),YrangeLine(1:100),'k:','LineWidth',2)
% InfeasibleCVal=CVal(IndexFeasible==0); InfeasibleFVal=FVal(IndexFeasible==0);
% plot(InfeasibleFVal,InfeasibleCVal,'b*')
% plot(FVal(IndexFeasible),0*FVal(IndexFeasible),'r*')
% 
% plot(min(FVal(IndexFeasible)),0,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k')
% plot(BoundLine(1),0,'ko','MarkerFaceColor','y')
% 
% [~,Top10Index]=mink(InfeasibleFVal,8);
% [~,TopIndex]=min(InfeasibleCVal);
% plot(InfeasibleFVal(Top10Index),InfeasibleCVal(Top10Index),'g*','MarkerFaceColor',[0,0.9,0])
% plot(InfeasibleFVal(TopIndex),InfeasibleCVal(TopIndex),'gd','MarkerSize',6,'MarkerFaceColor',[0,0.9,0],'MarkerEdgeColor','k')
% 
% ylim([0,14])
% xlim([-1,1.5])
% ylabel("Constraint violation")
% xlabel("Objective functional")
% legend({"Domain boundary","infeasible members","feasible member","best among feasible","Optimal point","Good infeasibles","best among good infeasible"},'Location','northwest','FontSize',10)
% set(gca,'FontSize',FontSSize,'FontName','Times','Box','on')


nexttile(1)
[XX,YY] = meshgrid(xx,yy);
ggvalue=gg(XX,YY);

surf(XX,YY,ff(XX,YY),'EdgeColor','none')
hold on
surf(cX,cY,cZ,'LineWidth',2,'FaceColor','none')
%plot3(randX(IndexFeasible),randY(IndexFeasible),ff(randX(IndexFeasible),randY(IndexFeasible))+2,'r*')
%plot3(randX(IndexFeasible==0),randY(IndexFeasible==0),ff(randX(IndexFeasible==0),randY(IndexFeasible==0))+2,'b*')
plot3(0,-0.0248,1.5,'ko','MarkerFaceColor','y','MarkerSize',10)
%plot3(randX(45),randY(45),1.5,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k')
%plot3(randX([15,18,20,29,50,87,92,98]),randY([15,18,20,29,50,87,92,98]),2.5+0*randY([15,18,20,29,50,87,92,98]),'g*','MarkerFaceColor',[0,0.9,0])
text(2.1,2.3,2,['constraint'],'HorizontalAlignment','left','FontSize',13,'FontWeight','bold','FontName','Times');
%plot3(randX(92),randY(92),2.5,'gd','MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','k','MarkerFaceColor',[0,0.9,0])
%legend({"",'constraint'},'Location','northwest','Color','none')
colorbar



%plot3(BestSoFar(:,1),BestSoFar(:,2),10+0*BestSoFar(:,2),'g-','LineWidth',2,'Marker','>')
plot3(BestSoFar(end-600,1),BestSoFar(end-600,2),30+0*BestSoFar(end-600,2),'kd','MarkerFaceColor','m','MarkerSize',7)
for iiiii=1:length(BestSoFar(:,1))-2000
    quiver3(BestSoFar(iiiii,1),BestSoFar(iiiii,2),10,BestSoFar(iiiii+1,1)-BestSoFar(iiiii,1),BestSoFar(iiiii+1,2)-BestSoFar(iiiii,2),0,"off",'filled','Color',[255 215 0]/255,'LineWidth',2)
end

xlim(xlimit)
ylim(ylimit)
xlabel('$x_1$','Interpreter','latex')
ylabel('$x_2$','Interpreter','latex')
title('Without infeasible operator')
legend('','','optimal point','local minimum','CMODE trajectory','Location','southwest','FontSize',8)
set(gca,"View",[0,90],'FontSize',FontSSize,'FontName','Times')


%%
load With_infeasible_operator.mat

% for j=1:History_SASSMODE.iter
%     try
%         index=sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j}');
%     catch
%         index=sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j});
%     end
%     BestSoFar(j,:)=History_SASSMODE.pop{j}(index(1),:);
% end

for j=1:History_SASSMODE.iter
    try
        index=sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j}');
    catch
        index=sorting(History_SASSMODE.obj{j},History_SASSMODE.con{j});
    end
    BestSoFar(j,:)=History_SASSMODE.pop{j}(4,:);
end


rng(3)
xlimit=[-4,4];
ylimit=[-1,4.5];
randX=(xlimit(2)-xlimit(1))*rand(1,100)+xlimit(1);
randY=(ylimit(2)-ylimit(1))*rand(1,100)+ylimit(1);


%ff=@(x,y) sin(x/2).^2 + y.*cos(y/2).^4;% +2*(y-2).^2 -2*(x-2).^4+x.*y;
ff=@(x,y) sin(x/2).^2 + y.*cos(y/2).^4;

gg=@(x,y) x.^2+(y-2).^2-4.1;
[cX,cY,cZ]=cylinder(sqrt(4.1),100);
cY=cY+2; cZ=1.4*cZ;


xx=linspace(xlimit(1),xlimit(2),101);
yy=linspace(ylimit(1),ylimit(2),1001);

FVal=ff(randX,randY);
CVal=gg(randX,randY);
IndexFeasible=gg(randX,randY)<=0;

FontSSize= 13;

figure3 = figure(3);
clf
set(figure3,"Units",'centimeters',"Position",[10 10 12 8.2])


tiledlayout(1,1,"TileSpacing","loose","Padding","compact")
% nexttile(1,[1,7])
% hold on
% %plot(ff(randX_bound,randY_bound),gg(randX_bound,randY_bound),'ko','MarkerSize',1)
% randX_bound=(xlimit(2)-xlimit(1))*rand(1,100000)+xlimit(1);
% randY_bound=(ylimit(2)-ylimit(1))*rand(1,100000)+ylimit(1);
% Yrange=[0,20]; YrangeLine=linspace(Yrange(1),Yrange(2),101);%YrangeLine(1)=-100000000;
% FVal_bound=ff(randX_bound,randY_bound);
% CVal_bound=gg(randX_bound,randY_bound);
% for i=1:length(YrangeLine)-1
%     BoundLine(i)=min(FVal_bound(CVal_bound>=YrangeLine(i) & CVal_bound<=YrangeLine(i+1)));
% end
% 
% plot(BoundLine(1:100),YrangeLine(1:100),'k:','LineWidth',2)
% InfeasibleCVal=CVal(IndexFeasible==0); InfeasibleFVal=FVal(IndexFeasible==0);
% plot(InfeasibleFVal,InfeasibleCVal,'b*')
% plot(FVal(IndexFeasible),0*FVal(IndexFeasible),'r*')
% 
% plot(min(FVal(IndexFeasible)),0,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k')
% plot(BoundLine(1),0,'ko','MarkerFaceColor','y')
% 
% [~,Top10Index]=mink(InfeasibleFVal,8);
% [~,TopIndex]=min(InfeasibleCVal);
% plot(InfeasibleFVal(Top10Index),InfeasibleCVal(Top10Index),'g*','MarkerFaceColor',[0,0.9,0])
% plot(InfeasibleFVal(TopIndex),InfeasibleCVal(TopIndex),'gd','MarkerSize',6,'MarkerFaceColor',[0,0.9,0],'MarkerEdgeColor','k')
% 
% ylim([0,14])
% xlim([-1,1.5])
% ylabel("Constraint violation")
% xlabel("Objective functional")
% legend({"Domain boundary","infeasible members","feasible member","best among feasible","Optimal point","Good infeasibles","best among good infeasible"},'Location','northwest','FontSize',10)
% set(gca,'FontSize',FontSSize,'FontName','Times','Box','on')


nexttile(1)
[XX,YY] = meshgrid(xx,yy);
ggvalue=gg(XX,YY);

surf(XX,YY,ff(XX,YY),'EdgeColor','none')
hold on
surf(cX,cY,cZ,'LineWidth',2,'FaceColor','none')
%plot3(randX(IndexFeasible),randY(IndexFeasible),ff(randX(IndexFeasible),randY(IndexFeasible))+2,'r*')
%plot3(randX(IndexFeasible==0),randY(IndexFeasible==0),ff(randX(IndexFeasible==0),randY(IndexFeasible==0))+2,'b*')
plot3(0,-0.0248,1.5,'ko','MarkerFaceColor','y','MarkerSize',10)
%plot3(randX(45),randY(45),1.5,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k')
%plot3(randX([15,18,20,29,50,87,92,98]),randY([15,18,20,29,50,87,92,98]),2.5+0*randY([15,18,20,29,50,87,92,98]),'g*','MarkerFaceColor',[0,0.9,0])
text(2.1,2.3,2,['constraint'],'HorizontalAlignment','left','FontSize',13,'FontWeight','bold','FontName','Times');
%plot3(randX(92),randY(92),2.5,'gd','MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','k','MarkerFaceColor',[0,0.9,0])
%legend({"",'constraint'},'Location','northwest','Color','none')
%colorbar



%plot3(BestSoFar(:,1),BestSoFar(:,2),10+0*BestSoFar(:,2),'g-','LineWidth',2,'Marker','>')
plot3(0,pi,30+0*BestSoFar(end-600,2),'kd','MarkerFaceColor','m','MarkerSize',7)
for iiiii=1:length(BestSoFar(:,1))-600
    quiver3(BestSoFar(iiiii,1),BestSoFar(iiiii,2),10,BestSoFar(iiiii+1,1)-BestSoFar(iiiii,1),BestSoFar(iiiii+1,2)-BestSoFar(iiiii,2),0,"off",'filled','Color',[255 215 0]/255,'LineWidth',2)
end
xlim(xlimit)
ylim(ylimit)
xlabel('$x_1$','Interpreter','latex')
ylabel('$x_2$','Interpreter','latex')
title('With infeasible operator')

set(gca,"View",[0,90],'FontSize',FontSSize,'FontName','Times')

