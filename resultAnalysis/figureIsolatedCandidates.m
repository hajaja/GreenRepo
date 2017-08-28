clear all;
load ../settings;
load settingsFigure;
load ../calculateCoefficient/ds_calculated;

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
info = csvread(strcat('data/', caseName, '/stdMeanPairs.csv'));
portStd = info(:,1);
portMean = info(:,2);
portTotal = info(:,3);

% info = csvread('ccplex182.csv');
% portStd182 = info(:,1)*fixHeight;
% portMean182 = info(:,2)*fixHeight;
% portTotal182 = info(:,3);

%% plot

figure1 = figure ;
%axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});

hold on;
grid on;
box on;
%xlim(axes1,[0 6000])
%ylim(axes1,[-0.2 1])

[AX,H1,H2] = plotyy(portStd,portMean,portStd,portTotal);
% H3 = plot(portStd182, portMean182,'r');

set(get(AX(1),'Ylabel'),'string', 'Expected Wind Power Strength','fontsize', fontsize, 'linewidth', linewidth);
set(H1, 'linewidth', linewidth);
set(H2, 'marker','square','markersize', markersize, 'linestyle','none', 'linewidth', linewidth);
set(get(AX(2),'Ylabel'),'String','Total Number in The Portfolio','fontsize', fontsize, 'linewidth', linewidth);
set(AX(2),'yTick',[0:10:60],'ycolor','k', 'fontsize', fontsize);

set(AX(2),'fontsize',fontsize);
set(AX(1),'fontsize',fontsize);
set(H2, 'color','k','linestyle','-','linewidth',linewidth);
xlim(AX(1),[0.08, 0.3]);
ylim(AX(1),[0, 0.3]);

xlim(AX(2),[0.08, 0.3]);
ylim(AX(2),[0, 50]);

plot(stdSpeed(1:numLocations), meanSpeed(1:numLocations),'+','markersize', markersize);
plot(stdSpeed(numLocations+1:numLocations*2), meanSpeed(numLocations+1:numLocations*2),'^','markersize', markersize);
hold off;
grid minor;

xlabel('Standard Deviation of Power (Watt)','fontsize',fontsize);
ylabel('Expectation of Power (Watt)','fontsize',fontsize);
legend('Efficient Frontier',...
    'Wind Power',...
    'Solar Power',...
    'Total Locations in Portfolio');
