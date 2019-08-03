function list = BOOMshufWG(sze, cnt)
% July2019

% sz inputs in truth table; cnt number of minterms dealt

% finds cnt amount of random integer decimal minterms 

% sze = 2^sz;
list=[1:sze] ;

for max = 1:cnt
left = sze - (max-1);
mark = round(rand(1)*left+0.5);

now = list(mark);    %subtract 1?  

% swap mark with left in list
list(mark) = list(left);
list(left) = now; 
end % of max 
list = list(sze-cnt+1:sze)'; % transpose


end

