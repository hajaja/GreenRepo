clear all;
load settingsFigure;
%load ../calculateCoefficient/ds_filtered.mat;
load ../data/stateIndexs_using_ds_calculated;
load ../data/ds_calculated.mat;
load ../data/wOptimal;
numExampleLocations = 4;
colorVec = ['r', 'k', 'g', 'y'];
option = 'weekly';
optionPower = 'Wind';

if strcmp(optionPower, 'Wind')
    unit = 'Speed (m/s)';
elseif strcmp(optionPower, 'Solar')
    unit = 'Irradiation (KW/m^2)';
else
    disp('Error: figureWindSpeed, unknown optionPower = %s', optionPower);
end
%% wind speed
period = funSetFrequency(option);
% stateIndexs = [];
% for n = 1:length(wOptimal);
%     if wOptimal(n) > 0;
%         stateIndexs = [stateIndexs; n];
%     end
% end
xOptimal = 1:period;
xOptimal = reshape(xOptimal, [], 1);
tracesSpeed = zeros(length(xOptimal), numExampleLocations);
for n = 1:numExampleLocations
    index = stateIndexs(n);
    if strcmp(optionPower, 'Wind')
        trace = ds(index).speed(end - period + 1: end);
    elseif strcmp(optionPower, 'Solar')
        trace = ds(index).radiation(end - period + 1: end) / 1000;
    else
        disp('Error: figureWindSpeed, unknown optionPower = %s', optionPower);
    end
    tracesSpeed(:, n) = trace;
    [x, y] = funCDF(trace, 'hourly');
    tracesPDF(:, n) = y;
    tracesPDFX(:, n) = x;
end
traceSpeedMean = mean(tracesSpeed, 2);
[x, tracePDFMean] = funCDF(traceSpeedMean, 'hourly');
%% speed
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold on;
grid on;
box on;
for n = 1:numExampleLocations
    %plot(xOptimal, tracesSpeed(:, n), 'color',colorVec(n), 'marker', 'x', 'markersize',markersize,'linewidth',linewidth);
    plot(xOptimal, tracesSpeed(:, n), 'x', 'color',colorVec(n), 'markersize',markersize,'linewidth',linewidth);
end
plot(xOptimal, traceSpeedMean, 'color', 'b', 'markersize',markersize,'linewidth',linewidth);
hold off;
xlabel('Time (hour)');
ylabel(unit);
xlim([0, max(xOptimal)]);
legend([stateNames(1:numExampleLocations, :); 'M '])

%% PDF
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold on;
grid on;
box on;
for n = 1:numExampleLocations
    plot(tracesPDFX(:,n), tracesPDF(:, n), 'color',colorVec(n), 'markersize',markersize,'linewidth',linewidth);
end
plot(x, tracePDFMean, 'color', 'b', 'markersize',markersize,'linewidth',linewidth);
hold off;

xlabel(unit);
ylabel('Probability');
%xlim([0, max(x)]);
xlim([0, 10]);
ylim([0, 1]);
legend([stateNames(1:numExampleLocations, :); 'M '])