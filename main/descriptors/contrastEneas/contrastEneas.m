clear all;

img=imread('41-0.jpg');
%imshow(img,[])
width=size(img,1);
height=size(img,2);

SumatorioR = 0;
SumatorioG = 0;
SumatorioB = 0;
Totalpixeles=width*height

% Ravg = mean(img(:,:,1)); %Mitja del color Red
    AVG = mean(img(:,:)); 
% Bavg = mean(img(:,:,3)); %Mitja del color Blue

for i=1:(width)
    for j=1:(height)
        GRIS(i,j) = mean(img(i,j));
        Sumatorio = Sumatorio + ((double(GRIS(i,j))- Gavg)).^2;
    end
end

for i=1:(width)
    for j=1:(height)
       
        
    end
end

% SumatorioG = SumatorioG + ((double(img(i,j,1))- Gavg)).^2;
        % SumatorioB = SumatorioB + ((double(img(i,j,1))- Bavg)).^2;


ContrasteR=sqrt((SumatorioR)/(Totalpixeles));

FINALR=(mean(ContrasteR))












