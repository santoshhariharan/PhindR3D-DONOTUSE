function varargout = PhinDR3D_Main(varargin)
% PHINDR3D_MAIN MATLAB code for PhinDR3D_Main.fig
%      PHINDR3D_MAIN, by itself, creates a new PHINDR3D_MAIN or raises the existing
%      singleton*.
%
%      H = PHINDR3D_MAIN returns the handle to a new PHINDR3D_MAIN or the handle to
%      the existing singleton*.
%
%      PHINDR3D_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHINDR3D_MAIN.M with the given input arguments.
%
%      PHINDR3D_MAIN('Property','Value',...) creates a new PHINDR3D_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PhinDR3D_Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PhinDR3D_Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PhinDR3D_Main

% Last Modified by GUIDE v2.5 16-Oct-2017 17:38:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PhinDR3D_Main_OpeningFcn, ...
                   'gui_OutputFcn',  @PhinDR3D_Main_OutputFcn, ...
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


% --- Executes just before PhinDR3D_Main is made visible.
function PhinDR3D_Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PhinDR3D_Main (see VARARGIN)

% Choose default command line output for PhinDR3D_Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

param = initParameters;
setappdata(hObject,'param',param);

% UIWAIT makes PhinDR3D_Main wait for user response (see UIRESUME)
% uiwait(handles.phindrMain);


% --- Outputs from this function are returned to the command line.
function varargout = PhinDR3D_Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadMetadata.
function loadMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to loadMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pth] = uigetfile('*.txt');
[ mData, imageID, metaHeader,chanInfo ] = parseMetadataFile( fullfile(pth,filename) );
if(isempty(imageID))
    return;
end
param = getappdata(handles.phindrMain,'param');

% Check if training needs to be done per treatment
choice = questdlg('Do you want to select training based on column?','Training Images',...
    'Yes','No','No');
if(strcmpi(choice,'yes'))
    [Selection,ok] = listdlg('ListString',metaHeader,'SelectionMode','Single','Name','Training Column',...
                'PromptString','Select Training Column');
    if(ok)        
        param.trainingColforImageCategories = header(Selection);
        param.trainingPerColumn = true;
    else
        msgbox('Training images will be chosen at random','Random Training','modal');
        param.trainingPerColumn = false;
    end
else
    msgbox('Training images will be chosen at random','Random Training','modal');
    param.trainingPerColumn = false;
end

% Check if normalization per treatment
choice = questdlg('Do you want to select scaling based on column?','Intensity Scaling',...
    'Yes','No','No');
if(strcmpi(choice,'yes'))
    [Selection,ok] = listdlg('ListString',metaHeader,'SelectionMode','Single','Name','Training Column',...
                'PromptString','Select Training Column');
    if(ok)        
        param.treatmentColNameForNormalization = header(Selection);
        param.intensityNormPerTreatment = true;
    else
%         msgbox('Training images will be chosen at random','Random Training','modal');
        param.intensityNormPerTreatment = false;
    end
else
%     msgbox('Training images will be chosen at random','Random Training','modal');
    param.intensityNormPerTreatment = false;
end

if(~isempty(imageID))
    setappdata(handles.viewData,'mData',mData);
    setappdata(handles.viewData,'imageID',imageID);
    setappdata(handles.viewData,'metaHeader',metaHeader);
    setappdata(handles.viewData,'chanInfo',chanInfo);
    set(handles.setChanColor,'Enable','On');
    set(handles.im2View,'Enable','On');
end

% Compute Lower & Upper Scaling

% Compute Threshold



% --- Executes on button press in threshSlider.
function threshSlider_Callback(hObject, eventdata, handles)
% hObject    handle to threshSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in setVoxelParam.
function setVoxelParam_Callback(hObject, eventdata, handles)
% hObject    handle to setVoxelParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in extractFeatures.
function extractFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to extractFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function m1_Callback(hObject, eventdata, handles)
% hObject    handle to m1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch1_Callback(hObject, eventdata, handles)
% hObject    handle to ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function setChanColor_Callback(hObject, eventdata, handles)
% hObject    handle to setChanColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function createMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to createMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function p1_Callback(hObject, eventdata, handles)
% hObject    handle to p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function minScale_Callback(hObject, eventdata, handles)
% hObject    handle to minScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
param = getappdata(handles.phindrMain,'param');
prompt = {'Min Adjustment Value','Min Adjustment Value'};
title = 'Set Min/Max Scaling Adjustment';
def = cellstr(num2str([param.minScaleQuantile;param.maxScaleQuantile]));
answer = inputdlg(prompt,title,1,def);
answer = str2num(char(answer));
ii = answer<.01;
answer(ii) = .05;
ii = answer>.99;
answer(ii) = .99;
param.minScaleQuantile = answer(1);
param.maxScaleQuantile = answer(2);
setappdata(handles.phindrMain,'param',param);



% --------------------------------------------------------------------
function voxelParam_Callback(hObject, eventdata, handles)
% hObject    handle to voxelParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function otherParam_Callback(hObject, eventdata, handles)
% hObject    handle to otherParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function disGamma_Callback(hObject, eventdata, handles)
% hObject    handle to disGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function im2View_Callback(hObject, eventdata, handles)
% hObject    handle to im2View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mData = setappdata(handles.viewData,'mData');
param = setappdata(handles.viewData,'param');
setappdata(handles.viewData,'metaHeader',metaHeader);
setappdata(handles.viewData,'chanInfo',chanInfo);
[sel, ok] = listdlg('ListString')
param.trainingColforImageCategories
channels = chanInfo.channelColNumber;

stackCol = strcmpi(metaHeader,'Stack') | strcmpi(metaHeader,'Stacks');
stck = cell2mat(mData(:,stackCol));
ii = stck == min(unique(stck));
uImageID = imageID(ii,1);
numNonChannel = true(1,size(mData,2));
numNonChannel(1,chanInfo.channelColNumber) = false;
mData = mData(ii,numNonChannel);


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to im2View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to setChanColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadPreviousParameters_Callback(hObject, eventdata, handles)
% hObject    handle to loadPreviousParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function C_Callback(hObject, eventdata, handles)
% hObject    handle to C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
