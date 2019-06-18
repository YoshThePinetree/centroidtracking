function [rfreq] = ctrack(C,r,n,nmax,rfreq)
    if n>=nmax
        
    else
        C1=C;
        C1(:,r)=0;   % delete the rootnode from C
        count=0;
        stragefreq=zeros(size(C1,1),1);
        for i=1:size(C1,1)
            if C(i,r)==1
                a=find(C1(i,:));
                stragefreq(count+1:count+length(a))=a';   % as a colmun vector
                count=count+length(a);
            end
        end
        stragefreq(stragefreq==0)=[];
        [r1,F]=mode(stragefreq);

        rfreq(n+1,1)=r1;
        rfreq(n+1,2)=sum(C(:,r1));
        
%         rfreq(n+1,2)=F;

        C(:,r)=0;   % delete the rootnode from C
        r=r1;   % new root node
        
        [rfreq] = ctrack(C,r,n+1,nmax,rfreq);
    end
end

