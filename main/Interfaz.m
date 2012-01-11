% GDSA - Implementació d'un classificador Dia/Nit - Equip 41
% Victor Hidalgo Lorenzo
% Eneas Castan Victor
% Albeto Esteban Perez
% Marc Pomar Torres


function varargout = Interfaz(varargin)

% INITIALIZATION CODE
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interfaz_OpeningFcn, ...
                   'gui_OutputFcn',  @Interfaz_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Interfaz is made visible.
function Interfaz_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for Interfaz
handles.output = hObject;

%Train variables
handles.trainImages = '';
handles.trainImagesLoaded = 0;
handles.haveTrainModel = 0;

%Test Variables
handles.testImages = '';
handles.testDescriptorsExtracted = 0;
handles.testImagesLoaded = 0;
handles.classifyDone = 0; 

%Thumbnail Generator
addpath(genpath('./thumbnailer/'));

%Add descriptors function paths
addpath(genpath('./descriptors/lumaAlberto/'));
addpath(genpath('./descriptors/tempAverage/'));
addpath(genpath('./descriptors/hueVictor/'));
addpath(genpath('./descriptors/contrastEneas/'));

%Add SVM Cassifier to paths
addpath(genpath('./svm/'));

set(handles.trainBTN,'String','Train');
set(handles.trainCollectionList,'String','<No Collection Loaded>','Value',1)
set(handles.testCollectionList,'String','<No Collection Loaded>','Value',1)

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Interfaz_OutputFcn(hObject, eventdata, handles) 

%Train variables
handles.trainImages = '';
handles.trainImagesLoaded = 0;
handles.haveTrainModel = 0;

%Test Variables
handles.testImages = '';
handles.testDescriptorsExtracted = 0;
handles.testImagesLoaded = 0;


%Set listboxes height
setCellHeightForListBox(handles.trainCollectionList,45);
setCellHeightForListBox(handles.testCollectionList,45);

%Set Background color in Path Boxes
setBackgroundInBoxes(handles.testCollectionPath);
setBackgroundInBoxes(handles.trainCollectionPath);

%Missclassified box to HTML content
setEditBoxToHTML(handles.missTextBox)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in trainCollectionPathSearchBTN.
function trainCollectionPathSearchBTN_Callback(hObject, eventdata, handles)

[FileName,PathName] = uigetfile('*.txt','Sel·leccioni el fitxer de metadades');
if isequal(FileName,0)
   disp('User selected Cancel')
else
    set(handles.trainCollectionPath,'String',[PathName,FileName])

    handles.haveTrainModel = 0;
    set(handles.trainBTN,'String','Train');

    %Load Collection images
    handles.trainImages = loadCollection(PathName,FileName);
    handles.trainCollPath = PathName;
    handles.trainImagesLoaded = 1;
    ingestDataInListBox(handles.trainCollectionList,handles.trainImages,'train')

    guidata(hObject, handles);
end


% --- Executes on button press in testCollectionPathSearchBTN.
function testCollectionPathSearchBTN_Callback(hObject, eventdata, handles)

[FileName,PathName] = uigetfile('*.txt','Sel·leccioni el fitxer de metadades');
if isequal(FileName,0)
   disp('User selected Cancel')
else
    set(handles.testCollectionPath,'String',[PathName,FileName])
    %Load Collection images
    handles.testImages = loadCollection(PathName,FileName);
    handles.testCollPath = PathName;
    handles.testImagesLoaded = 1;
    ingestDataInListBox(handles.testCollectionList,handles.testImages,'train')
    handles.testDescriptorsExtracted = 0;
    handles.classifyDone = 0;
    set(handles.missTextBox,'String','<html><p style="text-align:center;"><b>Press "Classify"!</b></p></html>');
    guidata(hObject, handles);
end




function ShowMisclassified(Box,images,basePath)
    L = length(images);
    table = '';
    maxcols = 6;
    if L > 0
        for i=1:ceil(L/maxcols)
            table = [table '<tr>'];
            for j = 1:maxcols
                if i*j <= L
                    miniatura = fullfile(images(i*j).thumbPath);
                    fullPATH = [basePath images(i*j).path];
                    miniatura_html = ['<a href="' fullPATH '"><img border=0  src="file:///' miniatura '"/></a>'];
                    
                    if isequal(images(i*j).decision,1)
                        text_classi = '<p style="color:#FF8500;text-align:center;margin-top:3px;"><b>Dia</b></p>';
                    else
                        text_classi = '<p style="color:#6588C9;text-align:center;margin-top:3px;"><b>Nit</b></p>';
                    end

                    table = [table '<td>' miniatura_html text_classi '</td>'];
                else
                    break
                end
            end
            table = [table '</tr>'];
        end
        table = ['<table>' table '</table>'];
    else
        table = '<b>All images ok, well done!</b>';
    end
    %disp(['<html><div style="text-align:center;">' table '</div></html>']);
    htmlSTR = cellstr(['<html><div style="text-align:center;margin-top:5px;">' table '</div></html>']);
    set(Box,'String',htmlSTR);


