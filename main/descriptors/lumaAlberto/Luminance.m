% GDSA - Implementació d'un classificador Dia/Nit - Equip 41
% Albeto Esteban Perez

function [Luma] = Luminance(Imatge)

    R = mean(Imatge(:,:,1)); %Mitja del color Red
    G = mean(Imatge(:,:,2)); %Mitja del color Green
    B = mean(Imatge(:,:,3)); %Mitja del color Blue
   
    Luma = mean (0.299*R + 0.587*G + 0.114*B); %Calculem la Luma mitja
end
