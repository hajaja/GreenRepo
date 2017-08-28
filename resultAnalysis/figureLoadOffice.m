clear all;
load settingsFigure;
load ../ExtraPeakLoadMatch/LoadOffice41.mat

nthDay = 161;
%y = loadOffice(nthDay * 24 + 1 + 5: (nthDay + 7) * 24 + 5);
y = loadOffice;
%% plot
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, ...
    'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold on;
grid on;
box on;
plot(y, 'color', 'b', 'markersize',markersize,'linewidth',linewidth);
hold off;

xlabel('Time (Hour)');
ylabel('Power Demand (KW)');
xlim([0, length(y)]);
ylim([0, 1000]);