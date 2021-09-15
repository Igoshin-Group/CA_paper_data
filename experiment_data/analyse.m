clear all
close all
addpath('.\src\Libraries\LAPTracker');
addpath('.\src\Libraries\Utils');
addpath('.\src\Libraries\DensityEstimation');
addpath('.\src\Libraries\DensityEstimation');
addpath('.\src\Libraries\TrajectoryAnalysis');
%addpath('.\src');
MAP=containers.Map();
MAP('1')=['OE TraAB labeled vs nonlabeled at 1 to 250 ratio_DK10410_after 16h_60 frames_1min_interval2.tif'];
%MAP('1')=['.\WT TraAB expression_1to250_labeled.tif'];
%MAP('3')=['E:\New folder\work\pilc\pilc+wt\Pilc-4223w-5 replicates\06202018\4223w2_1\4223w2_1_MMStack_Pos0_2.ome.tif'];
AGG_DESNITY_CUTOFF=0.009;
fname=MAP('1');
poslist1=detectCellsRegionProps(fname,'MinLevel',5);
% % fname=MAP('2');
% % poslist2=detectCellsRegionProps(fname,'MinLevel',30);
% % fname=MAP('3');
% % poslist3=detectCellsRegionProps(fname,'MinLevel',30);
% % poslist=combinePosLists(poslist1,poslist2,poslist3);
% % save('poslistall','poslist');
[ tracks1, NO_LINKING_COST, CUTOFFS, deltaD,deltaO,displacement] = LAPtracking(poslist1, ...
                                                   'Debug',true, ...
                                                   'MinTrackLength',40, ...
                                                   'MaxSliceGap',3, ...
                                                   'GapClosingSearchRadiusCutoff',20, ...
                                                   'EndCostMutiplier',1.1, ...
                                                   'IncludePosListIndex',true, ...
                                                   'NoiseCutoff',1, ...
                                                   'EndCostSeed',15, ...
                                                   'NoLinkingMinCost',2,...
                                                   'NoGapClosing',false);
% % [ tracks2, NO_LINKING_COST, CUTOFFS, deltaD,deltaO,displacement] = LAPtracking(poslist2, ...
% %                                                    'Debug',true, ...
% %                                                    'MinTrackLength',10, ...
% %                                                    'MaxSliceGap',3, ...
% %                                                    'GapClosingSearchRadiusCutoff',20, ...
% %                                                    'EndCostMutiplier',1.1, ...
% %                                                    'IncludePosListIndex',true, ...
% %                                                    'NoiseCutoff',1, ...
% %                                                    'EndCostSeed',15, ...
% %                                                    'NoGapClosing',false);  
% % %  [ tracks3, NO_LINKING_COST, CUTOFFS, deltaD,deltaO,displacement] = LAPtracking(poslist3, ...
% %                                                    'Debug',true, ...
% %                                                    'MinTrackLength',10, ...
% %                                                    'MaxSliceGap',3, ...
% %                                                    'GapClosingSearchRadiusCutoff',20, ...
% %                                                    'EndCostMutiplier',1.1, ...
% %                                                    'IncludePosListIndex',true, ...
% %                                                    'NoiseCutoff',1, ...
% %                                                    'EndCostSeed',15, ...
% %                                                    'NoGapClosing',false);                                               
% %tracks=[tracks1];
% %load('tracks');
% %save('tracks','tracks');
% for i = keys(MAP)   
%     k = i{1};
%     K=normalizeImages(MAP(k),['img',k]);
%     %K=floro2dens(K);
%     %save(['knorm',k],'K','-v7.3');
% end
load('img1Knormalized.mat');
%K=zeros(1024,1024,74);
 m_tracks1=createMTracks(tracks1,K);
% % K=load('img2Knormalized.mat');
% % m_tracks2=createMTracks(tracks2,K);
% % K=load('img3Knormalized.mat');
% % m_tracks3=createMTracks(tracks3,K);
 %runvec=createRunVectors(m_tracks1);save('runvec1','runvec');
% % runvec2=createRunVectors(m_tracks2);save('runvec2','runvec2');
% % runvec3=createRunVectors(m_tracks3);save('runvec3','runvec3');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AllData = {};
% k = keys(MAP);
% frac_curves = containers.Map();
% for i = 1:length(MAP)    
%     load(['img',k{i},'Knormalized.mat']);
%     load('tracks');
%     m_tracks=createMTracks(tracks(i),K);
runvec=createRunVectors(m_tracks1);
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