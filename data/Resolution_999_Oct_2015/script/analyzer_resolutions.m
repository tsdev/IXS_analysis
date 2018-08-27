function varargout = analyzer_resolutions(varargin)
% analyzer_resolutions M-file for analyzer_resolutions.fig
%      analyzer_resolutions, by itself, creates a new analyzer_resolutions or raises the existing
%      singleton*.
%
%      H = analyzer_resolutions returns the handle to a new analyzer_resolutions or the handle to
%      the existing singleton*.
%
%      analyzer_resolutions('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in analyzer_resolutions.M with the given input arguments.
%
%      analyzer_resolutions('Property','Value',...) creates a new analyzer_resolutions or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analyzer_resolutions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analyzer_resolutions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analyzer_resolutions

% Last Modified by GUIDE v2.5 01-Apr-2011 14:20:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analyzer_resolutions_OpeningFcn, ...
                   'gui_OutputFcn',  @analyzer_resolutions_OutputFcn, ...
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

% --- Executes just before analyzer_resolutions is made visible.
function analyzer_resolutions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analyzer_resolutions (see VARARGIN)

file_id='';

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

str = strcat('aXres',reflexion,'_',mode,file_id,'.exp');
set(handles.FileName,'String', str)

% Constructor of Object S in which all the data will be stored
handles.S = analyzer_resolutions_object ();

% Choose default command line output for analyzer_resolutions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes analyzer_resolutions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

anal_choice(1)=get(handles.checkbox1,'Value');
anal_choice(2)=get(handles.checkbox2,'Value');
anal_choice(3)=get(handles.checkbox3,'Value');
anal_choice(4)=get(handles.checkbox4,'Value');
anal_choice(5)=get(handles.checkbox5,'Value');
anal_choice(6)=get(handles.checkbox6,'Value');
anal_choice(7)=get(handles.checkbox7,'Value');
anal_choice(8)=get(handles.checkbox8,'Value');
anal_choice(9)=get(handles.checkbox9,'Value');

% --- Outputs from this function are returned to the command line.
function varargout = analyzer_resolutions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in Reflection.
function Reflection_Callback(hObject, eventdata, handles)
% hObject    handle to Reflection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns Reflection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Reflection
file_id=get(handles.file_id_tag,'String');

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

str = strcat('aXres',reflexion,'_',mode,file_id,'.exp');
set(handles.FileName,'String', str)


% --- Executes during object creation, after setting all properties.
function Reflection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Reflection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% set(handles.Reflection,3);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mode.
function mode_Callback(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mode

file_id=get(handles.file_id_tag,'String');

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

str = strcat('aXres',reflexion,'_',mode,file_id,'.exp');
set(handles.FileName,'String', str)

% --- Executes during object creation, after setting all properties.
function mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonImport.
function pushbuttonImport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%reads the values for the reflection and the mode of measurements

datadir=get(handles.datadir_tag,'String');

file_id=get(handles.file_id_tag,'String');

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

anal_choice(1)=get(handles.checkbox1,'Value');
anal_choice(2)=get(handles.checkbox2,'Value');
anal_choice(3)=get(handles.checkbox3,'Value');
anal_choice(4)=get(handles.checkbox4,'Value');
anal_choice(5)=get(handles.checkbox5,'Value');
anal_choice(6)=get(handles.checkbox6,'Value');
anal_choice(7)=get(handles.checkbox7,'Value');
anal_choice(8)=get(handles.checkbox8,'Value');
anal_choice(9)=get(handles.checkbox9,'Value');

file_id=get(handles.file_id_tag,'String');

ImportData(datadir,handles.S, reflexion, mode, anal_choice,file_id)
PlotData(handles.S, handles.AnalyzerPlotsPannel, anal_choice);

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


% --- Executes on button press in fitbutton.
function fitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

anal_choice(1)=get(handles.checkbox1,'Value');
anal_choice(2)=get(handles.checkbox2,'Value');
anal_choice(3)=get(handles.checkbox3,'Value');
anal_choice(4)=get(handles.checkbox4,'Value');
anal_choice(5)=get(handles.checkbox5,'Value');
anal_choice(6)=get(handles.checkbox6,'Value');
anal_choice(7)=get(handles.checkbox7,'Value');
anal_choice(8)=get(handles.checkbox8,'Value');
anal_choice(9)=get(handles.checkbox9,'Value');

FitFuncval=get(handles.FitFunctionMenu,'Value');
%FitFuncstring_list = get(handles.FitFunctionMenu,'String');
%FitFunction = modestring_list{modeval};

FitData(handles.S,reflexion, mode, FitFuncval,anal_choice);

PlotData(handles.S, handles.AnalyzerPlotsPannel,anal_choice);
axes(handles.ResolutionPlot);
DisplayResults(handles.S,handles.ResolutionPlot, FitFuncval,anal_choice);




% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

datadir=get(handles.datadir_tag,'String');

file_id=get(handles.file_id_tag,'String');

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

FitFuncval=get(handles.FitFunctionMenu,'Value');

anal_choice(1)=get(handles.checkbox1,'Value');
anal_choice(2)=get(handles.checkbox2,'Value');
anal_choice(3)=get(handles.checkbox3,'Value');
anal_choice(4)=get(handles.checkbox4,'Value');
anal_choice(5)=get(handles.checkbox5,'Value');
anal_choice(6)=get(handles.checkbox6,'Value');
anal_choice(7)=get(handles.checkbox7,'Value');
anal_choice(8)=get(handles.checkbox8,'Value');
anal_choice(9)=get(handles.checkbox9,'Value');

ExportFittedData(datadir,handles.S, reflexion, mode, FitFuncval,anal_choice,file_id);


% --- Executes on selection change in FitFunctionMenu.
function FitFunctionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FitFunctionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FitFuncval=get(handles.FitFunctionMenu,'Value');

switch FitFuncval
    case 1.0
        str='PseudoVoigt function with identical FWHM for Lorentzian and Gaussian';
    case 2.0
        str='PseudoVoigt function with different FWHW for Lorentzian and Gaussian';
    case 3.0
        str='Voigt Function';
    case 4.0
        str='Lorentzian Function';
    case 5.0
        str='Gaussian Function';
    case 6.0
        str='Pseudovoigt function with stretched Lorentzian';
end
set(handles.FitDescription,'String',str)

% Hints: contents = get(hObject,'String') returns FitFunctionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FitFunctionMenu


% --- Executes during object creation, after setting all properties.
function FitFunctionMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FitFunctionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FileName_Callback(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileName as text
%        str2double(get(hObject,'String')) returns contents of FileName as a double


% --- Executes during object creation, after setting all properties.
function FileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in mode.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mode


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileName as text
%        str2double(get(hObject,'String')) returns contents of FileName as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonImport.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fitbutton.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to fitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in FitFunctionMenu.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to FitFunctionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FitFunctionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FitFunctionMenu


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FitFunctionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FitDescription_Callback(hObject, eventdata, handles)
% hObject    handle to FitDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FitDescription as text
%        str2double(get(hObject,'String')) returns contents of FitDescription as a double


% --- Executes during object creation, after setting all properties.
function FitDescription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FitDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

anal_choice=zeros(9,1);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

anal_choice(1)=get(hObject,'Value');

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

anal_choice(2)=get(hObject,'Value');

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

anal_choice(3)=get(hObject,'Value');

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4

anal_choice(4)=get(hObject,'Value');

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5

anal_choice(5)=get(hObject,'Value');

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox

anal_choice(6)=get(hObject,'Value');

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7

anal_choice(7)=get(hObject,'Value');

% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8

anal_choice(8)=get(hObject,'Value');

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9

anal_choice(9)=get(hObject,'Value');



function file_id_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file_id_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_id_tag as text
%        str2double(get(hObject,'String')) returns contents of file_id_tag as a double

file_id=get(hObject,'String');

Refval=get(handles.Reflection,'Value');
Refstring_list = get(handles.Reflection,'String');
reflexion = Refstring_list{Refval};

modeval=get(handles.mode,'Value');
modestring_list = get(handles.mode,'String');
mode = modestring_list{modeval};

str = strcat('aXres',reflexion,'_',mode,file_id,'.exp');
set(handles.FileName,'String', str)

% --- Executes during object creation, after setting all properties.
function file_id_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_id_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function datadir_tag_Callback(hObject, eventdata, handles)
% hObject    handle to datadir_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datadir_tag as text
%        str2double(get(hObject,'String')) returns contents of datadir_tag as a double

datadir=get(hObject,'String');

% --- Executes during object creation, after setting all properties.
function datadir_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datadir_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_datadir_tag.
function select_datadir_tag_Callback(hObject, eventdata, handles)
% hObject    handle to select_datadir_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

datadir = uigetdir;
set(handles.datadir_tag,'String',datadir)
