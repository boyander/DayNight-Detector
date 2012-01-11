% GDSA - Implementació d'un classificador Dia/Nit - Equip 41
% Victor Hidalgo Lorenzo
% Eneas Castan Victor
% Albeto Esteban Perez
% Marc Pomar Torres

% ------- INSTRUCCIONS PER L'EXECUCCIÓ -------
% Aquest fitxer es una demo de un training + test amb la mateixa col·lecció d'entrenament i de prova.
% Si voleu executar una col·lecció de prova diferent a la d'entrenament executeu aquest cell principal
%  i entreneu el model "trainModel.mat" anant al cell anomenat "SVM train". Seguidament torneu a executar
%  aquest cell per extraure els descriptors de la colecció de prova i aneu a la cell "SVM test" 
%  per classificar les dades. 

%  Nota: Podeu trobar una interfície mes amigable executant el fitxer Interfície.m


% Main Execution Thread

clear all;
close all;

%Thumbnail Generator
addpath(genpath('./thumbnailer/'));

%Add descriptors function paths
addpath(genpath('./descriptors/lumaAlberto/'));
addpath(genpath('./descriptors/tempAverage/'));
addpath(genpath('./descriptors/hueVictor/'));
addpath(genpath('./descriptors/contrastEneas/'));

%Add SVM Cassifier to paths
addpath(genpath('./svm/'));



%Sel·eccionem el directori, l'arxiu que inclourá les metadades i la
%col·lecció d'imatges

[FileName,PathName] = uigetfile('*.txt','Sel·leccioni el fitxer de metadades');
%FileName = 'dia.txt';
%PathName = '/Users/boyander/Desktop/assaig/';

%Llegim el fitxer d'entrada
[nom_imatge,tipus] = textread([PathName FileName],'%s%n%*[^\n]');
p = size(nom_imatge,1);

fprintf('Start extracting descriptors...\n',i,p);

%Prellocate image vector
images(1:p) = DiaNitClassifier(zeros(640,480),0,'','');

%Thumbnail settings
thumb_Dir = [PathName 'thumbs'];
thumb_size_w = 30;
thumb_size_h = 30;
for i=1:p
    fprintf('Processing file %d of %d\n',i,p);
    
    %imagePath
    imgPath = [PathName char(nom_imatge{i})];
    %Generem la miniatura
    thumbnailPath = makeThumbnails(imgPath,thumb_Dir,thumb_size_h,thumb_size_w);
    
    %Llegim la imatge d'entrada
    img = imread(imgPath ,'JPG');
  
    %Creem un nou objecte imatge
    images(i) = DiaNitClassifier(img,tipus(i),imgPath,thumbnailPath);
    
    %Executem la computació dels descriptors
    images(i).computeDescriptors();
    
    %Procesem la imatge donada i decidim el resultat
    images(i).decide();
end
fprintf('End extracting descriptors!\n\n');


%%

%Càlcul del precission i el recall

%Inicialitzem les variables estadístiques
falseday=0;
falsenight=0;
trueday=0;
truenight=0;

%Visualitzem les imatges incorrectes i comptabilitzem resultats
for i=1:p     
    switch images(i).status
        case 0 %'NIT CORRECTE'
            truenight=truenight+1;
        case 1 %'NIT INCORRECTE'
            falsenight=falsenight+1;
            figure('Name','Nit Incorrecte');
            imshow(images(i).image);
        case 2 %'DIA CORRECTE'
            trueday=trueday+1;
        case 3 %'DIA INCORRECTE'
            falseday=falseday+1;
            figure('Name','Dia Incorrecte');
            imshow(images(i).image);
    end
end

%Print results on screen
dolentes = falseday + falsenight
bones = trueday + truenight

%Calculem el precision i el recall
[precision, recall] = precision_recall(falseday,falsenight,trueday)
precision
recall
 
saveToFile('./sortida.txt', images,precision,recall);

%%
%Plotting results with 2 descriptors
close all;


