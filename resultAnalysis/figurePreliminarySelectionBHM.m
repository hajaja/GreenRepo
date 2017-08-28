clear all;
load ../settings;
load settingsFigure;

load ../data/ds_filtered;
numLocations = length(ds);
meanSpeed = zeros(numLocations * 2, 1);
stdSpeed = zeros(numLocations * 2, 1);
for i = 1:numLocations
    meanSpeed(i) = ds(i).meanWindPower;
    stdSpeed(i) = ds(i).stdWindPower;
    meanSpeed(i + numLocations) = ds(i).meanSolarPower;
    stdSpeed(i + numLocations) = ds(i).stdSolarPower;
end


load ../data/ds_calculated;
numLocationsAll = length(ds);
meanSpeedAll = zeros(numLocationsAll * 2, 1);
stdSpeedAll = zeros(numLocationsAll * 2, 1);
for i = 1:numLocationsAll
    meanSpeedAll(i) = ds(i).meanWindPower;
    stdSpeedAll(i) = ds(i).stdWindPower;
    meanSpeedAll(i + numLocationsAll) = ds(i).meanSolarPower;
    stdSpeedAll(i + numLocationsAll) = ds(i).stdSolarPower;
end

%% read csv
info = csvread(strcat('../data/', caseName, '/stdMeanPairs.csv'));
portStd = info(:,1);
portMean = info(:,2);
portTotal = info(:,3);

% info = csvread('ccplex182.csv');
% portStd182 = info(:,1)*fixHeight;
% portMean182 = info(:,2)*fixHeight;
% portTotal182 = info(:,3);

%% plot

figure1 = figure ;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});

grid on;
box on;
hold on;

plot(stdSpeedAll(1:numLocationsAll), meanSpeedAll(1:numLocationsAll),'r+','markersize', markersize - 2, 'linewidth', linewidth / 2);
plot(stdSpeed(1:numLocations), meanSpeed(1:numLocations), 'b^', 'markersize', markersize - 2, 'linewidth', linewidth / 2);
%plot(stdSpeedAll(numLocationsAll+1:numLocationsAll*2), meanSpeedAll(numLocationsAll+1:numLocationsAll*2),'r+','markersize', markersize - 2, 'linewidth', linewidth / 2);
%plot(stdSpeed(numLocations+1:numLocations*2), meanSpeed(numLocations+1:numLocations*2),'b^','markersize', markersize - 2, 'linewidth', linewidth / 2);
hold off;
%grid minor;
xlim([0, 0.4]);
ylim([0, 0.3]);

xlabel('Standard Deviation of Power (Watt)','fontsize',fontsize);
ylabel('Expectation of Power (Watt)','fontsize',fontsize);
legend('All', 'Selected');
