clear all;
load settingsFigure;
linewidth = linewidth * 0.8;
%%
load ../data/AbsoluteWindSolarAll/coefMatrix;
numLocations = length(coefMatrix) / 2;
coefMatrixWind = coefMatrix(1:numLocations, 1:numLocations);
coefMatrixSolar = coefMatrix(numLocations + 1:2*numLocations, numLocations+1: 2*numLocations);

%% wind
coefMatrix = coefMatrixWind;
N = 1:length(coefMatrix);
[X, Y] = meshgrid(N);

figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, 'linewidth', linewidth);
view(axes1,[-37.5 30]);
grid(axes1,'on');
hold(axes1,'all');
mesh(X,Y,coefMatrix,'Parent',axes1, 'linewidth', linewidth);
xlabel('location');
ylabel('location');
zlabel('coefficient');
zlim([-0.1, 1]);

%% solar
coefMatrix = coefMatrixSolar;
N = 1:length(coefMatrix);
[X, Y] = meshgrid(N);

figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',fontsize, 'linewidth', linewidth);
view(axes1,[-37.5 30]);
grid(axes1,'on');
hold(axes1,'all');
mesh(X,Y,coefMatrix,'Parent',axes1, 'linewidth', linewidth);
xlabel('location');
ylabel('location');
zlabel('coefficient');
zlim([-0.1, 1]);

