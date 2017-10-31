function varargout = imageSliceBrowser(varargin)
% IMAGESLICEBROWSER MATLAB code for imageSliceBrowser.fig
%      IMAGESLICEBROWSER, by itself, creates a new IMAGESLICEBROWSER or raises the existing
%      singleton*.
%
%      H = IMAGESLICEBROWSER returns the handle to a new IMAGESLICEBROWSER or the handle to
%      the existing singleton*.
%
%      IMAGESLICEBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGESLICEBROWSER.M with the given input arguments.
%
%      IMAGESLICEBROWSER('Property','Value',...) creates a new IMAGESLICEBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageSliceBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageSliceBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageSliceBrowser

% Last Modified by GUIDE v2.5 03-Oct-2017 14:42:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageSliceBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @imageSliceBrowser_OutputFcn, ...
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


% --- Executes just before imageSliceBrowser is made visible.
function imageSliceBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageSliceBrowser (see VARARGIN)

% Choose default command line output for imageSliceBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% addpath(pwd);
% Set default colors:
% channelCol = 
if(~isempty(varargin))
    setappdata(hObject,'filelist',varargin{1});
    setappdata(hObject,'chanColors',varargin{2});
    setappdata(hObject,'chanNames',varargin{3});
    numZPlanes = size(varargin{1},1);
else
    setappdata(hObject,'filelist','ppp');
    setappdata(hObject,'chanColors',[1 0 0]);
    setappdata(hObject,'chanNames',{'C1'});
    numZPlanes = 0;
end

% Set z plane sbased on metadata
if(numZPlanes>1)
    set(handles.stackSlider,'Max',numZPlanes);
    set(handles.stackSlider,'Min',1);
    set(handles.stackSlider,'Value',1);
    set(handles.stackSlider,'SliderStep',[1/(numZPlanes-1) .1]);
else
%     set(handles.stackSlider,'Enable','off');
end
chanNames = getappdata(hObject,'chanNames');
chanColors = getappdata(hObject,'chanColors');
% chanColors = [1 0 0; 0 1 0; 0 0 1; 1 0 1;1 1 0];
% chanNames={'Mitotracker';'Annexin';'Draq5';'Test1';'PP'};
for i = 1:numel(chanNames)
    p = getfield(handles,['ch' num2str(i)]);
    set(p,'visible','on');
    set(p,'string',chanNames{i},'FontWeight','bold','ForegroundColor',chanColors(i,:));
end
for i = numel(chanNames)+1:8
    p = getfield(handles,['ch' num2str(i)]);
    set(p,'visible','off');
end
% UIWAIT makes imageSliceBrowser wait for user response (see UIRESUME)
% uiwait(handles.imageBrowser);


% --- Outputs from this function are returned to the command line.
function varargout = imageSliceBrowser_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function stackSlider_Callback(hObject, ~, handles)
% hObject    handle to stackSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

filelist = getappdata(handles.imageBrowser,'filelist');
chanColors = getappdata(handles.imageBrowser,'chanColors');
% chanNames = getappdata(handles.imageBrowser,'chanNames');
selectedSlice = ceil(get(hObject,'Value'));
if(selectedSlice == 0)
    selectedSlice = 1;
end
filelist = filelist(selectedSlice,:);


% Display Image 1
% selectedField1 = get(handles.wellImage1,'string');
% selectedField1 = selectedField1(get(handles.wellImage1,'value'),1);
% imageID = param.newImageNames;
% fileNames = param.channelFileNames(strcmpi(selectedField1{1,:},imageID),:);
% fileNames = fileNames(selectedSlice,:); % Show only the first slice here

IM = getMerged3DImage(filelist,chanColors);
if(size(IM,1)>1000 || size(IM,2)>1000)
    iniMag = .7;
else
    iniMag = 1;
end
% IM = imadjust(IM,[],[],1.3);
imshow(IM,[],'InitialMagnification',iniMag,'Parent',handles.imagefield);



%Display Image 2
% selectedField1 = get(handles.wellImage2,'string');
% selectedField1 = selectedField1(get(handles.wellImage2,'value'),1);
% imageID = param.newImageNames;
% fileNames = param.channelFileNames(strcmpi(selectedField1{1,:},imageID),:);
% fileNames = fileNames(selectedSlice,:); % Show only the first slice here
% IM = getMerged3DImage(fileNames,param);
% imshow(IM,[],'InitialMagnification',iniMag,'Parent',handles.imagefield);


% --- Executes during object creation, after setting all properties.
function stackSlider_CreateFcn(hObject, ~, ~)
% hObject    handle to stackSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes when imageBrowser is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to imageBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in channelColors.
function channelColors_Callback(hObject, eventdata, handles)
% hObject    handle to channelColors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
channelColors(handles);

% --- Executes when imageBrowser is resized.
function imageBrowser_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to imageBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in colorSection.
function colorSection_Callback(hObject, eventdata, handles)
% hObject    handle to colorSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ch1.
function ch1_Callback(hObject, eventdata, handles)
% hObject    handle to ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch1


% --- Executes on button press in ch2.
function ch2_Callback(hObject, eventdata, handles)
% hObject    handle to ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch2


% --- Executes on button press in ch3.
function ch3_Callback(hObject, eventdata, handles)
% hObject    handle to ch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch3


% --- Executes on button press in ch4.
function ch4_Callback(hObject, eventdata, handles)
% hObject    handle to ch4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch4


% --- Executes on button press in ch5.
function ch5_Callback(hObject, eventdata, handles)
% hObject    handle to ch5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch5


% --- Executes on button press in ch6.
function ch6_Callback(hObject, eventdata, handles)
% hObject    handle to ch6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch6


% --- Executes when selected object is changed in viewTypePanel.
function viewTypePanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in viewTypePanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
u = get(eventdata.NewValue,'String');
if(strcmpi(u,'Stack'))
    set(handles.stackSlider,'Enable','on');
    stackSlider_Callback(handles.stackSlider, eventdata, handles);
else
    filelist = getappdata(handles.imageBrowser,'filelist');
    chanColors = getappdata(handles.imageBrowser,'chanColors');
    %     chanNames = getappdata(handles.imageBrowser,'chanNames');
    numChannels = size(filelist,2);
    info = imfinfo(filelist{1,1});
    im3D = zeros(info.Height,info.Width,numChannels);
    h2 = waitbar(0,'Computing MIP image');
    for i = 1:numChannels
        im3D(:,:,i) = getMIPImage(filelist(:,i));
        waitbar(i/numChannels,h2);
    end
    close(h2);
    IM = getMerged3DImage(im3D,chanColors);
    IM = imadjust(IM,[],[],1.3);
    if(size(IM,1)>1000 || size(IM,2)>1000)
        iniMag = .7;
    else
        iniMag = 1;
    end
    imshow(IM,[],'InitialMagnification',iniMag,'Parent',handles.imagefield);
    set(handles.stackSlider,'Enable','off');
end
