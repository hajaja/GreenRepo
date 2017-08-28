clear all;
load ../settings
load(strcat('../data/', caseName, '/covMatrix'));
load('../data/ds_filtered');

% covariance matrix
covMatrix = covMatrix + 0.00001*eye(length(covMatrix));
csvwrite(strcat('../data/', caseName, '/covMatrix','.csv'), covMatrix);

% mean

if strcmp(suffix, 'Relative')
    numPowers = length(covMatrix) - 1;
else
	numPowers = length(covMatrix);
end

if strcmp(portType, 'WindSolar')
    numLocations = numPowers / 2;
    for n = 1:numLocations
        meanPower(n) = ds(n).meanWindPower;
        meanPower(n + numLocations) = ds(n).meanSolarPower;
    end
elseif strcmp(portType, 'WindOnly')
    numLocations = numPowers;
    for n = 1:numLocations
        meanPower(n) = ds(n).meanWindPower;
    end
elseif strcmp(portType, 'SolarOnly')
    numLocations = numPowers;
    for n = 1:numLocations
        meanPower(n) = ds(n).meanSolarPower;
    end
end

if strcmp(suffix, 'Relative')
    meanPower(numPowers + 1) = -1;
end

meanPower = reshape(meanPower, 1, []);
csvwrite(strcat('../data/', caseName, '/meanSpeed','.csv'), meanPower);

