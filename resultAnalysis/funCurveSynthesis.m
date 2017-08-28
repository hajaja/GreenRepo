function y = funCurveSynthesis(t, vecASlow, vecTSlow, AFast, ARandom, switchSupply)
y = zeros(length(t), 1);

% generate randomness
if switchSupply == true
    %Alpha = 2 * pi * (randi(4) - 2.5)/24;
    Alpha = 0;
    %vecRandInt = randi(length(vecASlow), [2, 1]);
    vecRandInt = [1, 3];
    vecA = [];
    vecT = [];
    for n = 1:length(vecRandInt)
        vecA = [vecA; vecASlow(vecRandInt(n))];
        vecT = [vecT; vecTSlow(vecRandInt(n))];
    end
else
    Alpha = 0;
    vecA = vecASlow;
    vecT = vecTSlow;
end
% 12:00 at noon
Alpha = Alpha - 12/24 * 2 * pi;

% slow signal
for n = 1:length(vecA)
    A = vecA(n);
    T = vecT(n);
    y = y + A * cos(2 * pi * 1 / T * t + Alpha);
end

% random noise
y = y + ARandom * (rand(length(t), 1) - 0.5);

% high freq noise 
vecAFast = rand(length(vecASlow), 1) * AFast;
vecTFast = rand(length(vecASlow), 1);
vecA = vecAFast;
vecT = vecTFast;
for n = 1:length(vecA)
    A = vecA(n);
    T = vecT(n);
    y = y + A * cos(2 * pi * 1 / T * t + Alpha);
end

%% non-negative
y = y - min(y);

y = y / (max(y) - min(y));