% GDSA - Implementació d'un classificador Dia/Nit - Equip 41
% Eneas Castan Victor

% Cálcul de el contrast mig

function [ contrast ] = calculateContrast(img)
    width=size(img,1);
    height=size(img,2);

    SumatorioR = 0;
    SumatorioG = 0;
    SumatorioB = 0;
    Sumatorio = 0;
    Totalpixeles=width*height;

    % Ravg = mean(img(:,:,1)); %Mitja del color Red
     AVG = mean(img(:,:)); 
    % Bavg = mean(img(:,:,3)); %Mitja del color Blue

    for i=1:(width)
        for j=1:(height)
            GRIS(i,j) = mean(img(i,j));
            Sumatorio = Sumatorio + ((double(GRIS(i,j))- AVG)).^2;
        end
    end

%     for i=1:(width)
%         for j=1:(height)
% 
% 
%         end
%     end

    % SumatorioG = SumatorioG + ((double(img(i,j,1))- Gavg)).^2;
            % SumatorioB = SumatorioB + ((double(img(i,j,1))- Bavg)).^2;


    ContrasteR=sqrt((Sumatorio)/(Totalpixeles));

    contrast = (mean(ContrasteR));

end

