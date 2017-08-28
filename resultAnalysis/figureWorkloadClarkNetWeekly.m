clear all;
load settingsFigure;
load ../ExtraPeakLoadMatch/ResultClarkNet.mat
nthDay = 265 + 7*24;
y = vecLoadAll(nthDay * 24 + 1: (nthDay + 7) * 24) * maxVecLoadAll / 1000;
%% plot
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, 'linewidth',linewidth);
hold on;
grid on;
box on;
plot(y, 'color', 'b', 'markersize',markersize,'linewidth',linewidth);
hold off;

xlabel('Time (Hour)');
ylabel('Requests Rate (K/Hour)');
xlim([0, length(y)]);
%ylim([0, 800]);