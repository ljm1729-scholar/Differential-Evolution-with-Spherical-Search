t=linspace(-6,4,901);
x=linspace(-6,4,20);
x_feasible=x([1,2,3,10,11,12,13,14,15]);
x_infeasible=x([4,5,6,7,8,9,16,17,18,19,20]);
OptimalPoint=-4.72222;
f=@(x) x.^2.*(x-3).*(x+5);
g=@(x) max(-cos(x),0);
figure(1)
clf
tiledlayout(1,2,"TileSpacing","compact","Padding","compact")
nexttile(1)
yyaxis left
hold on
plot(t,f(t),'k-')

yyaxis right
plot(t,g(t))
plot(x_feasible,0*x_feasible,'r*')
plot(x_infeasible,0*x_infeasible,'b*')
plot(OptimalPoint,0,'ro','MarkerFaceColor','y')

nexttile(2)
hold on
plot(f(t),g(t),'b')
plot(f(x_feasible),g(x_feasible),'r*')
plot(f(x_infeasible),g(x_infeasible),'b*')
plot(f(OptimalPoint),g(OptimalPoint),'ro','MarkerFaceColor','y')

%%
rng(3)
xlimit=[-4,4];
ylimit=[-1,4.5];
randX=(xlimit(2)-xlimit(1))*rand(1,100)+xlimit(1);
randY=(ylimit(2)-ylimit(1))*rand(1,100)+ylimit(1);


%ff=@(x,y) sin(x/2).^2 + y.*cos(y/2).^4;% +2*(y-2).^2 -2*(x-2).^4+x.*y;
ff=@(x,y) sin(x/2).^2 + y.*cos(y/2).^4;

gg=@(x,y) x.^2+(y-2).^2-4.6;
[cX,cY,cZ]=cylinder(sqrt(4.6),100);
cY=cY+2; cZ=1.4*cZ;


xx=linspace(xlimit(1),xlimit(2),101);
yy=linspace(ylimit(1),ylimit(2),1001);

FVal=ff(randX,randY);
CVal=gg(randX,randY);
IndexFeasible=gg(randX,randY)<=0;

FontSSize= 13;

figure4 = figure(4);
clf
set(figure4,"Units",'centimeters',"Position",[10 10 28 23])


tiledlayout(3,13,"TileSpacing","loose","Padding","compact")
nexttile(1,[1,8])
hold on
%plot(ff(randX_bound,randY_bound),gg(randX_bound,randY_bound),'ko','MarkerSize',1)
randX_bound=(xlimit(2)-xlimit(1))*rand(1,100000)+xlimit(1);
randY_bound=(ylimit(2)-ylimit(1))*rand(1,100000)+ylimit(1);
Yrange=[0,20]; YrangeLine=linspace(Yrange(1),Yrange(2),101);%YrangeLine(1)=-100000000;
FVal_bound=ff(randX_bound,randY_bound);
CVal_bound=gg(randX_bound,randY_bound);
for i=1:length(YrangeLine)-1
    BoundLine(i)=min(FVal_bound(CVal_bound>=YrangeLine(i) & CVal_bound<=YrangeLine(i+1)));
end

plot(BoundLine(1:100),YrangeLine(1:100),'k:','LineWidth',2)
InfeasibleCVal=CVal(IndexFeasible==0); InfeasibleFVal=FVal(IndexFeasible==0);
plot(InfeasibleFVal,InfeasibleCVal,'b*')
plot(FVal(IndexFeasible),0*FVal(IndexFeasible),'r*')

