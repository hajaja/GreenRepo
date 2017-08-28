clear all;
load ../settings;
load settingsFigure;
TrainOrTest = 'Test';
strFileAddress = strcat('../data/supplies', TrainOrTest);
load(strFileAddress);
nOptimal = 12;
option = 'hourly';
%% calculate Google supply
[xGoogle, yGoogle] = funCDF(supplyGoogle, option);
%[xGoogle, yGoogle] = funCDF(supplyCV, option);
%% calculate optimal portfolio supply
[xOptimal, yOptimal] = funCDF(supplyOptimal, option);
%% calculate heaviest weighted location in the portfolio
[xSingle, ySingle] = funCDF(supplyWindLargest, option);

%% plot figures
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize,'linewidth',linewidth);%,'XTickLabel',{'8','16','32','64'});
hold(axes1,'all');
hold on;
grid on;
box on;
xlim(axes1, min(1, [0,ceil(max(xOptimal) * 1.2 * 100) / 100]));
ylim(axes1, [0, 1]);
linewidth = linewidth + 2;
plot(xOptimal, yOptimal, 'color','b','markersize',markersize,'linewidth',linewidth, 'linestyle', '-');
plot(xGoogle, yGoogle, 'color','r','markersize',markersize,'linewidth',linewidth, 'linestyle', ':');
plot(xSingle, ySingle, 'color','k','markersize',markersize,'linewidth',linewidth, 'linestyle', '-.');
hold off;

xlabel('Power (Watt)','fontsize', fontsize);
ylabel('Cumulative Probability','fontsize',fontsize);
legend('Optimal','Google','Single');

