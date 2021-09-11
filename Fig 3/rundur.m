load('mtracks.mat')
cellcount=0;
brk=[];
dur2=[];
x=[];
y=[];
reversalcount=0;
for j = unique(runvec.id)'
    k=runvec.id==j;
    s=min(runvec.start.frame(k));
    e=max(runvec.stop.frame(k));
    pox=runvec.start.x(k);
    poy=runvec.start.y(k);
    if e-s>55
        cellcount=cellcount+1;
        states=runvec.state(k);
        starts=runvec.start.frame(k);
        ends=runvec.stop.frame(k);
        dir=-1;
        for i=1:length(states)
            if states(i)<3
                if dir==-1
                    dir=states(i);
                end
                if dir>0&&states(i)~=dir
                    brk=[brk,starts(i)-s];
                    s=starts(i);
                    reversalcount=reversalcount+1;
                    dir=states(i);
                    x=[x,pox(i)];
                    y=[y,poy(i)];
                end
            end

        if i==length(states)                       
                    brk=[brk,ends(i)-s];
        end

        end
        
    end
end
for i = unique(m_tracks1.id)'
plot(m_tracks1.x(m_tracks1.id==i),m_tracks1.y(m_tracks1.id==i))
hold on
end
%plot(x,y,'xk')
figure
histogram(brk,'Normalization','probability')