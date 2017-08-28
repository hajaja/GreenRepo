clear all;
load ../settings.mat
load('../wind/ds_merged_fanxin');
speedThis = ds(1).speed;
if strcmp(trainType, '19902000')
    lengthThis = (365 * 10 + 3)* 24;
else
    lengthThis = length(speedThis);
end

lengthDs = length(ds);
%lengthDs = 100;
for n = 1:lengthDs
    n
    dataWind = ds(n);
    power = dataWind.powerWind(1:lengthThis);
    t = 1;
    for k = 1:lengthThis
        if(power(k)==63)
            continue;
        else
            powerThis(t) = power(k);
            t = t+1;
        end
    end
    ds(n).meanWindPower = mean(powerThis);
    ds(n).stdWindPower = std(powerThis);
    ds(n).meanSolarPower = mean(ds(n).powerSolar(1:lengthThis));
    ds(n).stdSolarPower = std(ds(n).powerSolar(1:lengthThis));
end
save('../data/ds_calculated', 'ds', '-v7.3');

%% sort all locations with wind power cv
%load ('../data/ds_calculated');
numCandidates = 50;

% select top 50 locations
m = 1;
arrayRequired = [];

% CA
cvMax = 1000;
nMax = 0;
for n = 1:lengthDs
    n
    if ds(n).stdWindPower / ds(n).meanWindPower <= cvMax && strcmp(ds(n).state, 'CA')
        cvMax = ds(n).stdWindPower / ds(n).meanWindPower;
        nMax = n;
    end
end
dsFiltered(m) = ds(nMax);
arrayRequired = [arrayRequired, nMax];
m = m+1;

% MA
cvMax = 1000;
nMax = 0;
for n = 1:lengthDs
    if ds(n).stdWindPower / ds(n).meanWindPower <= cvMax && strcmp(ds(n).state, 'MA')
        cvMax = ds(n).stdWindPower / ds(n).meanWindPower;
        nMax = n;
    end
end
dsFiltered(m) = ds(nMax);
arrayRequired = [arrayRequired, nMax];
m = m+1;

% FL
cvMax = 1000;
nMax = 0;
for n = 1:lengthDs
    if ds(n).stdWindPower / ds(n).meanWindPower <= cvMax && strcmp(ds(n).state, 'FL')
        cvMax = ds(n).stdWindPower / ds(n).meanWindPower;
        nMax = n;
    end
end
dsFiltered(m) = ds(nMax);
arrayRequired = [arrayRequired, nMax];
m = m+1;

% others
meanWindPowerArray = [];
stdWindPowerArray = [];
for n = 1:lengthDs
    if ismember(n, arrayRequired) == 0
        meanWindPowerArray(n) = ds(n).meanWindPower;
        stdWindPowerArray(n) = ds(n).stdWindPower;
    end
end
cvWindPowerArray =stdWindPowerArray ./ meanWindPowerArray;
cvWindPowerArraySorted = sort(cvWindPowerArray);

cvThreshold = cvWindPowerArraySorted(numCandidates - (m-1));
for n = 1:lengthDs
    if ds(n).stdWindPower / ds(n).meanWindPower <= cvThreshold && ismember(n, arrayRequired) == 0
        dsFiltered(m) = ds(n);
        m = m + 1;
    end
end

%% save
ds = dsFiltered;
save('../data/ds_filtered', 'ds', '-v7.3');
