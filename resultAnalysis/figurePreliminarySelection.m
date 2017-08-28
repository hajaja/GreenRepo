clear all;
load ../settings;
load settingsFigure;
%load ../data/ds_calculated;
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

hold on;
grid on;
box on;
plot(stdSpeed(1:numLocations), meanSpeed(1:numLocations),'+','markersize', markersize - 2, 'linewidth', linewidth / 2);
%plot(stdSpeed(numLocations+1:numLocations*2), meanSpeed(numLocations+1:numLocations*2),'^','markersize', markersize - 2, 'linewidth', linewidth / 2);
hold off;
%grid minor;
xlim([0, 0.4]);
ylim([0, 0.3]);

xlabel('Standard Deviation of Power (Watt)','fontsize',fontsize);
ylabel('Expectation of Power (Watt)','fontsize',fontsize);
%legend('Solar Power');
