clear all;
load settingsFigure;
load('../data/powerRequiredMay2nd'); powerRequired = powerRequiredMay2nd;
%load('../data/powerRequiredMayAvg'); powerRequired = powerRequiredMayAvg;

%% plot
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, ...
	'XTickLabel',{'0','4','8','12','16','20','24'},...
    'XTick',[0 48 96 144 192 240 288],...
    'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold on;
grid on;
box on;
plot(powerRequired, 'color', 'b', 'markersize',markersize,'linewidth',linewidth);
hold off;

xlabel('Time (Hour)');
ylabel('Power Demand (MW)');
xlim([0, length(powerRequired)]);
ylim([150, 350]);