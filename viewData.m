function varargout = viewData(varargin)
% VIEWDATA MATLAB code for viewData.fig
%      VIEWDATA, by itself, creates a new VIEWDATA or raises the existing
%      singleton*.
%
%      H = VIEWDATA returns the handle to a new VIEWDATA or the handle to
%      the existing singleton*.
%
%      VIEWDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWDATA.M with the given input arguments.
%
%      VIEWDATA('Property','Value',...) creates a new VIEWDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewData

% Last Modified by GUIDE v2.5 20-Oct-2017 14:47:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewData_OpeningFcn, ...
                   'gui_OutputFcn',  @viewData_OutputFcn, ...
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


% --- Executes just before viewData is made visible.
function viewData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no outputFile args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewData (see VARARGIN)

% Choose default command line outputFile for viewData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
x = rand(10,2);
plot(x(:,1),x(:,2),'*b','Parent',handles.plotAxes);
set(handles.plotAxes,'ButtonDownFcn',{@plotAxes_ButtonDownFcn,handles});

% UIWAIT makes viewData wait for user response (see UIRESUME)
% uiwait(handles.viewData);


% --- Outputs from this function are returned to the command line.
function varargout = viewData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning outputFile args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line outputFile from handles structure
varargout{1} = handles.output;


% --- Executes on button press in metadata.
function metadata_Callback(~, ~, handles)
% hObject    handle to metadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pth] = uigetfile('*.txt');
[ mData, imageID, metaHeader,chanInfo ] = parseMetadataFile( fullfile(pth,filename) );
if(~isempty(imageID))
    setappdata(handles.viewData,'mData',mData);
    setappdata(handles.viewData,'imageID',imageID);
    setappdata(handles.viewData,'metaHeader',metaHeader);
    setappdata(handles.viewData,'chanInfo',chanInfo);
    set(handles.outputFile,'Enable','On');
    set(handles.plotData,'Enable','On');
end


% --- Executes on button press in outputFile.
function outputFile_Callback(~, ~, handles)
% hObject    handle to outputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isappdata(handles.viewData,'imageID'))
    errordlg('Please load metadatafile first','','modal');
end
% Read outputFile file
[filename,pth] = uigetfile('*.txt');
[ opText, opData, textHeader, dataHeader, opImageID ] = parseDataFile(fullfile(pth,filename));
if(~isempty(opData))
    setappdata(handles.viewData,'opData',opData);
    setappdata(handles.viewData,'opImageID',opImageID);
    setappdata(handles.viewData,'opText',opText);
    setappdata(handles.viewData,'textHeader',textHeader);
    setappdata(handles.viewData,'dataHeader',dataHeader);
end

% --- Executes on button press in plotData.
function plotData_Callback(~, ~, handles)
% hObject    handle to plotData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isappdata(handles.viewData,'opData'))
    errordlg('Please load data','','modal');
    return;    
end
plotDataFromHandles( handles );
% opData = getappdata(handles.viewData,'opData');
% opText = getappdata(handles.viewData,'opText');
% textHeader = getappdata(handles.viewData,'textHeader');    
% 
% numdims = get(handles.threeDim,checked);
% if(numdims)
%     numdims = 3;
% else
%     numdims = 2;
% end
% if(algoVal)
%     rdType = 'PCA';
% else
%     rdType = 't-SNE';
% end
% if(isappdata(handles.viewData,'perplexity'))
%     perplexity = getappdata(handles.viewData,'perplexity');
% else
%     perplexity=30;
% end
% % perplexity = 
% redData = compute_mapping(opData,rdType,numdims,perplexity);
% setappdata(handles.viewData,'redData',redData);
% if(numdims==2)
%     scatter(handles.plotAxes,redData(:,1),redData(:,2),30,[0 0 1],'filled');
% else
%     scatter3(handles.plotAxes,redData(:,1),redData(:,2),redData(:,3),30,[0 0 1],'filled');
% end



