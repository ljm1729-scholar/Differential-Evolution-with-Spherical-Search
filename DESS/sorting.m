function Index=sorting(fitx_f,InfeasibleVal)

[InfeasibleVal,InfeasibleIndex]=sort(InfeasibleVal,'ascend');
fitx_f=fitx_f(InfeasibleIndex);
if min(InfeasibleVal)~=0
    Index=InfeasibleIndex;
else
    FeasibleLength=length(InfeasibleVal(InfeasibleVal==0));
    [~,FeasibleIndex]=sort(fitx_f(1:FeasibleLength),'ascend');
    Index=[InfeasibleIndex(FeasibleIndex);InfeasibleIndex(FeasibleLength+1:end)];
end