plot(min(FVal(IndexFeasible)),0,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k')
plot(BoundLine(1),0,'ko','MarkerFaceColor','y')

[~,Top10Index]=mink(InfeasibleFVal,8);
[~,TopIndex]=min(InfeasibleCVal);
plot(InfeasibleFVal(Top10Index),InfeasibleCVal(Top10Index),'g*','MarkerFaceColor',[0,0.9,0])
plot(InfeasibleFVal(TopIndex),InfeasibleCVal(TopIndex),'gd','MarkerSize',6,'MarkerFaceColor',[0,0.9,0],'MarkerEdgeColor','k')

ylim([0,14])
xlim([-1,1.5])
ylabel("Constraint violation")
xlabel("Objective functional")
legend({"Domain boundary","infeasible members","feasible member","best among feasible","Optimal point","Good infeasibles","best among good infeasible"},'Location','northwest','FontSize',10)
set(gca,'FontSize',FontSSize)


nexttile(9,[1,5])
[XX,YY] = meshgrid(xx,yy);
ggvalue=gg(XX,YY);

surf(XX,YY,ff(XX,YY),'EdgeColor','none')
hold on
surf(cX,cY,cZ,'LineWidth',2,'FaceColor','none')
plot3(randX(IndexFeasible),randY(IndexFeasible),ff(randX(IndexFeasible),randY(IndexFeasible))+2,'r*')
plot3(randX(IndexFeasible==0),randY(IndexFeasible==0),ff(randX(IndexFeasible==0),randY(IndexFeasible==0))+2,'b*')
plot3(0,-0.13,1.5,'ko','MarkerFaceColor','y')
plot3(randX(45),randY(45),1.5,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k')
plot3(randX([15,18,20,29,50,87,92,98]),randY([15,18,20,29,50,87,92,98]),2.5+0*randY([15,18,20,29,50,87,92,98]),'g*','MarkerFaceColor',[0,0.9,0])
text(2.1,2.3,2,['  constraint'],'HorizontalAlignment','left','FontSize',10,'FontWeight','bold');
plot3(randX(92),randY(92),2.5,'gd','MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','k','MarkerFaceColor',[0,0.9,0])
%legend({"",'constraint'},'Location','northwest','Color','none')
colorbar
xlim(xlimit)
ylim(ylimit)
title('Objective functional in the Domain')
set(gca,"View",[0,90],'FontSize',FontSSize)



nexttile(15,[2,11])
[XX,YY] = meshgrid(xx,yy);
ggvalue=gg(XX,YY);

%surf(XX,YY,ff(XX,YY),'EdgeColor','none')
hold on

surf(cX,cY,cZ,'LineWidth',2,'FaceColor','none') % constraint
plot3(randX(IndexFeasible==0),randY(IndexFeasible==0),ff(randX(IndexFeasible==0),randY(IndexFeasible==0))+2,'b*') % infeasible points
plot3(randX(IndexFeasible),randY(IndexFeasible),ff(randX(IndexFeasible),randY(IndexFeasible))+2,'r*') % feasible points
plot3(randX(45),randY(45),1.5,'rd','MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','k') % Best among feasible points
plot3(0,-0.13,1.5,'ko','MarkerFaceColor','y') % Optimal point
plot3(randX([15,18,20,29,50,87,92,98]),randY([15,18,20,29,50,87,92,98]),2.5+0*randY([15,18,20,29,50,87,92,98]),'g*','MarkerFaceColor',[0,0.9,0]) % good infeasible points
text(2.1,2.3,2,['   constraint'],'HorizontalAlignment','left','FontSize',10,'FontWeight','bold'); % best among good infeasible points


BF=[-0.338508805416176,2.822298893274817]; % best feasible
%annotation('textarrow',BF(1),BF(2),'String','y = x ')

OP=[0,-0.13]; % optimal point
%annotation('textarrow',OP(1),OP(2),'String','optimal point')

GIP=[-0.679190423919443,0.729900915811695]; % good infeasible point
%annotation('textarrow',GIP(1),GIP(2),'String','x_{\psi,j}')

R1=[2.713544462399765,0.675775381216156]; % random point 1

%annotation('textarrow',R1(1),R1(2),'String','x_{r_{1},j}')

R2=[3.170344711467505,-0.729900915811695]; % random point 2
%annotation('textarrow',R2(1),R2(2),'String','x_{r_{4},j}')
annotation('textarrow',[0.776785714285714,0.478184523809523],[0.365869565217391,0.220157004830918],'Color','g') %,'String','$\vec{x_{r_{3},j}x_{\psi,j}}$','Interpreter','latex'
annotation('textarrow',[0.733948412698413,0.435347222222222],[0.230893719806763,0.08518115942029],'Color','g')
annotation('textarrow',[0.733948412698413,0.466845238095238],[0.233961352657005,0.450229468599034],'Color','r')
annotation('textarrow',[0.776785714285714,0.509682539682539],[0.365869565217391,0.582229468599034],'Color','r')

annotation('textbox',[0.785 0.28 0.1 0.1],'String','$r_4$','FitBoxToText','on','Color','k','Interpreter','latex','EdgeColor','none','FontWeight','bold','FontSize',13)
annotation('textbox',[0.74 0.15 0.1 0.1],'String','$r_1$','FitBoxToText','on','Color','k','Interpreter','latex','EdgeColor','none','FontWeight','bold','FontSize',13)
annotation('textbox',[0.435 0.37 0.1 0.1],'String','$\phi$','FitBoxToText','on','Color','k','Interpreter','latex','EdgeColor','none','FontWeight','bold','FontSize',13)
annotation('textbox',[0.41 0.01 0.1 0.1],'String','$\psi$','FitBoxToText','on','Color','k','Interpreter','latex','EdgeColor','none','FontWeight','bold','FontSize',13)
annotation('textbox',[0.415 0.485 0.1 0.1],'String','$r_4 + (r_1 - \phi)$','FitBoxToText','on','Color','k','Interpreter','latex','EdgeColor','none','FontWeight','bold','FontSize',13)
annotation('textbox',[0.375 0.14 0.1 0.1],'String','$r_4 + (r_1 - \psi)$','FitBoxToText','on','Color','k','Interpreter','latex','EdgeColor','none','FontWeight','bold','FontSize',13)
%annotation('textbox',[0.776785714285714,0.509682539682539],[0.365869565217391,0.582229468599034],'Color','r')
%annotation('textbox',[0.776785714285714,0.509682539682539],[0.365869565217391,0.582229468599034],'Color','r')
%annotation('textbox',[0.776785714285714,0.509682539682539],[0.365869565217391,0.582229468599034],'Color','r')


plot3(randX(92),randY(92),2.5,'gd','MarkerSize',6,'MarkerFaceColor','g','MarkerEdgeColor','k','MarkerFaceColor',[0,0.9,0]) % Best infeasible
%legend({"",'constraint'},'Location','northwest','Color','none')
%colorbar


xlim(xlimit)
ylim(ylimit)
title('Objective functional in the Domain')
set(gca,"View",[0,90],'FontSize',FontSSize)

