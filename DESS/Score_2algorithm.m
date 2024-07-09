clc;
clear all;
%% weight calculation
function_range=[1:33]; %[1:57];%[1:57];%[1:33,44:50];
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
Algorithm = ['SASS-MODE02';'SASS-MODE00'];
A1 = xlsread('20221214SASS-MODE0.2.xlsx',1);
A2 = xlsread('20221214SASS-MODE0.2.xlsx',2);
B1 = xlsread('20221214SASS-MODE.xlsx',1);
B2 = xlsread('20221214SASS-MODE.xlsx',2);

A1 = A1(:,function_range);
A2 = A2(:,function_range);
B1 = B1(:,function_range);
B2 = B2(:,function_range);

%% best solution
bestA1 = A1(1,:);
bestA2 = A2(1,:);
bestB1 = B1(1,:);
bestB2 = B2(1,:);

best1 = [bestA1;bestB1];
best2 = [bestA2;bestB2];
i = best2 == 0;
j = ~i;
bestA = zeros(size(bestA1));
bestB = zeros(size(bestB1));

for kk = 1:length(function_range)
    
    if sum(i(:,kk))==0
        bestA(:,kk) = bestA2(:,kk);
        bestB(:,kk) = bestB2(:,kk);
    else 
        M = max(best1(i(:,kk),kk));
        bestA(i(1,kk),kk) = bestA1(i(1,kk),kk);
        bestB(i(2,kk),kk) = bestB1(i(2,kk),kk);
        %%
        bestA(j(1,kk),kk) = M + bestA2(j(1,kk),kk);
        bestB(j(2,kk),kk) = M + bestB2(j(2,kk),kk);
    end
end
best = [bestA;bestB];
min_best = min(best);
max_best = max(best);
mx_mn_best = max_best-min_best;
mx_mn_best(mx_mn_best == 0) = 1e-8;
bestA   = (bestA-min_best)./(mx_mn_best);
bestB   = (bestB-min_best)./(mx_mn_best);

best = [bestA;bestB];
Score_best = best*w;
%% mean Solution
meanA1 = mean(A1);
meanA2 = mean(A2);
meanB1 = mean(B1);
meanB2 = mean(B2);

mean1 = [meanA1;meanB1];
mean2 = [meanA2;meanB2];
i = mean2 == 0;
j = ~i;
meanA = zeros(size(meanA1));
meanB = zeros(size(meanB1));
for kk = 1:length(function_range)
    
    if sum(i(:,kk))==0
        meanA(:,kk) = meanA2(:,kk);
        meanB(:,kk) = meanB2(:,kk);
    else 
        M = max(mean1(i(:,kk),kk));
        meanA(i(1,kk),kk) = meanA1(i(1,kk),kk);
        meanB(i(2,kk),kk) = meanB1(i(2,kk),kk);
        %%
        meanA(j(1,kk),kk) = M + meanA2(j(1,kk),kk);
        meanB(j(2,kk),kk) = M + meanB2(j(2,kk),kk);
    end
end
men = [meanA;meanB];
min_mean = min(men);
max_mean = max(men);
mx_mn_mean = max_mean-min_mean;
mx_mn_mean(mx_mn_mean == 0) = 1e-8;
meanA   = (meanA-min_mean)./(mx_mn_mean);
meanB   = (meanB-min_mean)./(mx_mn_mean);
men = [meanA;meanB];
Score_mean = men*w;
%% median Solution
medA1 = A1(13,:);
medA2 = A2(13,:);
medB1 = B1(13,:);
medB2 = B2(13,:);
med1 = [medA1;medB1];
med2 = [medA2;medB2];
i = med2 == 0;
j = ~i;
medA = zeros(size(medA1));
medB = zeros(size(medB1));
for kk = 1:length(function_range)
    
    if sum(i(:,kk))==0
        medA(:,kk) = medA2(:,kk);
        medB(:,kk) = medB2(:,kk);
    else 
        M = max(med1(i(:,kk),kk));
        medA(i(1,kk),kk) = medA1(i(1,kk),kk);
        medB(i(2,kk),kk) = medB1(i(2,kk),kk);
        %%
        medA(j(1,kk),kk) = M + medA2(j(1,kk),kk);
        medB(j(2,kk),kk) = M + medB2(j(2,kk),kk);

    end
end
med = [medA;medB];
min_med = min(med);
max_med = max(med);
mx_mn_med = max_med-min_med;
mx_mn_med(mx_mn_med == 0) = 1e-8;
medA   = (medA-min_med)./(mx_mn_med);
medB   = (medB-min_med)./(mx_mn_med);

med = [medA;medB];
Score_med = med*w;
%% final score
%Algorithm = ['SASS-MODE 0.1';'SASS-MODE 0.2';'SASS-MODE 0.3';'SASS-MODE 0.4';'SASS-MODE 0.5';'SASS-MODE 0.6';'SASS-MODE 0.7';'SASS-MODE 0.8';'SASS-MODE 0.9';];
Total_Score = 0.5*Score_best+0.3*Score_mean+0.2*Score_med;
[~,ii] = sort(Total_Score); Rank(ii) = 1:2;
% Final_score = [Score_best,Score_mean,Score_med, 0.5*Score_best+0.3*Score_mean+0.2*Score_med]
disp('========================================================================');
disp('=====================Ranking of Algorithm on RWCOP======================');
disp('========================================================================');
fprintf('     Algorithm     Score1     Score2      Score3    Total Score    Rank\n');
for i = 1:2
    fprintf('%s %s %s %8.4f   %8.4f    %8.4f    %8.4f %s   %d\n',['   '], Algorithm(i,:), ['  '],  Score_best(i), Score_mean(i), Score_med(i), Total_Score(i), ['    '], Rank(i));
end
disp('========================================================================');
disp('========================================================================');
%% printing on text file
fileID = fopen('Scoring.txt','w');
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'=====================Ranking of Algorithm on RWCOP======================\n');
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'  Algorithm     Score1     Score2      Score3    Total Score    Rank\n');
for i = 1:2
    fprintf(fileID,'%s %s %s %8.4f   %8.4f    %8.4f    %8.4f %s   %d\n',['   '], Algorithm(i,:), ['  '],  Score_best(i), Score_mean(i), Score_med(i), Total_Score(i), ['    '], Rank(i));
end
fprintf(fileID,'========================================================================\n');
fprintf(fileID,'========================================================================\n');

bar([Score_best*0.5,Score_mean*0.3,Score_med*0.2],'stacked')
legend('best','mean','median','Location','northwest')
xlabel('proprotion')
ylabel('Total score')
set(gca,'XTickLabel',{"0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9"})
