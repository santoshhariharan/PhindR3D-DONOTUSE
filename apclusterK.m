% [idx,netsim,dpsim,expref,pref]=apclusterK(s,k)
%
% Finds approximately k clusters using affinity propagation (BJ Frey and
% D Dueck, Science 2007), by searching for an appropriate preference value
% using a bisection method. By default, the method stops refining the
% number of clusters when it is within 10%% of the value k provided by the
% user. To change this percentage, use apclusterK(s,k,prc) -- eg, setting
% prc to 0 causes the method to search for exactly k clusters. In any case
% the method terminates after 20 bisections are attempted.
%

function [idx,netsim,dpsim,expref,pref]=apclusterK(s,kk,prc,dFact)

if nargin<3 prc=10; dFact = .9; end; % Default percentage error in k
if nargin<4 dFact = .9; end
% Construct similarity matrix and add a tiny amount of noise
if size(s,2)==3
    N=max(max(s(:,1)),max(s(:,2)));
    S=-Inf*ones(N,N);
    for j=1:size(s,1) S(s(j,1),s(j,2))=s(j,3); end;
else N=size(s,1); S=s;
end;
rns=randn('state'); randn('state',0);
S=S+(eps*S+realmin*100).*rand(N,N);
randn('state',rns);
% assignin('base','S',S);
for k=1:N S(k,k)=0; end;

% Find limits
[dpsim1 k11]=max(sum(S,1));
if dpsim1==-Inf
    error('Could not find pmin');
elseif N>1000
    for k=1:N S(k,k)=-Inf; end;
    m=max(S,[],2);
    tmp=sum(m);
    [yy ii]=min(m);
    tmp=tmp-yy-min(m([1:ii(1)-1,ii(1)+1:N]));
    pmin=dpsim1-tmp;
else
    dpsim2=-Inf;
    for j21=1:N-1
        for j22=j21+1:N
            tmp=sum(max(S(:,[j21,j22]),[],2));
            if tmp>dpsim2 dpsim2=tmp; k21=j21; k22=j22; end;
        end;
    end;
    pmin=dpsim1-dpsim2;
end;
for k=1:N S(k,k)=-Inf; end;
pmax=max(S(:));
% pmax=median(median(S(S~=0)));
highpref=pmax; highk=N;
lowpref=pmin; lowk=1;
for k=1:N S(k,k)=0; end;
% fprintf('Bounds: lowp=%f  highp=%f      lowk=%d  highk=%d\n', ...
%     lowpref,highpref,lowk,highk);
% fprintf('Attempting to improve lower bound:\n');

% Run AP several times to find better lower bound
i=-4; dn=0;
while ~dn
    tmppref=highpref-10^i*(highpref-lowpref);
%     fprintf('  Trying p=%f\n',tmppref);
    [idx,netsim,dpsim,expref]=apcluster(S,tmppref,'dampfact',dFact, ...
        'convits',50,'maxits',1000);
    tmpk=length(unique(idx));
%     fprintf('tmpk%i\n',tmpk);
% fprintf('kk%i\n',kk);
% fprintf('i%i\n',i);
    if tmpk<=kk dn=1;
    elseif i==+1 tmpk=lowk; tmppref=lowpref; dn=1;
    else i=i+1;
    end;
end;
% fprintf('tmpk  %i\n',tmpk);
% fprintf('FFT %f\n',abs(tmpk-kk));
% fprintf('prc %f\n',prc);
% Use bisection method to find k
if (abs(tmpk-kk)/kk*100>prc)
    fprintf('Applying bisection method:\n');
    lowk=tmpk; lowpref=tmppref; ntries=0;
    while (abs(tmpk-kk)/kk*100>prc)&&(ntries<20)
%         fprintf('  lowp=%f  highp=%f      lowk=%d  highk=%d\n', ...
%             lowpref,highpref,lowk,highk);
        tmppref=0.5*highpref+0.5*lowpref;
        [idx,netsim,dpsim,expref]=apcluster(S,tmppref,'dampfact',dFact, ...
            'convits',50,'maxits',1000);
        tmpk=length(unique(idx));
        if kk>tmpk lowpref=tmppref; lowk=tmpk;
        else highpref=tmppref; highk=tmpk;
        end;
        ntries=ntries+1;
    end;
end;
pref=tmppref;
fprintf('Found %d clusters using a preference of %f\n',tmpk,pref);
