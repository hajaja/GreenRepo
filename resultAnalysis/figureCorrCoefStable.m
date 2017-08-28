clear all;
load ../settings;
load settingsFigure;
load ../data/ds_filtered;
load ../data/wOptimal;

NLocation = length(ds);
NTime = length(ds(1).powerWind);
matCorr1 = zeros(NLocation, NLocation);
matCorr2 = zeros(NLocation, NLocation);
for i = 1:NLocation
    for j = i:NLocation
        powerWindA = ds(i).powerWind;
        powerWindB = ds(j).powerWind;
        temp = corrcoef(powerWindA(1:NTime/2), powerWindB(1:NTime/2));
        matCorr1(i, j) = temp(1,2);
        matCorr1(j, i) = temp(1,2);
        
        temp = corrcoef(powerWindA(NTime/2:end), powerWindB(NTime/2:end));
        matCorr2(i, j) = temp(1,2);
        matCorr2(j, i) = temp(1,2);

    end
end

matDifference = (matCorr1 - matCorr2) ./ (matCorr1 + matCorr2) * 2;
matDifference = (matCorr1 - matCorr2);
[X, Y] = meshgrid(1:NLocation);
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, 'linewidth', linewidth);
view(axes1,[-37.5 30]);
grid(axes1,'on');
hold(axes1,'all');
mesh(X,Y,abs(matDifference),'Parent',axes1, 'linewidth', linewidth);
xlabel('location');
ylabel('location');
zlabel('coefficient');
%zlim([-1, 1]);
%% mean, std
vecMean1 = [];
vecMean2 = [];
vecStd1 = [];
vecStd2 = [];
for n = 1:length(ds)
	powerWindA = ds(n).powerWind;
    mean1 = mean(powerWindA(1:NTime/2));
    mean2 = mean(powerWindA(NTime/2:end));
    std1 = std(powerWindA(1:NTime/2));
    std2 = std(powerWindA(NTime/2:end));
    vecMean1 = [vecMean1; mean1];
    vecMean2 = [vecMean2; mean2];
    vecStd1 = [vecStd1; std1];
    vecStd2 = [vecStd2; std2];
end
mean(abs(vecMean1 - vecMean2)) / mean(vecMean1 + vecMean2) * 2
mean(abs(vecStd1 - vecStd2)) / mean(vecStd1 + vecStd2) * 2

%% mean
figure1 = figure;
%box on;
%grid on;
axes1 = axes('Parent',figure1,'FontSize',fontsize, 'linewidth', linewidth);
hold on;
plot(vecMean1, 'b','Parent',axes1, 'linewidth', linewidth);
plot(vecMean2, 'r','Parent',axes1, 'linewidth', linewidth);
legend('1990-2009', '2000-2010');
xlabel('ID of Location');
ylabel('Expectation');
xlim([0, NLocation]);
box on;
grid on;
hold off;

%% std
figure1 = figure;
%box on;
%grid on;
axes1 = axes('Parent',figure1,'FontSize',fontsize, 'linewidth', linewidth);
hold on;
plot(vecStd1, 'b','Parent',axes1, 'linewidth', linewidth);
plot(vecStd2, 'r','Parent',axes1, 'linewidth', linewidth);
hold off;
legend('1990-2009', '2000-2010');
xlabel('ID of Location');
ylabel('Stdandard Deviation');
xlim([0, NLocation]);
box on;
grid on;

%% count the coverage of the candidate locations
dictState = containers.Map();
for n = 1:length(ds)
    if dictState.isKey(ds(n).state) == 0
        dictState(ds(n).state) = 1;
    else
        dictState(ds(n).state) = dictState(ds(n).state) + 1;
    end
end
