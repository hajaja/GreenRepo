clear all;
load settingsFigure;
load ../ExtraPeakLoadMatch/ResultClarkNet.mat
aa = csvread('../ExtraPeakLoadMatch/ClarkNetTwoWeeks_5T.csv', 0, 1);
vecLoad5T = aa;
nthDay = 2;
vecLoad5T = vecLoad5T / 1000 * 60 / 5;
y = vecLoad5T((nthDay + 0) * 24 * 12 + 1: (nthDay + 1) * 24 * 12);
%y = reshape(vecLoad5T, [], 14); y = mean(y, 2);

%% plot
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, ...
	'XTickLabel',{'0','4','8','12','16','20','24'},...
    'XTick',[0 48 96 144 192 240 288],...
    'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold on;
grid on;
box on;
plot(y, 'color', 'b', 'markersize',markersize,'linewidth',linewidth);
hold off;

xlabel('Time (Hour)');
%ylabel('Power Demand (KW)');
ylabel('Requests Rate (K/Hour)');
xlim([0, length(y)]);
ylim([0, 25]);