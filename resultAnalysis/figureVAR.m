clear all;
load ../settings;
load settingsFigure;
TrainOrTest = 'Test';
strFileAddress = strcat('../data/supplies', TrainOrTest);
load(strFileAddress);
option = 'monthly';
period = funSetFrequency(option);
percentageVec = [1, 5, 10, 20];
ratioCapacity = 5;

%% prepare the power required 
load ../data/powerRequiredOneDayNormalized_google_hourly.mat
%load ../data/powerRequiredOneDayNormalized_UWI_hourly.mat
%powerDemand = powerRequiredOneDayNormalizedSmoothed;
powerDemand = powerRequiredOneDayNormalized;
numRepeat = length(supplyGoogle) / length(powerDemand);
demand = [];
for n = 1:numRepeat
    demand = [demand; powerDemand];
end

%% Google
varVec = [];
for n = 1:length(percentageVec)
    nPort = 1;
    varVec(nPort, n) = funVAR(demand - supplyOptimal * ratioCapacity, period, percentageVec(n)); nPort = nPort + 1;
    varVec(nPort, n) = funVAR(demand - supplyGoogle * ratioCapacity, period, percentageVec(n)); nPort = nPort + 1;
    %varVec(nPort, n) = funVAR(demand - supplyCV * ratioCapacity, period, percentageVec(n)); nPort = nPort + 1;
    varVec(nPort, n) = funVAR(demand - supplyWindLargest * ratioCapacity, period, percentageVec(n)); nPort = nPort + 1;
end

%% temp 
if 0
    figure;
    hold on;
    plot(demand, 'r');
    plot(supplyWind504 * ratioCapacity, 'b');
    hold off;
end
%% plot figures
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize - 5,'linewidth',linewidth, ...
    'XTickLabel',{'','Optimal','','Google','','Single',''});
%    'XTickLabel',{'Optimal','Google','Single'});

hold(axes1,'all');
hold on;
grid on;
box on;
%ylim(axes1,[0,ceil(max(max(varVec)) * 1.5 * 100) / 100]);
bar(-varVec);
hold off;

xlabel('Portfolio Type','fontsize',fontsize);
ylabel('VaR (MWh)','fontsize',fontsize);
clear percentageStrVec;
for n = 1:length(percentageVec)
    percentageStrVec(n, :) = strcat(sprintf('%2d', percentageVec(n)), '% VaR');
end
legend(percentageStrVec);
