function [ pmin, pmax ] = preferenceRangeVec( S )
%preferenceRangeVec Summary of this function goes here
%   Detailed explanation goes here
[p, q] = size(S);

if(p==q)
    [pmin, pmax] = preferencerange(S);
elseif(q==3)
    N=max(max(S(:,1)),max(S(:,2)));
    m1 = -inf.*ones(N,1);
    m = zeros(N,1);
    for i = 1:N
        ii1 = S(:,2) == i;  
        ii2 = S(:,1) == i;
        ii = or(ii1,ii2);
        if(sum(ii)>0)
            m1(i,1) = sum(S(ii,3));
            m(i,1) = max(S(ii,3));
        end
    end
    
    [dpsim1 , ~]=max(m1);
    % Maximum similarty of each point
    % m=max(S,[],2);
    tmp=sum(m);
    [yy, ii]=min(m);
    tmp=tmp-yy-min(m([1:ii(1)-1,ii(1)+1:N]));
    pmin=dpsim1-tmp;
    if(pmin>0)
        pmin = -1*pmin;
    end
    pmax = max(S(:,3));
end

end

