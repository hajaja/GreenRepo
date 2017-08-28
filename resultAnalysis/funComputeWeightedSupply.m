function y = funComputeWeightedSupply(weight, ds, option, TrainOrTest);
if strcmp(TrainOrTest, 'Train')
    nSeqStart = 1;
    nSeqEnd = (365 * 10 + 3)* 24;
elseif strcmp(TrainOrTest, 'Test')
    nSeqStart = (365 * 10 + 3)* 24 +1;
    nSeqEnd = length(ds(1).powerWind);
end
lengthThis = nSeqEnd - nSeqStart + 1;

y = zeros(lengthThis, 1);
switch option
    case 'WindSolar'
        for i = 1:length(ds)
            y = y + weight(i) * ds(i).powerWind(nSeqStart:nSeqEnd);
        end
        for i = 1:length(ds)
            y = y + weight(i + length(ds)) * ds(i).powerSolar(nSeqStart:nSeqEnd);
        end
    case 'WindOnly'
        for i = 1:length(ds)
            y = y + weight(i) * ds(i).powerWind(nSeqStart:nSeqEnd);
        end
    case 'SolarOnly'
        for i = 1:length(ds)
            y = y + weight(i) * ds(i).powerSolar(nSeqStart:nSeqEnd);
        end
    otherwise
        disp('funComputeWeightedSupply: error');
end
