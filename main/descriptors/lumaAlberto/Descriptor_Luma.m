


clear all

[A,C]=textread('41.txt','%s%s%*[^\n]');

sA=size(A);
p=1;
M=sA(1);


for i=1:M

    Imatge=imread(char(A(p)),'JPG'); %Llegim Imatge
    
   
    R = mean(Imatge(:,:,1)); %Mitja del color Red
    G = mean(Imatge(:,:,2)); %Mitja del color Green
    B = mean(Imatge(:,:,3)); %Mitja del color Blue
    
    disp(char(A(p)))  
    
    Luma = mean (0.299*R + 0.587*G + 0.114*B) %Calculem la Luma mitja
    
%     figure(p);
%     imshow(Imatge); %Mostrem Imatges
    
    %Decisor
    if Luma<87 
      
     
      disp('NIT')                   
                  
    else
      
      disp('DIA')
    end    
    p=p+1;
end
