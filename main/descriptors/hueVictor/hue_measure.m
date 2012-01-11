img=imread('mar.jpg');
%imshow(img,[])
width=size(img,1);
height=size(img,2);
hue=zeros(1,360);
for i=1:width
    for j=1:height
        R=img(i,j,1);
        G=img(i,j,2);
        B=img(i,j,3);
        maximo=max([R G B]);
        minimo=min([R G B]);
        if maximo==R && G>=B
            H=round(60*((G-B)/(maximo-minimo)))+1;
            hue(1,H)=hue(1,H)+1;
        elseif maximo==R && G<B
            H=round(60*(((G-B)/(maximo-minimo))+360));
            hue(1,H)=hue(1,H)+1;
        elseif maximo==G
            H=round(60*(((B-R)/(maximo-minimo))+120));
            hue(1,H)=hue(1,H)+1;
        elseif maximo==B
            H=round(60*(((R-G)/(maximo-minimo))+240));
            hue(1,H)=hue(1,H)+1;
        else
            break;
        end          
    end
end