%       
% %Find the new boundary
%  m = svm.linearClassifier.boundary_grad;
%  c = svm.linearClassifier.boundary_inte
%  
% 
%  min_limx = min([images(:).luma]);
%  max_limx = max([images(:).luma]);
%  min_limy = min([images(:).temp]);
%  max_limy = max([images(:).temp]);
%  
%  m1 = min([min_limx min_limy]);
%  m2 = max([max_limx max_limy]);
%  x = m1:(m2-m1)/100:m2;
%  y = (m.*x)+c;
%  plot(y);
 
% %Find where the boundary crosses every edge
% edges = [ min_limx       (min_limy*m)+c;
%           max_limx        (max_limy*m)+c;
%           (min_limx-c)./m        max_limy;
%          -(max_limx+c)./m        min_limy]
% %If the intersection is outside the area, the boundary hits a
% %different edge. Since the corrdinates are (-+5, *) or (*, -+5), edge
% %hits only occur when the sum is less than 10 (which guarantees an
% %edge hit).
% comp = plot(edges(:,1),edges(:,2))
% % boundary = edges(sum(abs(edges), 2) <= 10000, :)
% % comp = plot(boundary(:, 1), boundary(:, 2), '--r',...
% %         'LineWidth', 2,...
% %         'LineSmoothing', 'off',...
% %         'XDataSource','boundary(:, 1)',...
% %         'YDataSource','boundary(:, 2)');


comp = figure('Name', 'Resulting Luma vs. Temp');
hold on;

nit = zeros(2,p);
dia = zeros(2,p);
for i=1:p     
    if images(i).status == 0 || images(i).status == 1
        nit(:,i) = [images(i).luma,images(i).temp];
    else
        dia(:,i) = [images(i).luma,images(i).temp];
    end
end
plot(nit(1,:),nit(2,:),'rs','MarkerFaceColor','g');
plot(dia(1,:),dia(2,:),'o','MarkerFaceColor','r');
legend('Nit','Dia');



%%
%Plotting results with 3 descriptors
close all;
f = figure('Name', 'Resulting Contrast vs Luma vs Temp');
hold on;grid on;

for i=1:p 
    if images(i).status == 0 || images(i).status == 1
        f = plot3(images(i).luma,log(images(i).temp),images(i).hue,'o','MarkerFaceColor','g');
    else
        f = plot3(images(i).luma,log(images(i).temp),images(i).hue,'--rs','MarkerFaceColor','r');
    end
end
xlabel('Luma');
ylabel('Temperature');
zlabel('Contrast');


%%
%Plot only one descriptor in 1D graph
close all;
comp = figure('Name', 'Descriptor');
hold on;
for i=1:p     
    data = log(images(i).temp);
    if images(i).status == 0 || images(i).status == 1
        comp = stem(i,data,'--rs','MarkerFaceColor','g');
    else
        comp = stem(i,data,'o','MarkerFaceColor','r');
    end
end

%%
%SVM train

clear svm;
close all;

svm = SvmClassifier();

%dataPoints  = [images(:).luma; images(:).temp; images(:).hue; images(:).contrast]';
dataPoints = images(:).getDescriptorVector();
classVector = [images(:).ground_th]';classVector(classVector==0) = -1;

svm.loadTrainData(dataPoints,classVector)
svm.trainSVM()

save('./trainModel.mat', 'svm');


%%
%SVM test
clear svm;
close all;

%Load SVM model
load('./trainModel.mat', 'svm');

% for i=1:p
%     
%     %Image Metadata
%     descriptionVector = images(i).getDescriptorVector();
%     groundTH = images(i).getGT();
%     
%     %Predicted class
%     predicted = svm.classify(descriptionVector);
%     
%     disp([predicted groundTH]);
%     
%     %Validate Image
%     if predicted ~= groundTH
%         figure
%         imshow(images(i).image);
%     end
% end


descriptionMatrix = images(:).getDescriptorVector();
predicted = images(:).setDecision(svm.classify(descriptionMatrix));
groundTH = images(:).getGT();
images(:).showInvalid();
bv = images(:).binaryGTClassVec();
tv = images(:).binaryTrainVec();
figure('Name','Confusion MAtrix');
plotconfusion(bv,tv)





