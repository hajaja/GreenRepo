clear all;
load ../data/ds_filtered.mat;
%load ../data/powerRequired_google;
load ../data/avgPowerRequired_google_hourly.mat;
load ../data/powerRequiredOneDayNormalized_google_hourly.mat;

%% read CPLEX result
weightCplex = csvread('C:\Yun\workspace\Portfolio\wOptimal.csv');
weightCplex = reshape(weightCplex, [], 1);

weightNaive = 1/length(weightCplex)*ones(length(weightCplex), 1);
weightNaive2 = 2/length(weightCplex)*[ones(length(weightCplex)/2, 1); zeros(length(weightCplex)/2, 1)];
weightNaive3 = 2/length(weightCplex)*[zeros(length(weightCplex)/2, 1); ones(length(weightCplex)/2, 1)];
%wOptimal = weightNaive;
wOptimal = weightCplex;

%% repo
m=0;
numLocations = length(wOptimal) / 2;
lengthThis = length(ds(1).powerWind);
for n = 1:length(wOptimal)
    if wOptimal(n) > 0.001;
        m = m+1;
        selectedFarm(m) = n;
    end
end

wResize = 0*wOptimal;
safeSpeed = 35/1.15/1.39;
cutinSpeed = 7/1.15/1.39;

for n = 1:lengthThis
    powerMatrix = zeros(length(wOptimal), 1);
    for m = 1:length(selectedFarm)
        if selectedFarm(m) <= numLocations
            if ds(selectedFarm(m)).powerWind(n) ~= 63
                powerMatrix(selectedFarm(m)) = ds(selectedFarm(m)).powerWind(n);
                wResize(selectedFarm(m)) = wOptimal(selectedFarm(m));
            else
                wResize(selectedFarm(m)) = 0;
            end
        else
            wResize(selectedFarm(m)) = wOptimal(selectedFarm(m));
            powerMatrix(selectedFarm(m)) = ds(selectedFarm(m) - numLocations).powerSolar(n);
        end
    end
    sumResize(n) = sum(wResize);
    if sum(wResize) == 0
        weightedPower(n) = weightedPower(n-1);
    else
        wResize = wResize/sum(wResize);
        weightedPower(n) = wResize' * powerMatrix;
    end
end

%installedCapacity = googleEnergyPerHour;
installedCapacity = avgPowerRequired;
%repoSupply = installedCapacity * weightedPower;
repoSupply = installedCapacity * weightedPower;

%% energy drawn 
% startOfGoogleTrace = 28 * 24 * 12;
% endOfGoogleTrace = (28 + 29) * 24 * 12 - 1;
% weightedPower = repoSupply(startOfGoogleTrace : endOfGoogleTrace);
% endPointGoogleTrace = 5 * 12;
% powerRequired = [powerRequired(endPointGoogleTrace + 1: end); powerRequired(1:endPointGoogleTrace)];

powerRequiredOneDay = powerRequiredOneDayNormalized;
weightedPower = repoSupply * 0;
powerRequiredRepeated = [];
numRepeat = length(weightedPower) / length(powerRequiredOneDay);
for n = 1:numRepeat
    powerRequiredRepeated = [powerRequiredRepeated; powerRequiredOneDay];
end
powerRequiredRepeated = reshape(powerRequiredRepeated, [], 1);

energy = 0;
ratioRatedOverDemand = 5;
for t = 1:length(weightedPower)
    energy = energy + max(0, powerRequiredRepeated(t) - weightedPower(t)*ratioRatedOverDemand) * (5/60);
end
energy
%figure;plot(powerRequiredRepeated, 'b');hold;plot(weightedPower * ratioRatedOverDemand, 'r');