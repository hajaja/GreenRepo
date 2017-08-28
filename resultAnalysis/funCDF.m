function [x, cdf] = funCDF(supply, option)
%clear all;
%load supplyOptimal_temp;supply = supplyOptimal;
%load supplyGoogle_temp;supply = supplyGoogle;
period = funSetFrequency(option);
supply = reshape(supply(1:floor(length(supply)/period)*period),[], period);
supply = mean(supply, 2);
if length(supply) < 100
    numBins = 10;
else
    numBins = 100;
end
%numBins = 30;
[N,X] = hist(supply, numBins);
pdf = N / sum(N);
pdf = pdf / sum(pdf);
x = X;
for n = 1:length(pdf)
    if n == 1
        cdf(n) = pdf(n);
    else
        cdf(n) = cdf(n-1) + pdf(n);
    end
end
x = reshape(x, [], 1);
cdf = reshape(cdf, [], 1);