function ingestDataInListBox(listBox,images,type)
   
    L = length(images);
    stringCells = cell(1,L);
    for i = 1:L
        stringCells(i) = getHTMLCell(images(i).thumbPath,images(i).path,images(i).getGT(),type,images(i).decision);
    end
    set(listBox,'String',stringCells,'Value',1)

    
%Plot type could be 'train' or 'test'
function [htmlSTR] = getHTMLCell(thumbFile,text,type,plot_type,classification)
    miniatura = fullfile(thumbFile);
    day_icn = fullfile(pwd,'./icons/sun.png');
    night_icn = fullfile(pwd,'./icons/moon.png');
    cross_icn = fullfile(pwd,'./icons/cross.png');
    tick_icn = fullfile(pwd,'./icons/tick.png');
    miniatura_html = ['<img src="file:///' miniatura '"/>'];
    
    if type==1
        icon = day_icn;
    else
        icon = night_icn;
    end

    class_icn = '';
    icon_html = '';
    
    if strcmp(plot_type, 'train')
        icon_html = ['<td><img src="file:///' icon '"/></td>'];
    elseif strcmp(plot_type, 'test')
        if isequal(classification,type)
            icon_class = tick_icn;
        else
            icon_class = cross_icn;
        end
        icon_html = ['<td><img src="file:///' icon '"/></td>'];
        class_icn = ['<td><img src="file:///' icon_class '"/></td>'];
    end
    
    table = ['<table border="0"><tr><td>' miniatura_html '</td>' icon_html  class_icn '<td><b>' text '</b></td></tr></table>'];
    
    htmlSTR = cellstr(['<html>' table '</html>']);



function trainCollectionPath_Callback(hObject, eventdata, handles)
% hObject    handle to trainCollectionPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainCollectionPath as text
%        str2double(get(hObject,'String')) returns contents of trainCollectionPath as a double


% --- Executes during object creation, after setting all properties.
function trainCollectionPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resultsBTN.
function resultsBTN_Callback(hObject, eventdata, handles)
    if isequal(handles.haveTrainModel,0)
            msgbox('Train model not Computed','Train Error','error');
            return
    else
        if isequal(handles.classifyDone,1)
            bv = handles.testImages(:).binaryGTClassVec();
            tv = handles.testImages(:).binaryTrainVec();
            figure('Name','Confusion Matrix');
            plotconfusion(bv,tv)
        else
            msgbox('Classify First!','Train Error','warn');
        end
    end
    
% --- Executes on button press in trainBTN.
function trainBTN_Callback(hObject, eventdata, handles)
    %Check for loaded collection
    if isequal(handles.trainImagesLoaded,0)
        msgbox('No loaded collection!','Train Error','error');
        return
    end
    
    %Check for saved model
    if isequal(handles.haveTrainModel,0)
        %Extract collection descriptors
        extractDescriptors(handles.trainImages)

        %Calculate SVM decision boundary
        svm = SvmClassifier();
        dataPoints = handles.trainImages(:).getDescriptorVector();
        classVector = [handles.trainImages(:).ground_th]';classVector(classVector==0) = -1;
        svm.loadTrainData(dataPoints,classVector)
        svm.trainSVM();
        handles.svmTrainModel = svm;        
        handles.haveTrainModel = 1;
        
	%Change BTN to Save model
        set(handles.trainBTN,'String','Save model...');
        guidata(hObject, handles);
    else
	%Save SVM Model
        disp('Saving model....');
        svm_model = handles.svmTrainModel;
        save 'trainModel.mat' svm_model
        msgbox('Model saved on workspace!','Save model');
    end


    
    
    
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in classifyBTN.
function classifyBTN_Callback(hObject, eventdata, handles)
   %Check if test collection is loaded
   if isequal(handles.testImagesLoaded,0)
         msgbox('No test Collection to Classify!','Test Error','error');
         return
   else
       %Check for SVM Model (Remember to press "Save model..." btn after train!! Note: Live demo error made by MarcP :) )
       if isequal(handles.haveTrainModel,1)
           %Process collection
           if isequal(handles.testDescriptorsExtracted,0)
                extractDescriptors(handles.testImages);
                handles.testDescriptorsExtracted = 1;
           end
           %Load SVM model
           load 'trainModel.mat' svm_model
           descriptionMatrix = handles.testImages(:).getDescriptorVector();
           %Classify Data
           handles.testImages(:).setDecision(svm_model.classify(descriptionMatrix));
           %Refresh listbox
           ingestDataInListBox(handles.testCollectionList,handles.testImages,'test');

           handles.classifyDone = 1; 

           %Show Missclassified
           invalid = handles.testImages(:).getInvalid();
           ShowMisclassified(handles.missTextBox,invalid,handles.testCollPath);
           
           
           guidata(hObject, handles);
       else
            msgbox('No train model Found, need to train a collection first!','Test Error','error');
       end
   end


