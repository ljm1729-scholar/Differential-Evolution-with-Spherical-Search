clc;
clear all;
%% weight calculation
function_range=[2];  %[1:5,7:21,23:25,27:35,38,41,43:49,51:57]; %6, 26, 40, 42, 50, 22 % 36,37,39
w = zeros(length(function_range),1);
D = [9	11	7	6	9	38	48	2	3	3	7	7	5	10	7	14	3	4	4	2	5	9	5	7	4	22	10	10	4	3	4	5	...
     30	118	153	158	126	126	126	76	74	86	86	30	25	25	25	30	30	30	59	59	59	59	64	64	64];
D = D(function_range);
for i = 1:length(function_range)
    if D(i) <= 10
        w(i) = 1;
    elseif D(i) > 10 && D(i) <= 30
        w(i) = 2;
    elseif D(i) > 30 && D(i) <= 50
        w(i) = 3;
    elseif D(i) > 50 && D(i) <= 150
        w(i) = 4;
    else 
        w(i) = 5;
    end
end
w = w./sum(w);
%% load data
FCv = xlsread('ComparisonInfectious.xlsx',1,'E2:W343');
Algorithm = ['     VMCH';'  sCMAgES';'     SASS';'   EnMODE';' COLSHADE';'    BiPop';'SASS-MODE';'     DEQL'];
tableeee = readtable('Comparison with 18 algorithms.xlsx',Range="E1:W1",ReadVariableNames=true);
NameAlgo = tableeee.Properties.VariableNames; clear("tableeee");
NumAlgo = length(FCv(1,:));
Numbering ={'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19'};
A1 = xlsread('VMCH.xlsx',1);
A2 = xlsread('VMCH.xlsx',2);
B1 = xlsread('sCMAgES.xlsx',1);
B2 = xlsread('sCMAgES.xlsx',2);
C1 = xlsread('SASS.xlsx',1);
C2 = xlsread('SASS.xlsx',2);
D1 = xlsread('EnMODE.xlsx',1);
D2 = xlsread('EnMODE.xlsx',2);
E1 = xlsread('COLSHADE.xlsx',1);
E2 = xlsread('COLSHADE.xlsx',2);
F1 = xlsread('BiPop.xlsx',1);
F2 = xlsread('BiPop.xlsx',2);
G1 = xlsread('full_proportion_05.xlsx',1);
G2 = xlsread('full_proportion_05.xlsx',2);
H1 = xlsread('DEQL.xlsx',1);
H2 = xlsread('DEQL.xlsx',2);

% A1 = xlsread('SASS-MODE01.xlsx',1);
% A2 = xlsread('SASS-MODE01.xlsx',2);
% B1 = xlsread('SASS-MODE02.xlsx',1);
% B2 = xlsread('SASS-MODE02.xlsx',2);
% C1 = xlsread('SASS-MODE03.xlsx',1);
% C2 = xlsread('SASS-MODE03.xlsx',2);
% D1 = xlsread('SASS-MODE04.xlsx',1);
% D2 = xlsread('SASS-MODE04.xlsx',2);
% E1 = xlsread('SASS-MODE05.xlsx',1);
% E2 = xlsread('SASS-MODE05.xlsx',2);
% F1 = xlsread('SASS-MODE06.xlsx',1);
% F2 = xlsread('SASS-MODE06.xlsx',2);
% G1 = xlsread('SASS-MODE07.xlsx',1);
% G2 = xlsread('SASS-MODE07.xlsx',2);
% H1 = xlsread('SASS-MODE09.xlsx',1);
% H2 = xlsread('SASS-MODE09.xlsx',2);

A1 = A1(:,function_range);
A2 = A2(:,function_range);
B1 = B1(:,function_range);
B2 = B2(:,function_range);
C1 = C1(:,function_range);
C2 = C2(:,function_range);
D1 = D1(:,function_range);
D2 = D2(:,function_range);
E1 = E1(:,function_range);
E2 = E2(:,function_range);
F1 = F1(:,function_range);
F2 = F2(:,function_range);
G1 = G1(:,function_range);
G2 = G2(:,function_range);
H1 = H1(:,function_range);
H2 = H2(:,function_range);
%% best solution
for ii=1:NumAlgo
    X = ['bestf',Numbering{ii},' = FCv(1+(function_range-1)*6,',Numbering{ii},')'';',...
         'bestc',Numbering{ii},' = FCv(2+(function_range-1)*6,',Numbering{ii},')'';']; eval(X)
