function varargout = testGUI(varargin)
% TESTGUI MATLAB code for testGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testGUI

% Last Modified by GUIDE v2.5 07-Oct-2016 22:59:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @testGUI_OutputFcn, ...
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


% --- Executes just before testGUI is made visible.
function testGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGUI (see VARARGIN)

% Choose default command line output for testGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.axes1,'nextPlot','replacechildren');
a = randn(5,2);
h = plot(a(:,1),a(:,2),'or','Parent',handles.axes1,'MarkerFaceColor','r',...
    'ButtonDownFcn',{@t1,handles});
% set(handles.axes1,'nextplot','add');
% set(h,'hittest','off');
c = get(handles.axes1,'Children');
% set(c,'hittest','off');
% set(c,'PickableParts','none');
disp('Hi')

% UIWAIT makes testGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [cp] = get(hObject,'CurrentPoint');
% c = get(hObject,'Children');
% x = get(c,'XData');y = get(c,'YData');
% p = sum(ismember([cp(1,1) cp(1,2)],[x' y'],'rows'),2);
% if(sum(p)>0)
%     hold(hObject,'on');
%     plot(cp(1,1),cp(1,2),'ok')
%     hold(hObject,'off');
% end
% disp('Bye');

function t1(src, evt, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [cp] = get(src,'CurrentPoint');
[~,x1] = min(pdist2(evt.IntersectionPoint(1,1:2),[src.XData' src.YData']));
mSizeOld = get(src,'MarkerSize');
if(mSizeOld==6)
    mSizeNew = 10;
else
    mSizeNew = 6;
end
xdata = src.XData()
hold(handles.axes1,'on');
set(src,'XData',src.XData(x1),'YData',src.YData(x1),'MarkerSize',mSizeNew);
% h = plot(src.XData(x1),src.YData(x1),'o','MarkerSize',mSizeNew,...
%                     'MarkerFaceColor','r','MarkerEdgeColor','none');
hold(handles.axes1,'off');
% set(h,'Hittest','on');set(h,'ButtonDownFcn',{@t1,handles});
disp('@@@@')