% --------------------------------------------------------------------
function exportFigure_Callback(hObject, eventdata, handles)
% hObject    handle to exportFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% x = randn(10,3);
% plot3(x(:,1),x(:,2),x(:,3),'ok','MarkerFacecolor','k','MarkerEdgeColor','None','Parent',handles.plotAxes);
% view(handles.plotAxes,20, 45);

% [a, b] = view(handles.plotAxes);
h = figure;
new_handle = copyobj(handles.plotAxes,h);
h = findobj(new_handle,'Type','axes');
set(h,'Units','Normalized');
set(h,'position',[.1 .1 .85 .85]);
FilterSpec = {'*.bmp';'*.eps';'*.jpg';'*.fig';'*.pdf';'*.png';'*.tiff'};
[fname,filePath] = uiputfile(FilterSpec,'Save Plot');
% format = regexpi(fname,'\.','split');
% format = format{1,end};
% format = format{end};
saveas(h,fullfile(filePath,fname)); 

% --------------------------------------------------------------------
function autoCls_Callback(hObject, eventdata, handles)
% hObject    handle to autoCls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isappdata(handles.viewData,'opData'))
    errordlg('Please load data','','modal');
    return;    
end

opData = getappdata(handles.viewData,'opData');
C = clsIn(opData);
step = 100;
pref = [C.pmin:(C.pmax - C.pmin)./step:C.pmax];
yCls = zeros(numel(pref),1);
h = waitbar(0,'Estimating optimal clusters');
for i = 1:numel(pref)
    idx = apcluster(C.S,pref(i),'dampfact',.9);
    yCls(i) = numel(unique(idx));
    waitbar(h,i/numel(pref));
end
close(h);
optimCls = getBestPreference( pref',yCls,true );
setappdata(handles.viewData,'optimCls',optimCls);
% --------------------------------------------------------------------
function setK_Callback(hObject, eventdata, handles)
% hObject    handle to setK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter number of clusters'};
dlg_title = 'Number of Clusters';
num_lines = 1;
def = {'5'};
optimCls = inputdlg(prompt,dlg_title,num_lines,def);
if(isempty(optimCls))
   optimCls = 5;
else
   optimCls = str2double(char(optimCls)); 
end
setappdata(handles.viewData,'optimCls',optimCls);

% --------------------------------------------------------------------
function viewSet_Callback(hObject, eventdata, handles)
% hObject    handle to viewSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function viewSetTsne_Callback(hObject, eventdata, handles)
% hObject    handle to viewSetTsne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function viewSetPCA_Callback(hObject, eventdata, handles)
% hObject    handle to viewSetPCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function viewalgoSetting_Callback(hObject, eventdata, handles)
% hObject    handle to viewalgoSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function apCls_Callback(hObject, eventdata, handles)
% hObject    handle to apCls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Damping Factor'};
dlg_title = 'Damping factor for AP';
num_lines = 1;
def = {'.9'};
dFact = inputdlg(prompt,dlg_title,num_lines,def);
if(isempty(dFact))
    dFact = .9;
else
    dFact = str2double(char(dFact));
end
if(dFact<.5)
    dFact =.5;
elseif(dFact>.95)
    dFact = .95;
end    
setappdata(handles.viewData,'dampFact',dFact);

% --------------------------------------------------------------------
function viewSetTSne_Callback(hObject, eventdata, handles)
% hObject    handle to viewSetTSne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter tSNE perplexity:'};
dlg_title = 'tSNE Parameters';
num_lines = 1;
def = {'30'};
perplexity = inputdlg(prompt,dlg_title,num_lines,def);
if(isempty(perplexity))
    perplexity = 30;
else
    perplexity = str2double(char(perplexity));
end
setappdata(handles.viewData,'perplexity',perplexity);



% --------------------------------------------------------------------
function twoDim_Callback(hObject, eventdata, handles)
% hObject    handle to twoDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.twoDim,'checked','on');
set(handles.threeDim,'checked','off');