end


best1 = [bestf01;bestf02;bestf03;bestf04;bestf05;bestf06;bestf07;bestf08;bestf09;bestf10;bestf11;bestf12;bestf13;bestf14;bestf15;bestf16;bestf17;bestf18;bestf19];
best2 = [bestc01;bestc02;bestc03;bestc04;bestc05;bestc06;bestc07;bestc08;bestc09;bestc10;bestc11;bestc12;bestc13;bestc14;bestc15;bestc16;bestc17;bestc18;bestc19];
i = best2 == 0;
j = ~i;

for v=1:NumAlgo
    X = ['best',Numbering{ii},' = zeros(size(bestf',Numbering{ii},'));']; eval(X)
end

for kk = 1:length(function_range)
    
    if sum(i(:,kk))==0

        for ii=1:NumAlgo
            X = ['best',Numbering{ii},'(:,kk) = bestf',Numbering{ii},'(:,kk);']; eval(X)
        end

    else 
        M = max(best1(i(:,kk),kk));

        for ii=1:NumAlgo
            X = ['best',Numbering{ii},'(i(',num2str(ii),',kk),kk) = bestf',Numbering{ii},'(i(',num2str(ii),',kk),kk);']; eval(X)
        end

        for ii=1:NumAlgo
            X = ['best',Numbering{ii},'(j(',num2str(ii),',kk),kk) = M + bestc',Numbering{ii},'(j(',num2str(ii),',kk),kk);']; eval(X)
        end
        % bestA(i(1,kk),kk) = bestA1(i(1,kk),kk);
        % bestB(i(2,kk),kk) = bestB1(i(2,kk),kk);
        % bestC(i(3,kk),kk) = bestC1(i(3,kk),kk);
        % bestD(i(4,kk),kk) = bestD1(i(4,kk),kk);
        % bestE(i(5,kk),kk) = bestE1(i(5,kk),kk);
        % bestF(i(6,kk),kk) = bestF1(i(6,kk),kk);
        % bestG(i(7,kk),kk) = bestG1(i(7,kk),kk);
        % bestH(i(8,kk),kk) = bestH1(i(8,kk),kk) ;
        % %%
        % bestA(j(1,kk),kk) = M + bestA2(j(1,kk),kk);
        % bestB(j(2,kk),kk) = M + bestB2(j(2,kk),kk);
        % bestC(j(3,kk),kk) = M + bestC2(j(3,kk),kk);
        % bestD(j(4,kk),kk) = M + bestD2(j(4,kk),kk);
        % bestE(j(5,kk),kk) = M + bestE2(j(5,kk),kk);
        % bestF(j(6,kk),kk) = M + bestF2(j(6,kk),kk);
        % bestG(j(7,kk),kk) = M + bestG2(j(7,kk),kk);
        % bestH(j(8,kk),kk) = M + bestH2(j(8,kk),kk) ;
    end
end
best = [best01;best02;best03;best04;best05;best06;best07;best08;best09;best10;best11;best12;best13;best14;best15;best16;best17;best18;best19];
min_best = min(best);
max_best = max(best);
mx_mn_best = max_best-min_best;
mx_mn_best(mx_mn_best == 0) = 1e-8;
for ii=1:NumAlgo
    X = ['best',Numbering{ii},' = (best',Numbering{ii},' -min_best)./(mx_mn_best); best',Numbering{ii},'(isnan(best',Numbering{ii},')) = 1;']; eval(X)
end
best = [best01;best02;best03;best04;best05;best06;best07;best08;best09;best10;best11;best12;best13;best14;best15;best16;best17;best18;best19];
Score_best = best*w;
% bestA   = (bestA-min_best)./(mx_mn_best);
% bestB   = (bestB-min_best)./(mx_mn_best);
% bestC   = (bestC-min_best)./(mx_mn_best);
% bestD   = (bestD-min_best)./(mx_mn_best);
% bestE   = (bestE-min_best)./(mx_mn_best);
% bestF   = (bestF-min_best)./(mx_mn_best);
% bestG   = (bestG-min_best)./(mx_mn_best);
% bestH   = (bestH-min_best)./(mx_mn_best);bestH(isnan(bestH)) = 1;
% best = [bestA;bestB;bestC;bestD;bestE;bestF;bestG;bestH];
% Score_best = best*w;
%% mean solution
for ii=1:NumAlgo
    X = ['meanf',Numbering{ii},' = FCv(5+(function_range-1)*6,',Numbering{ii},')'';',...
         'meanc',Numbering{ii},' = FCv(6+(function_range-1)*6,',Numbering{ii},')'';']; eval(X)
