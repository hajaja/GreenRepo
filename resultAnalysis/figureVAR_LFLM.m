clear all;
load ../settings;
load settingsFigure;
load ../data/supplies;
option = 'hourly';
period = funSetFrequency(option);
percentageVec = [1, 5, 10, 20];
ratioCapacity = 1;

%% prepare the power required 
load ../ExtraPeakLoadMatch/VARCalculation41.mat; 
vecLoadLeap = vecLoad;
vecLoadNonLeap = [vecLoad(1 : 24 * (31 + 28)); vecLoad(24 * (31 + 29) + 1 : end)];

yearStart = 1991;
yearEnd = 2010;

demand = [];
for year = yearStart : yearEnd
    % if leap year
    if mod(year, 4) == 0
        demand = [demand; vecLoadLeap];
    else
        demand = [demand; vecLoadNonLeap];
    end
end
%demand = vecLoadLeap;

demand = demand * maxVecLoad;
supplyOptimal = supplyOptimal * maxVecLoad;
supplyGoogle = supplyGoogle * maxVecLoad;
supplyWindLargest = supplyWindLargest * maxVecLoad;

%% Google
varVec = [];
for n = 1:length(percentageVec)
    nPort = 1;
    varVec(nPort, n) = funVAR(demand - supplyOptimal * ratioCapacity, period, percentageVec(n)); nPort = nPort + 1;
    varVec(nPort, n) = funVAR(demand - supplyGoogle * ratioCapacity, period, percentageVec(n)); nPort = nPort + 1;
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
    'XTickLabel',{'','Optimal','','EqualWeight','','Single',''});
%    'XTickLabel',{'Optimal','Google','Single'});

hold(axes1,'all');
hold on;
grid on;
box on;
%ylim(axes1,[0,ceil(max(max(varVec)) * 1.5 * 100) / 100]);
bar(-varVec);
hold off;

xlabel('Portfolio Type','fontsize',fontsize);
ylabel('VaR (KWh)','fontsize',fontsize);
clear percentageStrVec;
for n = 1:length(percentageVec)
    percentageStrVec(n, :) = strcat(sprintf('%2d', percentageVec(n)), '% VaR');
end
legend(percentageStrVec);
