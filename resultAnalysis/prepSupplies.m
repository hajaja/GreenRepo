clear all;
load ../settings;
load settingsFigure;
load ../data/stateIndexs_using_ds_calculated;
load ../data/ds_calculated;

%% Train or Test
TrainOrTest = 'Train';
if strcmp(TrainOrTest, 'Train')
    nSeqStart = 1;
    nSeqEnd = (365 * 10 + 3)* 24;
elseif strcmp(TrainOrTest, 'Test')
    nSeqStart = (365 * 10 + 3)* 24 +1;
    nSeqEnd = length(ds(1).powerWind);
end
lengthThis = nSeqEnd - nSeqStart + 1;

%% calculate Google supply
if strcmp(portType, 'WindSolar')
    wGoogle = zeros(length(ds)*2, 1);
else
    wGoogle = zeros(length(ds), 1);
end

for n = 1:length(stateIndexs)
    stateIndex = stateIndexs(n);
    if strcmp(portType, 'WindSolar')
        wGoogle(stateIndex) = 1 / (length(stateIndexs) * 2);
        wGoogle(stateIndex + length(ds)) = 1 / (length(stateIndexs) * 2);
    else
        wGoogle(stateIndex) = 1 / length(stateIndexs);
    end
end
supplyGoogle = funComputeWeightedSupply(wGoogle, ds, portType, TrainOrTest);

wGoogleWind = wGoogle(1:length(wGoogle)/2) * 2;
supplyGoogleWind = funComputeWeightedSupply(wGoogle, ds, 'WindOnly', TrainOrTest);

%% AZURE
load ../data/stateIndexs_using_ds_calculated_Azure.mat;
if strcmp(portType, 'WindSolar')
    wAzure = zeros(length(ds)*2, 1);
else
    wAzure = zeros(length(ds), 1);
end

for n = 1:length(stateIndexs)
    stateIndex = stateIndexs(n);
    if strcmp(portType, 'WindSolar')
        wAzure(stateIndex) = 1 / (length(stateIndexs) * 2);
        wAzure(stateIndex + length(ds)) = 1 / (length(stateIndexs) * 2);
    else
        wAzure(stateIndex) = 1 / length(stateIndexs);
    end
end
supplyAzure = funComputeWeightedSupply(wAzure, ds, portType, TrainOrTest);


%% largest mean power
largestMeanPower = 0;
nLocation = 0;
for i = 1:length(ds)
    if largestMeanPower < ds(i).meanWindPower
        largestMeanPower = ds(i).meanWindPower; 
        nLocation = i;
    end
end
supplyWindLargest = ds(nLocation).powerWind(nSeqStart:nSeqEnd);


%% calculate optimal portfolio supply
load ../data/ds_filtered;
load ../data/wOptimal;
supplyOptimal = funComputeWeightedSupply(wOptimal, ds, portType, TrainOrTest);
wEW = wOptimal~=0;
wEW = wEW / sum(wEW);
supplyEW = funComputeWeightedSupply(wEW, ds, portType, TrainOrTest);

matSortCV = [];
for n = 1:length(ds)
    matSortCV = [matSortCV; [n, mean(ds(n).powerWind(nSeqStart:nSeqEnd)) / std(ds(n).powerWind(nSeqStart:nSeqEnd)), mean(ds(n).powerWind(nSeqStart:nSeqEnd))]];
end

matSortCV = sortrows(matSortCV, 2);
wCV = 0 * wEW;
for n = 1:10
    wCV(matSortCV(length(ds)+1-n, 1)) = 1;
end
wCV = wCV / sum(wCV);
supplyCV = funComputeWeightedSupply(wCV, ds, portType, TrainOrTest);

wLargestCV = 0 * wCV;
wLargestCV(matSortCV(length(ds), 1)) = 1;
supplyLargestCV = funComputeWeightedSupply(wLargestCV, ds, portType, TrainOrTest);


matSortCV = sortrows(matSortCV, 3);
wM = 0 * wEW;
for n = 1:10
    wM(matSortCV(length(ds)+1-n, 1)) = 1;
end
wM = wM / sum(wM);
supplyM = funComputeWeightedSupply(wM, ds, portType, TrainOrTest);

%% save
strFileName = strcat('../data/supplies', TrainOrTest);
save(strFileName, 'supplyGoogle', 'supplyOptimal', 'supplyWindLargest', 'supplyEW', 'supplyCV', 'supplyLargestCV', 'supplyM', 'supplyGoogleWind', 'supplyAzure');