end

mean1 = [meanf01;meanf02;meanf03;meanf04;meanf05;meanf06;meanf07;meanf08;meanf09;meanf10;meanf11;meanf12;meanf13;meanf14;meanf15;meanf16;meanf17;meanf18;meanf19];
mean2 = [meanc01;meanc02;meanc03;meanc04;meanc05;meanc06;meanc07;meanc08;meanc09;meanc10;meanc11;meanc12;meanc13;meanc14;meanc15;meanc16;meanc17;meanc18;meanc19];
i = mean2 == 0;
j = ~i;

for v=1:NumAlgo
    X = ['mean',Numbering{ii},' = zeros(size(meanf',Numbering{ii},'));']; eval(X)
end

for kk = 1:length(function_range)
    
    if sum(i(:,kk))==0

        for ii=1:NumAlgo
            X = ['mean',Numbering{ii},'(:,kk) = meanf',Numbering{ii},'(:,kk);']; eval(X)
        end

    else 
        M = max(mean1(i(:,kk),kk));

        for ii=1:NumAlgo
            X = ['mean',Numbering{ii},'(i(',num2str(ii),',kk),kk) = meanf',Numbering{ii},'(i(',num2str(ii),',kk),kk);']; eval(X)
        end

        for ii=1:NumAlgo
            X = ['mean',Numbering{ii},'(j(',num2str(ii),',kk),kk) = M + meanc',Numbering{ii},'(j(',num2str(ii),',kk),kk);']; eval(X)
        end
        % meanA(i(1,kk),kk) = meanA1(i(1,kk),kk);
        % meanB(i(2,kk),kk) = meanB1(i(2,kk),kk);
        % meanC(i(3,kk),kk) = meanC1(i(3,kk),kk);
        % meanD(i(4,kk),kk) = meanD1(i(4,kk),kk);
        % meanE(i(5,kk),kk) = meanE1(i(5,kk),kk);
        % meanF(i(6,kk),kk) = meanF1(i(6,kk),kk);
        % meanG(i(7,kk),kk) = meanG1(i(7,kk),kk);
        % meanH(i(8,kk),kk) = meanH1(i(8,kk),kk) ;
        % %%
        % meanA(j(1,kk),kk) = M + meanA2(j(1,kk),kk);
        % meanB(j(2,kk),kk) = M + meanB2(j(2,kk),kk);
        % meanC(j(3,kk),kk) = M + meanC2(j(3,kk),kk);
        % meanD(j(4,kk),kk) = M + meanD2(j(4,kk),kk);
        % meanE(j(5,kk),kk) = M + meanE2(j(5,kk),kk);
        % meanF(j(6,kk),kk) = M + meanF2(j(6,kk),kk);
        % meanG(j(7,kk),kk) = M + meanG2(j(7,kk),kk);
        % meanH(j(8,kk),kk) = M + meanH2(j(8,kk),kk) ;
    end
end
mean = [mean01;mean02;mean03;mean04;mean05;mean06;mean07;mean08;mean09;mean10;mean11;mean12;mean13;mean14;mean15;mean16;mean17;mean18;mean19];
min_mean = min(mean);
max_mean = max(mean);
mx_mn_mean = max_mean-min_mean;
mx_mn_mean(mx_mn_mean == 0) = 1e-8;
for ii=1:NumAlgo
    X = ['mean',Numbering{ii},' = (mean',Numbering{ii},' -min_mean)./(mx_mn_mean); mean',Numbering{ii},'(isnan(mean',Numbering{ii},')) = 1;']; eval(X)
end
mean = [mean01;mean02;mean03;mean04;mean05;mean06;mean07;mean08;mean09;mean10;mean11;mean12;mean13;mean14;mean15;mean16;mean17;mean18;mean19];
Score_mean = mean*w;
%% median solution
for ii=1:NumAlgo
    X = ['medf',Numbering{ii},' = FCv(3+(function_range-1)*6,',Numbering{ii},')'';',...
         'medc',Numbering{ii},' = FCv(4+(function_range-1)*6,',Numbering{ii},')'';']; eval(X)
