clear all;
load ../settings;
load settingsFigure;
load ../data/nOptimal;
fontsizeOriginal = fontsize;
fontsize = fontsizeOriginal + 8 ;

%% read csv
info = csvread(strcat('../data/', caseName, '/stdMeanPairs.csv'));
portStdNew = info(:, 1);
portMeanNew = info(:, 2);
info = csvread(strcat('../data/', caseName, '/wMatrix.csv'));
portWeights = info;

wOptimal = portWeights(:,nOptimal);
save('wOptimal','wOptimal');
portMeanOptimal = portMeanNew(nOptimal);
portStdOptimal = portStdNew(nOptimal);

%% 
markersize = markersize + 5;
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold(axes1,'all');
hold on;
grid on;
box on;
xlim(axes1,[0,0.5]);
ylim(axes1,[0.05,0.3]);
plot(portStdNew, portMeanNew, 'marker', '.', 'markersize', markersize, 'color', 'b','linewidth',linewidth);
plot(portStdOptimal, portMeanOptimal, 'color','b','marker','o','markersize',markersize,'linewidth',linewidth);
load ../data/supplies;
plot(std(supplyGoogle), mean(supplyGoogle), 'color','r','marker','x','markersize',markersize,'linewidth',linewidth);
plot(std(supplyAzure), mean(supplyGoogle), 'color','r','marker','square','markersize',markersize,'linewidth',linewidth);
load ../data/ds_filtered;
for n = 1:length(ds)
	plot(ds(n).stdWindPower, ds(n).meanWindPower, 'marker', '+', 'markersize',markersize,'linewidth',linewidth);
	plot(ds(n).stdSolarPower, ds(n).meanSolarPower, 'marker', '^', 'markersize',markersize,'linewidth',linewidth);
end

hold off;

xlabel('Standard Deviation of Power Supply (Watt)','fontsize',fontsize);
ylabel('Expectation of Power Supply (Watt)','fontsize',fontsize);
%legend('Efficient Frontier', 'Optimal Portfolio', 'Google Data Centers', 'Single Wind Power', 'Single Solar Power');%,'KELN','KACK','KBKL','KFAR','KMFE');
legend('Efficient Frontier', 'Optimal Portfolio', 'Google Data Centers', 'Azure Data Centers', 'Single Wind Power', 'Single Solar Power');%,'KELN','KACK','KBKL','KFAR','KMFE');

%save('figureCdf', 'xValue', 'histValue', 'xWeighted', 'h');
