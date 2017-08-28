clear all;
load ../settings;
allAirportsSwitch = 0;
tempScriptSwitch = 0;
googleSwitch = 0;
load ../data/wOptimal;
w = wOptimal;

%% plot optimal portfolio
figure;
hold on;
rgb = imread('usamap.jpg');
%x = 180-airports(:,5);
%y = airports(:,6);
x = [55;114];
y = [51;23];
image(x,y,rgb); %title('RGB image');

pointsDiameter = floor(w*500)+1;
airportTotal = 0;
load ../data/ds_filtered;
wFloor = 0;
for n=1:length(ds)
    if w(n)> wFloor
        plot(180+ds(n).coordinate(1),ds(n).coordinate(2),'.','markersize',pointsDiameter(n)+10);
        airportTotal = airportTotal + 1;
    else
        %plot(180-airports(n,5),airports(n,6),'x','markersize',pointsDiameter(n),'color','r');
    end
end

%% plot all locations
load ../data/ds_calculated;
lon = [];
lat = [];
for i = 1:length(ds)
    lon = [lon; ds(i).coordinate(1)];
    lat = [lat; ds(i).coordinate(2)];
end

for n=1:length(lon)
    plot(180+lon,lat,'rx','markersize',8);
end

axis off;
hold off;
