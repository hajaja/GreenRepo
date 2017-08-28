clear all;
load ../settings;
load settingsFigure;
TrainOrTest = 'Test';
strFileAddress = strcat('../data/supplies', TrainOrTest);
load(strFileAddress);
span = 24 * 31;
ratioCapacity  = 5;


%% prepare the power required 
load ../data/powerRequiredOneDaySmoothed_google_hourly.mat
%powerDemand = powerRequiredOneDayNormalizedSmoothed;
powerDemand = powerRequiredOneDaySmoothed;
numRepeat = length(supplyGoogle) / length(powerDemand);
demand = [];
for n = 1:numRepeat
    demand = [demand; powerDemand];
end


%% in 20 years, how much power is drawn from the grid?
vecRatioOptimal = [];
vecRatioGoogle = [];
vecRatioCapacity = 1:10;

for nRatioCapacity = 1:length(vecRatioCapacity)
    ratioCapacity = vecRatioCapacity(nRatioCapacity);
    
    %demandNormalized = demand / mean(demand);
    demandNormalized = demand / max(demand);
    energyDrawnOptimal = demandNormalized - supplyOptimal * ratioCapacity;
    energyDrawnOptimal = energyDrawnOptimal(energyDrawnOptimal > 0);
    ratioOptimal = sum(energyDrawnOptimal) / sum(demandNormalized)
    vecRatioOptimal = [vecRatioOptimal; ratioOptimal];

    energyDrawnGoogle = demandNormalized - supplyGoogle * ratioCapacity;
    %energyDrawnGoogle = demandNormalized - supplyCV * ratioCapacity;
    energyDrawnGoogle = energyDrawnGoogle(energyDrawnGoogle > 0);
    ratioGoogle = sum(energyDrawnGoogle) / sum(demandNormalized)
    vecRatioGoogle = [vecRatioGoogle; ratioGoogle];
end

%%
fontsizeOriginal = fontsize;
fontsize = fontsizeOriginal + 3;
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth + 0.5);%,'XTickLabel',{'8','16','32','64'});
hold(axes1,'all');
hold on;
grid on;
box on;
xlim(axes1, [min(vecRatioCapacity), max(vecRatioCapacity)]);
ylim(axes1, [0, 80]);
plot(vecRatioCapacity, vecRatioOptimal * 100, 'color','b','markersize',markersize,'linewidth',linewidth, 'linestyle', '-');
plot(vecRatioCapacity, vecRatioGoogle * 100, 'color','r','markersize',markersize,'linewidth',linewidth);
%plot(supplyGoogle(end - span + 1 : end - span + 24 * 31) * ratioCapacity, 'color','r','markersize',markersize,'linewidth',linewidth);

hold off;

xlabel('Capacity Ratio','fontsize', fontsize);
ylabel('Electricity Drawn from Grid (%)','fontsize',fontsize);

legend('MIQP')
