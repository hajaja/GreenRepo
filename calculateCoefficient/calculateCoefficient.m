clear all;
load ../settings;
load('../data/ds_filtered');
numLocations = length(ds);
ds = ds(1:numLocations);
if strcmp(trainType, '19902000')
    lengthThis = (365 * 10 + 3)* 24;
else
    lengthThis = length(ds(1).powerWind); 
end

%% generate power data for calculation
if strcmp(portType, 'WindSolar') == 1
    numPowers = numLocations * 2;
    powers = zeros(lengthThis, numPowers);
    for i = 1:numLocations
        powers(:, i) = ds(i).powerWind(1:lengthThis);
        powers(:, i + numLocations) = ds(i).powerSolar(1:lengthThis);
    end
    
elseif strcmp(portType, 'WindOnly') == 1
    numPowers = numLocations;
    powers = zeros(lengthThis, numPowers);
    for i = 1:numLocations
        powers(:, i) = ds(i).powerWind(1:lengthThis);
    end
elseif strcmp(portType, 'SolarOnly') == 1
    numPowers = numLocations;
    powers = zeros(lengthThis, numPowers);
    for i = 1:numLocations
        powers(:, i) = ds(i).powerSolar(1:lengthThis);
    end
end

%% calculation
for i = 1:numPowers
    i
    covMatrix(i, i) = var(powers(:, i));
    for j = 1:i-1
        powerX = powers(:,i);
        powerY = powers(:,j);
        count = 0;
        for t = 1:lengthThis
            if(powerX(t) == 63 || powerY(t) == 63)
                continue;
            else
                count = count+1;
                x(count)=powerX(t);
                y(count)=powerY(t);
            end
        end
        covTemp = cov(x,y);
        covMatrix(i,j) = covTemp(1,2);
        covMatrix(j,i) = covMatrix(i,j);
    end
end

%% for Relative case
if strcmp(suffix, 'Relative')
    % prepare power demand
    load ../data/powerRequiredOneDayNormalized_UWI_hourly.mat
    powerDemand = powerRequiredOneDayNormalized;
    numRepeat = length(ds(1).powerWind(1:lengthThis)) / length(powerDemand);
    demand = [];
    for n = 1:numRepeat
        demand = [demand; powerDemand];
    end
    % we use negative version of the shrinked data
    demand = -demand;
    % calculate covMatrx
    covMatrix(numPowers + 1, numPowers + 1) = var(demand);
    for i = 1:numPowers;
        covTemp = cov(demand, powers(:, i));
        covMatrix(i, numPowers + 1) = covTemp(1,2);
        covMatrix(numPowers + 1, i) = covMatrix(i, numPowers + 1);
    end
end

%% coef matrix
coefMatrix = covMatrix;
for i = 1:length(coefMatrix)
    coefMatrix(i, :) = coefMatrix(i, :) / sqrt(covMatrix(i,i));
end

for i = 1:length(covMatrix)
    coefMatrix(:, i) = coefMatrix(:, i) / sqrt(covMatrix(i,i));
end

%% save
% save(strcat('covMatrix', suffix), 'covMatrix');
save(strcat('../data/', caseName, '/covMatrix'), 'covMatrix');
save(strcat('../data/', caseName, '/coefMatrix'), 'coefMatrix');