end

med1 = [medf01;medf02;medf03;medf04;medf05;medf06;medf07;medf08;medf09;medf10;medf11;medf12;medf13;medf14;medf15;medf16;medf17;medf18;medf19];
med2 = [medc01;medc02;medc03;medc04;medc05;medc06;medc07;medc08;medc09;medc10;medc11;medc12;medc13;medc14;medc15;medc16;medc17;medc18;medc19];
i = med2 == 0;
j = ~i;

for v=1:NumAlgo
    X = ['med',Numbering{ii},' = zeros(size(medf',Numbering{ii},'));']; eval(X)
end

for kk = 1:length(function_range)
    
    if sum(i(:,kk))==0

        for ii=1:NumAlgo
            X = ['med',Numbering{ii},'(:,kk) = medf',Numbering{ii},'(:,kk);']; eval(X)
        end

    else 
        M = max(med1(i(:,kk),kk));

        for ii=1:NumAlgo
            X = ['med',Numbering{ii},'(i(',num2str(ii),',kk),kk) = medf',Numbering{ii},'(i(',num2str(ii),',kk),kk);']; eval(X)
        end

        for ii=1:NumAlgo
            X = ['med',Numbering{ii},'(j(',num2str(ii),',kk),kk) = M + medc',Numbering{ii},'(j(',num2str(ii),',kk),kk);']; eval(X)
        end
        % medA(i(1,kk),kk) = medA1(i(1,kk),kk);
        % medB(i(2,kk),kk) = medB1(i(2,kk),kk);
        % medC(i(3,kk),kk) = medC1(i(3,kk),kk);
        % medD(i(4,kk),kk) = medD1(i(4,kk),kk);
        % medE(i(5,kk),kk) = medE1(i(5,kk),kk);
        % medF(i(6,kk),kk) = medF1(i(6,kk),kk);
        % medG(i(7,kk),kk) = medG1(i(7,kk),kk);
        % medH(i(8,kk),kk) = medH1(i(8,kk),kk) ;
        % %%
        % medA(j(1,kk),kk) = M + medA2(j(1,kk),kk);
        % medB(j(2,kk),kk) = M + medB2(j(2,kk),kk);
        % medC(j(3,kk),kk) = M + medC2(j(3,kk),kk);
        % medD(j(4,kk),kk) = M + medD2(j(4,kk),kk);
        % medE(j(5,kk),kk) = M + medE2(j(5,kk),kk);
        % medF(j(6,kk),kk) = M + medF2(j(6,kk),kk);
        % medG(j(7,kk),kk) = M + medG2(j(7,kk),kk);
        % medH(j(8,kk),kk) = M + medH2(j(8,kk),kk) ;
    end
end
med = [med01;med02;med03;med04;med05;med06;med07;med08;med09;med10;med11;med12;med13;med14;med15;med16;med17;med18;med19];
min_med = min(med);
max_med = max(med);
mx_mn_med = max_med-min_med;
mx_mn_med(mx_mn_med == 0) = 1e-8;
for ii=1:NumAlgo
    X = ['med',Numbering{ii},' = (med',Numbering{ii},' -min_med)./(mx_mn_med); med',Numbering{ii},'(isnan(med',Numbering{ii},')) = 1;']; eval(X)
