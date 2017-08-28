clear all;
load ../data/wOptimal;
load ../data/ds_filtered;
load ../data/AbsoluteWindSolarTen/coefMatrix.mat;
fh = fopen('tableOptimalPortfolio.txt', 'w');
numLocations = length(wOptimal) / 2;
%numLocations = length(wOptimal);
[wHeaviest, nHeaviest] = max(wOptimal(1:numLocations));

n = nHeaviest;
fprintf(fh, '%d  & %s  & %.4f & %.4f & %.4f  & %.4f  &  %.4f\\\\\n', ...
    ds(n).usaf, ds(n).state, wOptimal(n), wOptimal(n+numLocations), ds(n).coordinate(1), ds(n).coordinate(2), coefMatrix(nHeaviest, n));

for n = 1:numLocations
    if wOptimal(n) > 0 && n ~= nHeaviest;
        fprintf(fh, '%d   & %s & %.4f & %.4f & %.4f  & %.4f  &  %.4f\\\\\n', ...
            ds(n).usaf, ds(n).state, wOptimal(n), wOptimal(n+numLocations), ds(n).coordinate(1), ds(n).coordinate(2), coefMatrix(nHeaviest, n));
    end
end
fclose(fh);