% GDSA - Implementació d'un classificador Dia/Nit - Equip 41
% Victor Hidalgo Lorenzo
% Eneas Castan Victor
% Albeto Esteban Perez
% Marc Pomar Torres

function [ precision, recall ] = precision_recall(fd,fn,td)
precision=td/(td+fd);
recall=td/(td+fn);
end

