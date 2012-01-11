%Descriptor Color Temperature Average (Kelvin degrees) - Marc Pomar

close all;

img = imread('/Users/boyander/Downloads/41/41-0.jpg');
imshow(img);

W = size(img,1);
H = size(img,2);

cTransform = makecform('srgb2xyz');
img = applycform(img,cTransform ); 


%Apply a mask and calculate most significant average
delta = 3;
mask = ones(W,H,3);

[X,Y,Z,mask] = averagedColour(img,mask,delta);

figure

subplot(1,3,1)
imshow(mask(:,:,1));

subplot(1,3,2)
imshow(mask(:,:,2));

subplot(1,3,3)
imshow(mask(:,:,3));




%Calculate Temperature using Plackian Locus and Robertson Algorithm
xs = X/(X+Y+Z);
ys = Y/(X+Y+Z);

Us = (4*xs)/(-2*xs+12*ys+3);
Vs = (6*ys)/(-2*xs+12*ys+3);

RTable = getRobertsonTable();
LTab = size(RTable,1);

d = zeros(1,31);
for i=1:LTab
Ti = RTable(i,1);

Ui = RTable(i,2);
Vi = RTable(i,3);
Mi = RTable(i,4);

d(i) = ((Vs-Vi)-Mi*(Us-Ui))/sqrt(1+Mi^2); 
end

slope = 1;
for i=1:LTab-1
    if (d(i)/d(i+1)) < 0
        slope = i;
        break;
    end
end

%Interpolate temperature between
Temp = RTable(slope,1) + ((d(slope)/(d(slope)-d(slope+1))) * (RTable(slope+1,1) - RTable(slope,1)))

%msgbox(['Temperature is -> ' char(Temp)],'Results') 

