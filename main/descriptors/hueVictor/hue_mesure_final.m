%Descriptor HUE - Victor Hidalgo

close all;

img=imread('/Users/boyander/Dropbox/Gestio/FOTOS_4.1/41-8.jpg');
imshow(img);
width=size(img,1);
height=size(img,2);

hue=zeros(1,360);

for i=1:(width)
    for j=1:(height)
        R=double(img(i,j,1));
        G=double(img(i,j,2));
        B=double(img(i,j,3));
        
        H = radtodeg(atan2(2*R-G-B,sqrt(3)*(G-B)));
        H = ceil(rem(H,360)) + 180;
        
        if(H==0)
            H = 360;
        end
        hue(H) = hue(H) + 1;
        
    end
end


hue = circshift(hue,[1,180]);

[value,index] = max(hue)
figure
stem(hue)

clear all;