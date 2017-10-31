function varargout = metadataExtractor(varargin)
% METADATAEXTRACTOR MATLAB code for metadataExtractor.fig
%      METADATAEXTRACTOR, by itself, creates a new METADATAEXTRACTOR or raises the existing
%      singleton*.
%
%      H = METADATAEXTRACTOR returns the handle to a new METADATAEXTRACTOR or the handle to
%      the existing singleton*.
%
%      METADATAEXTRACTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in METADATAEXTRACTOR.M with the given input arguments.
%
%      METADATAEXTRACTOR('Property','Value',...) creates a new METADATAEXTRACTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before metadataExtractor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to metadataExtractor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help metadataExtractor

% Last Modified by GUIDE v2.5 08-Nov-2016 14:21:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @metadataExtractor_OpeningFcn, ...
                   'gui_OutputFcn',  @metadataExtractor_OutputFcn, ...
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


% --- Executes just before metadataExtractor is made visible.
function metadataExtractor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to metadataExtractor (see VARARGIN)

% Choose default command line output for metadataExtractor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes metadataExtractor wait for user response (see UIRESUME)
% uiwait(handles.metaExtractorFigure);


% --- Outputs from this function are returned to the command line.
function varargout = metadataExtractor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(~, ~, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageFolderName = uigetdir;
set(handles.imgDirectoryText,'String',imageFolderName);

% Find image file within the directory
allFiles = dir(imageFolderName);
% Loop through the files
h1 = waitbar(0,'0','Name','Checking for Image Files');
count = 0;
for iFiles = 3:size(allFiles,1)
    waitbar(iFiles/size(allFiles,1),h1,sprintf('%7.2f%%',iFiles*100/size(allFiles,1)));
    mtch = regexpi(allFiles(iFiles).name,'.tif');
    if(isempty(mtch))
        continue;
    end
    fileName = fullfile(imageFolderName,allFiles(iFiles).name);
    count = count+1;
end
close(h1);



function regexpressionText_Callback(hObject, eventdata, handles)
% hObject    handle to regexpressionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regexpressionText as text
%        str2double(get(hObject,'String')) returns contents of regexpressionText as a double


% --- Executes during object creation, after setting all properties.
function regexpressionText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regexpressionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in delimiterPopMenu.
function delimiterPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to delimiterPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns delimiterPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from delimiterPopMenu
% regexpressionText
nMap = jet(10);
str = [];
for i = 1:5
    rgb = round(nMap(i,:).*255);
    hex(:,2:7) = reshape(sprintf('%02X',rgb.'),6,[]).';
    hex(:,1) = '#';
    if(i==1)
        str = [str '<html>'];
    end
    str = [str '<font color="' hex '">Treatment' num2str(i) '</font>_'];
    if(i==5)
        str = [str '</html>'];
    end
    
end
% set(handles.regexpressionText,'String',cellstr(str));
jScrollPane = findjobj(handles.regexpressionText);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);
jEditbox.setEditorKit(javax.swing.text.html.HTMLEditorKit);
jEditbox.setText(str);
disp('@@@')

% --- Executes during object creation, after setting all properties.
function delimiterPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delimiterPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createMetaFileButton.
function createMetaFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to createMetaFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in cancelButton.
function cancelButton_Callback(~, ~, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.metaExtractorFigure);


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
