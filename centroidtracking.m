%%%%%%% centroid tracking by DT %%%%%%
clear
clc

%%% selection of the most representative centroid
% load('Clustering_AAP_topology_N-1_0.95_15000reduced.mat');
load('clstresult_hierarchial_unst.mat');

pat=7175;
nmax=6;

count=0;
stragefreq=zeros(pat,1);
for i=1:pat
    a=length(preservef1(i).Centroidbus);
    stragefreq(count+1:count+a)=preservef1(i).Centroidbus;   % as a colmun vector
    count=count+a;
end

C=zeros(pat,30);    
for i=1:pat
    C(i,preservef1(i).Centroidbus)=1;        % 0-1 matrix that represents the centroid at the same time fro all scenarios
end

%%%% rootnode decision: the most frequent being bus
% [rootnode,F]=mode(stragefreq);
% rfreq=zeros(nmax,2);   % the most representative node and the number of being centroid
% rfreq(1,1)=rootnode;
% rfreq(1,2)=F;

%%%% rootnode decision: arbitorarily select

rfreqstk1=zeros(nmax,30);
rfreqstk2=zeros(nmax,30);
for i=1:30
    rootnode=i;
    F=length(find(stragefreq==rootnode));
    rfreq=zeros(nmax,2);   % the most representative node and the number of being centroid
    rfreq(1,1)=rootnode;
    rfreq(1,2)=F;

    [rfreq] = ctrack(C,rootnode,1,nmax,rfreq);  % the recursive frequency tracking function    
    
    rfreqstk1(:,i)=rfreq(:,1)+9;
    rfreqstk2(:,i)=rfreq(:,2);
end

covind=sum(rfreqstk2)/pat;

%%%% for a bus
rootnode=10;
F=length(find(stragefreq==rootnode));
rfreq=zeros(nmax,2);   % the most representative node and the number of being centroid
rfreq(1,1)=rootnode;
rfreq(1,2)=F;

[rfreq] = ctrack(C,rootnode,1,nmax,rfreq);  % the recursive frequency tracking function

('PMU placement candidates : ');

rfreq(:,1)+9
covind=sum(rfreq(:,2))/pat


%%%% area evaluation assuming that PMU is placed at the representative buses
belongind=zeros(30,nmax);
for l=1:nmax
    for i=1:pat
        for j=1:size(preservef(i).Group)
            if preservef(i).Centroidbus(j,1)==rfreq(l,1)
                belongind(preservef(i).Group{j,1},l)=belongind(preservef(i).Group{j,1},l)+1;
            end
        end
    end
end

