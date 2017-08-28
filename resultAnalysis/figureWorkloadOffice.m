clear all;
load settingsFigure;
load ../ExtraPeakLoadMatch/LoadOffice415min.mat

loadOffice = loadOffice * 12; %kwh in past 5min => kw
loadOffice = [loadOffice(1); loadOffice];
loadOfficeMeanDaily = reshape(loadOffice, 24*12,[]);
loadOfficeMeanDaily = mean(loadOfficeMeanDaily, 2);

nthDay = 180;
y = loadOffice(nthDay * 24*12 + 1: (nthDay + 1) * 24*12);
%y = loadOfficeMeanDaily;
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
ylabel('Power Demand (KW)');
xlim([0, length(y)]);
ylim([0, 800]);