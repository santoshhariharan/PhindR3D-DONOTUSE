function pval = enrich_score_Binom(rawmat,refProb)

pval = zeros(size(rawmat));
clustersize = sum(rawmat);
for i=1:size(rawmat,1)
    for j=1:size(rawmat,2)
        pval(i,j) = 1-binocdf(rawmat(i,j)-1,clustersize(1,j),refProb(i));
%          = 1-hygecdf(rawmat(i,j)-1,sum(funcsize),funcsize(i,1),clustersize(1,j));
    end
end
end