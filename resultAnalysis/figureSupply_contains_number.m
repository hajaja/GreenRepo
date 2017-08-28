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

%%
fontsizeOriginal = fontsize;
fontsize = fontsizeOriginal + 8 ;
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold(axes1,'all');
hold on;
grid on;
box on;
xlim(axes1, [0, 24*31]);
ylim(axes1, [0, 2]);
plot(supplyOptimal(end - span + 1 : end - span + 24 * 31) * ratioCapacity, 'color','b','markersize',markersize,'linewidth',linewidth);
%plot(supplyGoogle(end - span + 1 : end - span + 24 * 31) * ratioCapacity, 'color','r','markersize',markersize,'linewidth',linewidth);
%plot(demand(end - span + 1 : end), 'color','r','markersize',markersize,'linewidth',linewidth);
hold off;

xlabel('Time (Hour)','fontsize', fontsize);
ylabel('Power (Watt)','fontsize',fontsize);
%legend('Supply','Demand','Single');


%% in 20 years, how much power is drawn from the grid?

demandNormalized = demand / mean(demand);

energyDrawnOptimal = demandNormalized - supplyOptimal * ratioCapacity;
energyDrawnOptimal = energyDrawnOptimal(energyDrawnOptimal > 0);
ratioOptimal = sum(energyDrawnOptimal) / sum(demandNormalized)

energyDrawnGoogle = demandNormalized - supplyWindLargest * ratioCapacity;
%energyDrawnGoogle = demandNormalized - supplyCV * ratioCapacity;
energyDrawnGoogle = energyDrawnGoogle(energyDrawnGoogle > 0);
ratioGoogle = sum(energyDrawnGoogle) / sum(demandNormalized)


nYear = 3;
energyDrawnOptimal = demandNormalized - supplyOptimal * ratioCapacity;
energyDrawnOptimal = energyDrawnOptimal(end-365*24*nYear:end-365*24*(nYear-1));
energyDrawnOptimal = max(0, energyDrawnOptimal);

%energyDrawnGoogle = demandNormalized - supplyCV * ratioCapacity;
energyDrawnGoogle = demandNormalized - supplyWindLargest * ratioCapacity;
energyDrawnGoogle = energyDrawnGoogle(end-365*24*nYear:end-365*24*(nYear-1));
energyDrawnGoogle = max(0, energyDrawnGoogle);

demandNormalized = demandNormalized(end-365*24*nYear:end-365*24*(nYear-1));

ratioOptimal = sum(energyDrawnOptimal) / sum(demandNormalized)
ratioGoogle = sum(energyDrawnGoogle) / sum(demandNormalized)

