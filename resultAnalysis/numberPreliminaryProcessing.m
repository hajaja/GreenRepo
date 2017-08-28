clear all;

% all candidiates
load ../data/ds_calculated.mat
vecMeanWindAll = [];
vecMeanSolarAll = [];
vecStdWindAll = [];
vecStdSolarAll = [];
for n = 1:length(ds)
    vecMeanWindAll = [vecMeanWindAll; ds(n).meanWindPower];
    vecMeanSolarAll = [vecMeanSolarAll; ds(n).meanSolarPower];
    vecStdWindAll = [vecStdWindAll; ds(n).stdWindPower];
    vecStdSolarAll = [vecStdSolarAll; ds(n).stdSolarPower];
end

vecCVWindAll = vecStdWindAll ./ vecMeanWindAll;
vecCVSolarAll = vecStdSolarAll ./ vecMeanSolarAll;

% filtered
load ../data/ds_filtered.mat
vecMeanWindFilter = [];
vecMeanSolarFilter = [];
vecStdWindFilter = [];
vecStdSolarFilter = [];
for n = 1:length(ds)
    vecMeanWindFilter = [vecMeanWindFilter; ds(n).meanWindPower];
    vecMeanSolarFilter = [vecMeanSolarFilter; ds(n).meanSolarPower];
    vecStdWindFilter = [vecStdWindFilter; ds(n).stdWindPower];
    vecStdSolarFilter = [vecStdSolarFilter; ds(n).stdSolarPower];
end

vecCVWindFilter = vecStdWindFilter ./ vecMeanWindFilter;
vecCVSolarFilter = vecStdSolarFilter ./ vecMeanSolarFilter;