clear all;
load ../settings;
load settingsFigure;

switchTimeDifference = 1;
if switchTimeDifference
    load ../ExtraPeakLoadMatch/powerShortageTimeDifference.mat
    vecX = vecX - 5;
else
    load ../ExtraPeakLoadMatch/powerShortageCapacityRatioForPeak.mat
end
%%
fontsizeOriginal = fontsize;
fontsize = fontsizeOriginal + 5 ;
figure1 = figure;
if switchTimeDifference
axes1 = axes('Parent',figure1,'FontSize',fontsize, ...
	'XTickLabel',{'GMT-10', 'GMT-9','GMT-8','GMT-7','GMT-6','GMT-5','GMT-4','GMT-3','GMT-2','GMT-1','GMT-0'},...
    'XTick',-10:1:0,...
    'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
else
    axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth + 0.5);%,'XTickLabel',{'8','16','32','64'});
end

hold(axes1,'all');
hold on;
grid on;
box on;
xlim(axes1, [min(vecX), max(vecX)]);
%ylim(axes1, [0, 0.8]);
plot(vecX, vecShortageOPT * 100, 'color','r','markersize',markersize,'linewidth',linewidth, 'linestyle', '-.');
plot(vecX, vecShortageMIQP * 100, 'color','b','markersize',markersize,'linewidth',linewidth);
% plot(vecX, vecShortageCombinedOPT * 100, 'color','r','markersize',markersize,'linewidth',linewidth, 'linestyle', '-.');
% plot(vecX, vecShortageCombinedMIQP * 100, 'color','b','markersize',markersize,'linewidth',linewidth);

hold off;

if switchTimeDifference
    xlabel('Time Zone','fontsize', fontsize);
    xlim([-10, -3]);
else
    xlabel('Capacity Ratio','fontsize', fontsize);
    xlim([1, 10]);
end
ylabel('Electricity Drawn from Grid (%)','fontsize',fontsize);
legend('LFLM', 'MIQP');