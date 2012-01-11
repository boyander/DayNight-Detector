% GDSA - Implementació d'un classificador Dia/Nit - Equip 41
% Victor Hidalgo Lorenzo
% Eneas Castan Victor
% Albeto Esteban Perez
% Marc Pomar Torres

function [ images ] = loadCollection(PathName,FileName)
    %Llegim el fitxer d'entrada
    [nom_imatge,tipus] = textread([PathName FileName],'%s%n%*[^\n]');
    p = size(nom_imatge,1);

    %Prellocate image vector
    images(1:p) = DiaNitClassifier(zeros(640,480),0,'','');

    %Thumbnail settings
    thumb_Dir = [PathName 'thumbs'];
    thumb_size_w = 30;
    thumb_size_h = 30;
    
    %Progress Bar
    stopBar = progressbar(0,0);

    fprintf('Loading collection....');
    for i=1:p
        %imagePath
        imgPath = [PathName char(nom_imatge{i})];
        %Generem la miniatura
        thumbnailPath = makeThumbnails(imgPath,thumb_Dir,thumb_size_h,thumb_size_w);
        %Llegim la imatge d'entrada
        img = imread(imgPath ,'JPG');
        %Creem un nou objecte imatge
        images(i) = DiaNitClassifier(img,tipus(i),char(nom_imatge{i}),thumbnailPath);
        stopBar = progressbar(i/p,0);
        if (stopBar) break; end;
    end
    fprintf('OK!\n');
end

