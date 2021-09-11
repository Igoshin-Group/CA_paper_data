load('fig4.mat')
bar(1:10,Ndata)
hold on
er = errorbar(1:10,Ndata,errN,errN);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off
ylabel('Ratio of Suppressed Cells')
xlabel('Adhesion strength')
figure
bar(1:10,Adata)
hold on
er = errorbar(1:10,Adata,errA,errA);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ylabel('Avg. Adhesion Bond Time (min)')
xlabel('Adhesion strength')