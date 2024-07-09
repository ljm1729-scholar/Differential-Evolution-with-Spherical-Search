function X=SetInitialPopulaionOfCMODE(History_SASS,N)
%X=zeros(N,length(History_SASS.pop{1}(1,:)));
temp_pop=[];
temp_obj=[];
temp_con=[];
for i=1:length(History_SASS.con)
    temp_pop=[temp_pop;History_SASS.pop{i}];
    temp_obj=[temp_obj,History_SASS.obj{i}];
    temp_con=[temp_con,History_SASS.con{i}];
    [~,ia,~]=unique(temp_pop,'rows');
    temp_pop=temp_pop(ia,:); temp_obj=temp_obj(ia); temp_con=temp_con(ia);
    index=sorting(temp_obj',temp_con');
    index=index(1:N);
    temp_pop=temp_pop(index,:);
    temp_obj=temp_obj(index);
    temp_con=temp_con(index);
end    
X=[temp_pop;History_SASS.pop{i}];
[~,ia,~]=unique(X,'rows');
X=X(ia,:);