%Extract Descriptors for image collection
function extractDescriptors(images)
    L = length(images);
    if L > 0
        stopBar = progressbar(0,0);
        for i = 1:L
            fprintf('[%d/%d] Processing descriptor analysis....\n',i,L);
            images(i).computeDescriptors();
            stopBar = progressbar(i/L,0);
            if (stopBar) break; end;
        end
        fprintf('End extracting descriptors!\n\n');
    else
        fprintf('No data to extract!\n');
    end

        

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function trainCollectionList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainCollectionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function testCollectionPath_Callback(hObject, eventdata, handles)
% hObject    handle to testCollectionPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testCollectionPath as text
%        str2double(get(hObject,'String')) returns contents of testCollectionPath as a double


% --- Executes during object creation, after setting all properties.
function testCollectionPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testCollectionPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in testCollectionList.
function testCollectionList_Callback(hObject, eventdata, handles)
    if handles.testImagesLoaded
        contents = cellstr(get(hObject,'String'));
        selectedImage = get(hObject,'Value');
        imageMatrix = handles.testImages(selectedImage).image;
        figure('Name','Image from Test Collection')
        imshow(imageMatrix)
    end
    
% --- Executes on selection change in trainCollectionList.
function trainCollectionList_Callback(hObject, eventdata, handles)
    if handles.trainImagesLoaded
        contents = cellstr(get(hObject,'String'));
        selectedImage = get(hObject,'Value');
        imageMatrix = handles.trainImages(selectedImage).image;
        figure('Name','Image from Test Collection')
        imshow(imageMatrix)
    end


    

% --- Executes during object creation, after setting all properties.
function testCollectionList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testCollectionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function trainCollectionPathSearchBTN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainCollectionPathSearchBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function trainCollectionPathSearchBTN_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to trainCollectionPathSearchBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function missTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to missTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of missTextBox as text
%        str2double(get(hObject,'String')) returns contents of missTextBox as a double


% --- Executes during object creation, after setting all properties.
function missTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to missTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function missTextBox_DeleteFcn(hObject, eventdata, handles)
    set(handles.missTextBox,'String','');




% JAVA HANDLING - This functions are created especially for this GUI, reuse with care!
function setBackgroundInBoxes(box)
    jEdit = findjobj(box);
    lineColor = java.awt.Color(0.5,0.5,0.5);  % =red
    thickness = 1;  % pixels
    roundedCorners = true;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    jEdit.Border = newBorder;
    jEdit.repaint;  % redraw the modified control
    
    
function setCellHeightForListBox(listBox,height)
    jScrollPane = findjobj(listBox);
    jUICL = jScrollPane.getViewport.getComponent(0);
    jUICL.setFixedCellHeight(height) 

function setEditBoxToHTML(editBox)
    jScrollPane = findjobj(editBox);
    jEditbox = jScrollPane.getViewport.getComponent(0);
    jEditbox.setContentType('text/html');
    jEditbox.setEditable(false);
    jEditbox.setText('<html><p style="text-align:center;"><b>No test Collection Loaded</b></p></html>');
    hjEditbox = handle(jEditbox,'CallbackProperties');
    set(hjEditbox,'HyperlinkUpdateCallback',@linkCallbackFcn);

function linkCallbackFcn(src,eventData)
   imgPath = eventData.getDescription; % URL string
   switch char(eventData.getEventType)
      case char(eventData.getEventType.ACTIVATED)
               disp(imgPath);
               img = imread(char(imgPath),'JPG');
               imshow(img);
               clear img;
   end

    
    