end
med = [med01;med02;med03;med04;med05;med06;med07;med08;med09;med10;med11;med12;med13;med14;med15;med16;med17;med18;med19];
Score_med = med*w;
%% mean Solution
% meanA1 = mean(A1);
% meanA2 = mean(A2);
% meanB1 = mean(B1);
% meanB2 = mean(B2);
% meanC1 = mean(C1);
% meanC2 = mean(C2);
% meanD1 = mean(D1);
% meanD2 = mean(D2);
% meanE1 = mean(E1);
% meanE2 = mean(E2);
% meanF1 = mean(F1);
% meanF2 = mean(F2);
% meanG1 = mean(G1);
% meanG2 = mean(G2);
% meanH1 = mean(H1);
% meanH2 = mean(H2);
% mean1 = [meanA1;meanB1;meanC1;meanD1;meanE1;meanF1;meanG1;meanH1];
% mean2 = [meanA2;meanB2;meanC2;meanD2;meanE2;meanF2;meanG2;meanH2];
% i = mean2 == 0;
% j = ~i;
% meanA = zeros(size(meanA1));
% meanB = zeros(size(meanB1));
% meanC = zeros(size(meanC1));
% meanD = zeros(size(meanD1));
% meanE = zeros(size(meanE1));
% meanF = zeros(size(meanF1));
% meanG = zeros(size(meanG1));
% meanH = zeros(size(meanH1));
% for kk = 1:length(function_range)
% 
%     if sum(i(:,kk))==0
%         meanA(:,kk) = meanA2(:,kk);
%         meanB(:,kk) = meanB2(:,kk);
%         meanC(:,kk) = meanC2(:,kk);
%         meanD(:,kk) = meanD2(:,kk);
%         meanE(:,kk) = meanE2(:,kk);
%         meanF(:,kk) = meanF2(:,kk);
%         meanG(:,kk) = meanG2(:,kk);
%         meanH(:,kk) = meanH2(:,kk) ;
%     else 
%         M = max(mean1(i(:,kk),kk));
%         meanA(i(1,kk),kk) = meanA1(i(1,kk),kk);
%         meanB(i(2,kk),kk) = meanB1(i(2,kk),kk);
%         meanC(i(3,kk),kk) = meanC1(i(3,kk),kk);
%         meanD(i(4,kk),kk) = meanD1(i(4,kk),kk);
%         meanE(i(5,kk),kk) = meanE1(i(5,kk),kk);
%         meanF(i(6,kk),kk) = meanF1(i(6,kk),kk);
%         meanG(i(7,kk),kk) = meanG1(i(7,kk),kk);
%         meanH(i(8,kk),kk) = meanH1(i(8,kk),kk) ;
%         %%
%         meanA(j(1,kk),kk) = M + meanA2(j(1,kk),kk);
%         meanB(j(2,kk),kk) = M + meanB2(j(2,kk),kk);
%         meanC(j(3,kk),kk) = M + meanC2(j(3,kk),kk);
%         meanD(j(4,kk),kk) = M + meanD2(j(4,kk),kk);
%         meanE(j(5,kk),kk) = M + meanE2(j(5,kk),kk);
%         meanF(j(6,kk),kk) = M + meanF2(j(6,kk),kk);
%         meanG(j(7,kk),kk) = M + meanG2(j(7,kk),kk);
%         meanH(j(8,kk),kk) = M + meanH2(j(8,kk),kk) ;
%     end
% end
% men = [meanA;meanB;meanC;meanD;meanE;meanF;meanG;meanH];
% min_mean = min(men);
% max_mean = max(men);
% mx_mn_mean = max_mean-min_mean;
% mx_mn_mean(mx_mn_mean == 0) = 1e-8;
% meanA   = (meanA-min_mean)./(mx_mn_mean);
% meanB   = (meanB-min_mean)./(mx_mn_mean);
% meanC   = (meanC-min_mean)./(mx_mn_mean);
% meanD   = (meanD-min_mean)./(mx_mn_mean);
% meanE   = (meanE-min_mean)./(mx_mn_mean);
% meanF   = (meanF-min_mean)./(mx_mn_mean);
% meanG   = (meanG-min_mean)./(mx_mn_mean);
% meanH   = (meanH-min_mean)./(mx_mn_mean);meanH(isnan(meanH)) = 1;
% men = [meanA;meanB;meanC;meanD;meanE;meanF;meanG;meanH];
% Score_mean = men*w;
% %% median Solution
% medA1 = A1(13,:);
% medA2 = A2(13,:);
% medB1 = B1(13,:);
% medB2 = B2(13,:);
% medC1 = C1(13,:);
% medC2 = C2(13,:);
% medD1 = D1(13,:);
% medD2 = D2(13,:);
% medE1 = E1(13,:);
% medE2 = E2(13,:);
% medF1 = F1(13,:);
% medF2 = F2(13,:);
% medG1 = G1(13,:);
% medG2 = G2(13,:);
% medH1 = H1(13,:);
% medH2 = H2(13,:);
% med1 = [medA1;medB1;medC1;medD1;medE1;medF1;medG1;medH1];
% med2 = [medA2;medB2;medC2;medD2;medE2;medF2;medG2;medH2];
% i = med2 == 0;
% j = ~i;
% medA = zeros(size(medA1));
% medB = zeros(size(medB1));
% medC = zeros(size(medC1));
% medD = zeros(size(medD1));
% medE = zeros(size(medE1));
% medF = zeros(size(medF1));
% medG = zeros(size(medG1));
% medH = zeros(size(medH1));
% for kk = 1:length(function_range)
% 
%     if sum(i(:,kk))==0
%         medA(:,kk) = medA2(:,kk);
%         medB(:,kk) = medB2(:,kk);
%         medC(:,kk) = medC2(:,kk);
%         medD(:,kk) = medD2(:,kk);
%         medE(:,kk) = medE2(:,kk);
%         medF(:,kk) = medF2(:,kk);
%         medG(:,kk) = medG2(:,kk);
%         medH(:,kk) = medH2(:,kk) ;
%     else 
%         M = max(med1(i(:,kk),kk));
%         medA(i(1,kk),kk) = medA1(i(1,kk),kk);
%         medB(i(2,kk),kk) = medB1(i(2,kk),kk);
%         medC(i(3,kk),kk) = medC1(i(3,kk),kk);
%         medD(i(4,kk),kk) = medD1(i(4,kk),kk);
%         medE(i(5,kk),kk) = medE1(i(5,kk),kk);
%         medF(i(6,kk),kk) = medF1(i(6,kk),kk);
%         medG(i(7,kk),kk) = medG1(i(7,kk),kk);
%         medH(i(8,kk),kk) = medH1(i(8,kk),kk) ;
%         %%
%         medA(j(1,kk),kk) = M + medA2(j(1,kk),kk);
%         medB(j(2,kk),kk) = M + medB2(j(2,kk),kk);
%         medC(j(3,kk),kk) = M + medC2(j(3,kk),kk);
%         medD(j(4,kk),kk) = M + medD2(j(4,kk),kk);
%         medE(j(5,kk),kk) = M + medE2(j(5,kk),kk);
%         medF(j(6,kk),kk) = M + medF2(j(6,kk),kk);
%         medG(j(7,kk),kk) = M + medG2(j(7,kk),kk);
%         medH(j(8,kk),kk) = M + medH2(j(8,kk),kk) ;
%     end
% end
% med = [medA;medB;medC;medD;medE;medF;medG;medH];
% min_med = min(med);
% max_med = max(med);
% mx_mn_med = max_med-min_med;
% mx_mn_med(mx_mn_med == 0) = 1e-8;
% medA   = (medA-min_med)./(mx_mn_med);
% medB   = (medB-min_med)./(mx_mn_med);
% medC   = (medC-min_med)./(mx_mn_med);
% medD   = (medD-min_med)./(mx_mn_med);
% medE   = (medE-min_med)./(mx_mn_med);
% medF   = (medF-min_med)./(mx_mn_med);
% medG   = (medG-min_med)./(mx_mn_med);
% medH   = (medH-min_med)./(mx_mn_med);medH(isnan(medH)) = 1;
% med = [medA;medB;medC;medD;medE;medF;medG;medH];
% Score_med = med*w;
%% final score
%Algorithm = ['E24594';'COM108';'COM109';'E24363';'E24586';'E24443';'E24191';'E24537'];
Total_Score = 0.5*Score_best+0.3*Score_mean+0.2*Score_med;
[~,ii] = sort(Total_Score); Rank(ii) = 1:19;
% Final_score = [Score_best,Score_mean,Score_med, 0.5*Score_best+0.3*Score_mean+0.2*Score_med]
disp('========================================================================');
disp('=====================Ranking of Algorithm on RWCOP======================');
disp('========================================================================');
fprintf('    Algorithm     Score1     Score2      Score3    Total Score    Rank\n');
for i = 1:19
    fprintf('%s %s %s %8.4f   %8.4f    %8.4f    %8.4f %s   %d\n',['   '], NameAlgo{i}, ['  '],  Score_best(i), Score_mean(i), Score_med(i), Total_Score(i), ['    '], Rank(i));
end
disp('========================================================================');
disp('========================================================================');
%% printing on text file
fileID = fopen('Scoring.txt','w');
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'=====================Ranking of Algorithm on RWCOP======================\n');
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'  Algorithm     Score1     Score2      Score3    Total Score    Rank\n');
for i = 1:19
    fprintf(fileID,'%s %s %s %8.4f   %8.4f    %8.4f    %8.4f %s   %d\n',['   '], NameAlgo{i}, ['  '],  Score_best(i), Score_mean(i), Score_med(i), Total_Score(i), ['    '], Rank(i));
end
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'========================================================================\n');