% --------------------------------------------------------------------
function threeDim_Callback(hObject, eventdata, handles)
% hObject    handle to threeDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.twoDim,'checked','off');
set(handles.threeDim,'checked','on');

% --------------------------------------------------------------------
function APCls_Callback(hObject, eventdata, handles)
% hObject    handle to APCls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isappdata(handles.viewData,'opData'))
    errordlg('Please load data','','modal');
    return;    
end
opData = getappdata(handles.viewData,'opData');
if(~isappdata(handles.viewData,'dampFact'))
    dampFact = .9;
else
    dampFact = getappdata(handles.viewData,'dampFact');
end
if(~isappdata(handles.viewData,'optimCls'))
    optimCls = 5;
else
    optimCls = getappdata(handles.viewData,'optimCls');
end

% Cluster using AP
C = clsIn(opData);
clsInd = apclusterK(C.S,optimCls,10,dampFact);
if(numel(unique(clsInd)) > .8*size(opData,1))
    errordlg('Unable to cluster. Try increasing damping factor','','modal');
    return;
else
    setappdata(handles.viewData,'clsInd',clsInd);
    msgbox('Clustering Completed','Success','modal');
end


% --------------------------------------------------------------------
function vs_Callback(hObject, eventdata, handles)
% hObject    handle to vs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function grpCol_Callback(~, ~, handles)
% hObject    handle to grpCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(~isappdata(handles.viewData,'opData'))
    errordlg('Please load data','','modal');
    return;
end
% opData = getappdata(handles.viewData,'opData');
opText = getappdata(handles.viewData,'opText');
textHeader = getappdata(handles.viewData,'textHeader');
[Selection,ok] = listdlg('ListString',textHeader,'SelectionMode','Single',...
    'Name','Grouping Column');
if(~ok)
    return;
else
    set(handles.grpColors,'Enable','on');
    setappdata(handles.viewData,'ColumnforViewing','Selection');
%     [az , el] = view(handles.plotAxes);
    treatmentNames = unique(opText(:,Selection));
    setappdata(handles.viewData,'treatmentNames',treatmentNames);
    if(~isappdata(handles.viewData,'treatmentColors'))
        colors = jet(numel(treatmentLegends));
        setappdata(handles.viewData,'treatmentColors',colors);
    end    
    plotDataFromHandles(handles);
    
end

% --------------------------------------------------------------------
function grpColors_Callback(~, ~, handles)
% hObject    handle to grpColors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
treatmentNames = getappdata(handles.viewData,'treatmentNames');
treatmentColors = getappdata(handles.viewData,'treatmentColors');
treatmentColors = colorpicker(treatmentNames,treatmentColors);
setappdata(handles.viewData,'treatmentColors',treatmentColors);

% --------------------------------------------------------------------
function clsPieChart_Callback(~, ~, handles)
% hObject    handle to clsPieChart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isappdata(handles.viewData,'clsInd'))
    errordlg('Please run clustering','','modal');
    return;    
end
% opData = getappdata(handles.viewData,'opData');
opText = getappdata(handles.viewData,'opText');
sel = getappdata(handles.viewData,'ColumnforViewing');
treatmentNames = getappdata(handles.viewData,'treatmentNames');
grp = getGroupIndices(opText(:,sel),treatmentNames);
clsInd = getappdata(handles.viewData,'clsInd');
redData = getappdata(handles.viewData,'redData');
map = getappdata(handles.viewData,'treatmentColors');
viewScatterPie2(redData,clsInd,grp,map)


% --------------------------------------------------------------------
function plotAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to show3DImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function show3DImage_Callback(hObject, eventdata, handles)
% hObject    handle to show3DImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% show3DImage
d = get(handles.plotAxes,'CurrentPoint')

% --------------------------------------------------------------------
function C1_ContextMenu_Callback(hObject, eventdata, handles)
% hObject    handle to C1_ContextMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
