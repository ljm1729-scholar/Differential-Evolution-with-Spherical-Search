function Historyarchive = updateHistoryArchive(Historyarchive, pop, funvalue, constraint)
% Update the archive with input solutions
%   Step 1: Add new solution to the archive
%   Step 2: Remove duplicate elements 
%   Step 3: If necessary, randomly remove some solutions to maintain the archive size
%
% Version: 1.1   Date: 2008/04/02
% Written by Jingqiao Zhang (jingqiao@gmail.com)

if Historyarchive.NP == 0, return; end

if size(pop, 1) ~= size(funvalue,1), error('check it'); end
%if size(Historyarchive.pop, 1) ~= size(Historyarchive.funvalues,1), error('check it'); end
% Method 2: Remove duplicate elements
popAll = [Historyarchive.pop; pop ];
funvalues = [Historyarchive.funvalues; funvalue ];
convalues = [Historyarchive.convalues; constraint ];
[dummy IX]= unique(popAll, 'rows');
if length(IX) < size(popAll, 1) % There exist some duplicate solutions
  popAll = popAll(IX, :);
  funvalues = funvalues(IX, :);
  convalues = convalues(IX, :);
end

% if size(popAll, 1) <= archive.NP   % add all new individuals
%   archive.pop = popAll;
%   archive.funvalues = funvalues;
%   archive.convalues = constraint;
% else                % randomly remove some solutions
%   rndpos = randperm(size(popAll, 1)); % equivelent to "randperm";
%   rndpos = rndpos(1 : ceil(archive.NP));
%   
%   archive.pop = popAll  (rndpos, :);
%   archive.funvalues = funvalues(rndpos, :);
%   archive.convalues = constraint(rndpose, :);
% end

index=sorting(funvalues,convalues);
popAll=popAll(index,:);
funvalues=funvalues(index,:);
convalues=convalues(index,:);
if size(popAll, 1) <= Historyarchive.NP   % add all new individuals
  Historyarchive.pop = popAll;
  Historyarchive.funvalues = funvalues;
  Historyarchive.convalues = convalues;
else
  numpos = (1 : ceil(Historyarchive.NP));
  Historyarchive.pop = popAll(numpos,:);
  Historyarchive.funvalues = funvalues(numpos,:);
  Historyarchive.convalues = convalues(numpos,:);
end