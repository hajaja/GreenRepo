clear all;
load ../settings.mat

%% generate the curves
% load 
TMaximum = 366 * 24;
TStep = 1;
FMaximum = 1 / TStep / 2;
FStep = 1 / TMaximum;

t = 0:TStep:TMaximum;
t = reshape(t, [], 1);
vecASlow = [1, 0.4, 0.3, 0.2];
vecTSlow = [24, 12, 48, 7 * 24];
AFast = 0.2;
ARandom = 0.3;
yDemand0 = funCurveSynthesis(t, vecASlow, vecTSlow, AFast, ARandom, false);

% supply
% ySupply0 = funCurveSynthesis(t, vecASlow, vecTSlow, AFast, ARandom, true);
% ySupply1 = funCurveSynthesis(t, vecASlow, vecTSlow, AFast, ARandom, true);
% ySupply2 = funCurveSynthesis(t, vecASlow, vecTSlow, AFast, ARandom, true);

%% plot figure
xFrequency = 0: FStep: FMaximum;
xFrequency = xFrequency * 1 / 3600;

%y = ySupply1;
%y = yDemand;
if 1
    load ../ExtraPeakLoadMatch/DemandSupply41;
    yDemand = vecLoad;
    ySupply1 = vecSupplyBaseline1;
    ySupply0 = vecSupplyOPT;
    TMaximum = length(yDemand);
    t = 1:TMaximum;
    t = reshape(t, [], 1);
    TStep = 1;
    FMaximum = 1 / TStep / 2;
    FStep = 1 / TMaximum;
    xFrequency = 0: FStep: FMaximum;
    xFrequency = xFrequency * 1 / 3600;
end
xMax = 2 / 24;
xMax = 2 / 24 * 1 / 3600;
tMax = 100;

%y = max(0, yDemand - ySupply1);
%y = yDemand - ySupply1;
%y = yDemand;
%y = ySupply2;
y = yDemand0;

yMax = 1;
yF = fft(y);
yF = yF(1:length(xFrequency));
%yFMax = max(abs(yF));
yFMax = 1000;

%% 

nthDay = 161;
yToShow = y(nthDay * 24 + 1 + 5: (nthDay + 7) * 24 + 5);
%yToShow = y(nthDay * 24 + 1: (nthDay + 7) * 24);    % for synthesized example

%subplot(4, 1, 1);
figure;
scrsz = get(0, 'ScreenSize');
set(gcf, 'Position', [1, 1, 500, 150]);
bar(yToShow, 'k');
xlim([0, length(yToShow)]);
ylim([0, yMax]);
%title('Time Domain');
xlabel('Time(Hour)');
ylabel('Power(Watt)');
box on;

figure;
scrsz = get(0, 'ScreenSize');
set(gcf, 'Position', [1, 1, 500, 150]);
bar(xFrequency, real(yF), 'b');
xlim([0, xMax]);
ylim([-yFMax, yFMax]);
%title('Real Part in Frequency Domain');
xlabel('Frequency(Hz)');
ylabel('Power(Watt)');
box on;

figure;
scrsz = get(0, 'ScreenSize');
set(gcf, 'Position', [1, 1, 500, 150]);
bar(xFrequency, imag(yF), 'r');
xlim([0, xMax]);
ylim([-yFMax, yFMax]);
%title('Imaginary Part in Frequency Domain');
xlabel('Frequency(Hz)');
ylabel('Power(Watt)');
box on;

figure;
scrsz = get(0, 'ScreenSize');
set(gcf, 'Position', [1, 1, 500, 150]);
bar(xFrequency, abs(yF), 'k');
xlim([0, xMax]);
ylim([-yFMax, yFMax]);
%title('Modulus in Frequency Domain');
xlabel('Frequency(Hz)');
ylabel('Power(Watt)');
box on;
