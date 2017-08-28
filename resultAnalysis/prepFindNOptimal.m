clear all;
load ../settings;
TrainOrTest = 'Train';

%%
info = csvread(strcat('../data/', caseName, '/stdMeanPairs.csv'));
portStdNew = info(:, 1);
portMeanNew = info(:, 2);
info = csvread(strcat('../data/', caseName, '/wMatrix.csv'));
portWeights = info;
if 0 
if strcmp(suffix, 'Relative')
    [a,b] = min(portStdNew);
    nOptimal = b;
else
    differenceNew = portMeanNew - portStdNew;
    [a,b] = max(differenceNew);
    nOptimal = b;
end

wOptimal = portWeights(b, :);
wOptimal = reshape(wOptimal, [], 1);
save('../data/nOptimal', 'nOptimal');
save('../data/wOptimal', 'wOptimal');

figure;
plot(portStdNew, portMeanNew);
end 
%% find nOptimal according to quantile
load settingsFigure;

fontsize = fontsize - 5;
load ../data/ds_filtered;
vecAlpha = [0.1, 0.2, 0.3, 0.4];
matQuantile = zeros(length(portStdNew), length(vecAlpha));
for nOptimal = 1:length(portStdNew)
    wOptimal = portWeights(nOptimal, :);
    wOptimal = reshape(wOptimal, [], 1);
    supplyOptimal = funComputeWeightedSupply(wOptimal, ds, portType, TrainOrTest);
    for nAlpha = 1:length(vecAlpha)
        matQuantile(nOptimal, nAlpha) = quantile(supplyOptimal, vecAlpha(nAlpha));
    end
end

for nAlpha = 1:length(vecAlpha)
    figure1 = figure;
    axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
    hold(axes1,'all');
    hold on;
    grid on;
    box on;    
    [a,b] = max(matQuantile(:, nAlpha));
    plot(portStdNew(b), a, 'o', 'markersize', markersize, 'linewidth', linewidth);
    plot(portStdNew, matQuantile(:, nAlpha), 'linewidth', linewidth);
    hold off;
    xlabel('Standard Deviation of Power Supply (Watt)','fontsize',fontsize);
    ylabel(strcat(num2str(vecAlpha(nAlpha) * 100), '-th Percentile of Power Supply (Watt)'),'fontsize',fontsize);
    legend('Highest Percentile');
end

%% determine port according to the 30-th percentile
[a,b] = max(matQuantile(:, 3));
nOptimal = b;
wOptimal = portWeights(b, :);
save('../data/nOptimal', 'nOptimal');
save('../data/wOptimal', 'wOptimal');

%% calculate the wind and solar 10th, 20th, 30th, and 40th percentile
matQuantileWind = zeros(length(ds), length(vecAlpha));
matQuantileSolar = zeros(length(ds), length(vecAlpha));

for nLocation = 1:length(ds)
    for nAlpha = 1:length(vecAlpha)
        matQuantileWind(nLocation, nAlpha) = quantile(ds(nLocation).powerWind, vecAlpha(nAlpha));
        matQuantileSolar(nLocation, nAlpha) = quantile(ds(nLocation).powerSolar, vecAlpha(nAlpha));
    end
end
