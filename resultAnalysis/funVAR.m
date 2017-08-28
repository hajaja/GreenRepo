function y = funVAR(cost, period, percentage)
for n = 1:length(cost)
    cost(n) = max(0, cost(n));
end
%span = min(1000, floor(length(cost) / period));
span = floor(length(cost) / period);
cost = reshape(cost(end - period * span + 1 : end),[], period);
cost = sum(cost, 2);
cost = sort(cost, 'descend');
y = cost(max(1, floor(percentage/100 * length(cost))));
avg = mean(cost)
load ../data/avgPowerRequired_Google_hourly.mat;
%load ../data/avgPowerRequired_UWI_hourly.mat;
y = avgPowerRequired * y;
