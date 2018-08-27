function varargout = msqwadd_GUI(varargin)
% MSQWADD_GUI M-file for msqwadd_GUI.fig
%      MSQWADD_GUI, by itself, creates a new MSQWADD_GUI or raises the existing
%      singleton*.
%
%      H = MSQWADD_GUI returns the handle to a new MSQWADD_GUI or the handle to
%      the existing singleton*.
%
%      MSQWADD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSQWADD_GUI.M with the given input arguments.
%
%      MSQWADD_GUI('Property','Value',...) creates a new MSQWADD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before msqwadd_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to msqwadd_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help msqwadd_GUI

% Last Modified by GUIDE v2.5 31-Mar-2010 14:07:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @msqwadd_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @msqwadd_GUI_OutputFcn, ...
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


% --- Executes just before msqwadd_GUI is made visible.
function msqwadd_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to msqwadd_GUI (see VARARGIN)

% Choose default command line output for msqwadd_GUI
handles.output = hObject;

% Temporary analyser choice
handles.chosen_analyser=1;

% Use eval command to get standard number of analysers used on instrument
% This is read from a non-visible box in the .fig file
handles.analysers = eval([ '[' get(handles.analysers_ref,'String') ']']);

% Initialise largest possible number of scans
max_num_scans=25;

% Set up zero array for the T_shifts to be applied to the data
handles.T_shifts = zeros(max_num_scans,length(handles.analysers));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes msqwadd_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = msqwadd_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function file1_find_Callback(hObject, eventdata, handles)
% hObject    handle to load_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spec_number=1;

% Read SPEC file into MatLab using intrinsic MatLab interface
[temp,handles.datadir,filterindex] = uigetfile({'*.*','All Files (*.*)'},'Choose SPEC file','MultiSelect', 'on');
eval(['handles.specfile(' num2str(spec_number) ')= {temp};']);

eval(['set(handles.file' num2str(spec_number) '_tag,''string'',handles.specfile(' num2str(spec_number) '));']);

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function file2_find_Callback(hObject, eventdata, handles)
% hObject    handle to load_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spec_number=2;

% Read SPEC file into MatLab using intrinsic MatLab interface
[temp,handles.datadir,filterindex] = uigetfile({'*.*','All Files (*.*)'},'Choose SPEC file','MultiSelect', 'on');
eval(['handles.specfile(' num2str(spec_number) ')= {temp};']);

eval(['set(handles.file' num2str(spec_number) '_tag,''string'',handles.specfile(' num2str(spec_number) '));']);

% Update handles structure
guidata(hObject, handles);

function file1_scannums_Callback(hObject, eventdata, handles)
% hObject    handle to file1_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file1_scannums as text
%        str2double(get(hObject,'String')) returns contents of file1_scannums as a double

handles=load_all_scans(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function file1_scannums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file1_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file2_scannums_Callback(hObject, eventdata, handles)
% hObject    handle to file1_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file1_scannums as text
%        str2double(get(hObject,'String')) returns contents of file1_scannums as a double

handles=load_all_scans(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function file2_scannums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file2_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file3_scannums_Callback(hObject, eventdata, handles)
% hObject    handle to file1_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file1_scannums as text
%        str2double(get(hObject,'String')) returns contents of file1_scannums as a double

handles=load_all_scans(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function file3_scannums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file3_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file4_scannums_Callback(hObject, eventdata, handles)
% hObject    handle to file1_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file1_scannums as text
%        str2double(get(hObject,'String')) returns contents of file1_scannums as a double

handles=load_all_scans(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function file4_scannums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file4_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file5_scannums_Callback(hObject, eventdata, handles)
% hObject    handle to file1_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file1_scannums as text
%        str2double(get(hObject,'String')) returns contents of file1_scannums as a double

handles=load_all_scans(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function file5_scannums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file5_scannums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles_out = load_all_scans(handles)

handles_out = handles;

% Read scan_numbers from Callback, using eval command so colon operator can
% be used
num_specfile_max=5;

for i=1:num_specfile_max
    handles_out.scan_numbers(i) = {eval(['[' eval(['get(handles.file' num2str(i) '_scannums,''String'')']) ']' ])};
end

total_scan_nums=length(cell2mat(handles_out.scan_numbers));

i=1;
% Set data<i>_tag
for j=1:num_specfile_max
        scan_nums = cell2mat(handles_out.scan_numbers(j));
    for k=1:length(scan_nums)
        % Set data<i>_tag button label to 'Scan <scan_number>'
        eval(['set(handles_out.data' num2str(i) '_tag,''String'',''' char(handles.specfile(j)) '_' num2str(scan_nums(k)) ''');']);
        % Set data<i>_tag button value to 'true', i.e. 'pressed'
        eval(['set(handles_out.data' num2str(i) '_tag,''Value'',1);']);
        i=i+1;
    end
end

% Initialise state of data<i>_tag: all are pressed
handles_out.state = true(total_scan_nums,1);

% Load scans from SPEC file
handles_out.data = ID28_loaddata(handles.datadir,handles.specfile,handles_out.scan_numbers);

% Plot data for chosen analyser (using current values of T_shifts)
handles_out=Tshift_and_replot(handles_out);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function ref_popup_Callback(hObject, eventdata, handles)
% hObject    handle to ref_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ref_popup as text
%        str2double(get(hObject,'String')) returns contents of ref_popup as a double
 
% Determine the selected data set.
 str = get(hObject,'String');
 val = get(hObject,'Value');

 % Set current data to the selected data set.
switch str{val};
    case '' % User has made no selection
        handles.Si_refl=NaN;        
    case '(7 7 7)' % User selects 777
        handles.Si_refl=7;
    case '(8 8 8)' % User selects 888
        handles.Si_refl=8;
    case '(9 9 9)' % User selects 999
        handles.Si_refl=9;
    case '(11 11 11)' % User selects 111111
        handles.Si_refl=11;
    case '(12 12 12)' % User selects 121212
        handles.Si_refl=12;
    case '(13 13 13)' % User selects 131313
        handles.Si_refl=13;
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ref_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ref_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in anal_popup.
function anal_popup_Callback(hObject, eventdata, handles)
% hObject    handle to anal_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns anal_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from anal_popup

 % Determine the selected data set.
 str = get(hObject,'String');
 val = get(hObject,'Value');

 % Set current data to the selected data set.
switch str{val};
    case '1' % User selects Analyser 1
        handles.chosen_analyser=1;
    case '2' % User selects Analyser 2
        handles.chosen_analyser=2;
    case '3' % User selects Analyser 3
        handles.chosen_analyser=3;
    case '4' % User selects Analyser 4
        handles.chosen_analyser=4;
    case '5' % User selects Analyser 5
        handles.chosen_analyser=5;
    case '6' % User selects Analyser 6
        handles.chosen_analyser=6;
    case '7' % User selects Analyser 7
        handles.chosen_analyser=7;
    case '8' % User selects Analyser 8
        handles.chosen_analyser=8;
    case '9' % User selects Analyser 9
        handles.chosen_analyser=9;
end

for i=1:length(cell2mat(handles.scan_numbers))
    % Update all data_tag values
    handles=update_data_tag(handles,i);
    % Update slider value
    handles=update_slider(handles,i);
end

% Plot data for chosen analyser (using current values of T_shifts)
handles=Tshift_and_replot(handles);
        
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function anal_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anal_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in data1_tag.
function data1_tag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in data2_tag.
function data2_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data2_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data3_tag.
function data3_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data3_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data4_tag.
function data4_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data4_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data5_tag.
function data5_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data5_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in data6_tag.
function data6_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data6_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data6_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data7_tag.
function data7_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data7_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data7_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data8_tag.
function data8_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data8_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data8_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data9_tag.
function data9_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data9_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data9_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in data10_tag.
function data10_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data10_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data10_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in data11_tag.
function data11_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data11_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data11_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data12_tag.
function data12_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data12_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data12_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data13_tag.
function data13_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data13_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data13_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data14_tag.
function data14_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data14_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data14_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data15_tag.
function data15_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data15_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data15_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data16_tag.
function data16_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data16_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data16_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data17_tag.
function data17_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data17_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data17_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data18_tag.
function data18_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data18_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data18_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data19_tag.
function data19_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data19_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data19_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data20_tag.
function data20_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data20_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data20_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data21_tag.
function data21_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data21_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data21_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data22_tag.
function data22_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data22_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data22_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data23_tag.
function data23_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data23_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data23_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data24_tag.
function data24_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data24_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data24_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in data25_tag.
function data25_tag_Callback(hObject, eventdata, handles)
% hObject    handle to data25_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data25_tag

% DTreplot checks the statii of the data<i>_tag buttons and replots the
% data accordingly
handles=DTreplot(handles);

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles_out=DTreplot(handles)

% Copy input handles into output handles
handles_internal=handles;

% Find state of all data<i>_tag buttons
for i=1:length(cell2mat(handles.scan_numbers))
    eval(['handles_internal.state(' num2str(i) ')= get(handles.data' num2str(i) '_tag,''Value'');']);
end

if isequal(sum(handles_internal.state),0)
    % If no data<i> buttons are pressed, clear the axis
    cla(handles_internal.x_temp)
    handles_out=handles_internal;
else
    % Apply user-defined Tshift and replot data
    handles_out=Tshift_and_replot(handles_internal);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T_data1_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data1_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data1_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data1_tag
%        as a double

% Set data_number
data_number=1;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data1_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data1_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function T_data2_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data2_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data2_tag as a double

% Set data_number
data_number=2;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data2_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function T_data3_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data3_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data3_tag as a double

% Set data_number
data_number=3;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data3_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function T_data4_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data4_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data4_tag as a double

% Set data_number
data_number=4;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data4_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function T_data5_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=5;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data5_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function T_data6_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=6;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data6_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_data7_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=7;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data7_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data8_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=8;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data8_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data9_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=9;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data9_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data10_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=10;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data10_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data11_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=11;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data11_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data12_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=12;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data12_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data13_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=13;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data13_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data14_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=14;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data14_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data15_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=15;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data15_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data16_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=16;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data16_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data17_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=17;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data17_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data18_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=18;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data18_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data19_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=19;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data19_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data20_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=20;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data20_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data21_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=21;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data21_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data22_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=22;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data22_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data23_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=23;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data23_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data24_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=24;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data24_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function T_data25_tag_Callback(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_data5_tag as text
%        str2double(get(hObject,'String')) returns contents of T_data5_tag as a double

% Set data_number
data_number=25;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=str2double(get(hObject,'String'));
    
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update slider value
handles=update_slider(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function T_data25_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_data5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles_out=Tshift_and_replot(handles)

% Copy input handles into output handles
handles_out=handles;

handles_out.data = ID28_Tshift(handles_out.data,handles_out.specfile,handles_out.scan_numbers,handles_out.state,handles_out.chosen_analyser,handles_out.T_shifts);
ID28_DTplotunsummed_GUI(handles_out.data,handles_out.specfile,handles_out.scan_numbers,handles_out.state,handles_out.chosen_analyser,handles_out.x_temp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles_out=update_slider(handles,data_number)

% Copy input handles into output handles
handles_out=handles;

eval(['set(handles_out.slider_data' num2str(data_number) ',''value'',handles.T_shifts(data_number,handles.chosen_analyser));']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles=update_data_tag(handles,data_number)

% Copy input handles into output handles
handles_out=handles;

eval(['set(handles_out.T_data' num2str(data_number) '_tag,''string'',num2str(handles.T_shifts(data_number,handles.chosen_analyser)));']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function slider_data1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=1;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)

% --- Executes on slider movement.
function slider_data2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Set data_number
data_number=2;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)

% --- Executes on slider movement.
function slider_data3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Set data_number
data_number=3;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)

% --- Executes on slider movement.
function slider_data4_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Set data_number
data_number=4;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)

% --- Executes on slider movement.
function slider_data5_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=5;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)

% --- Executes on slider movement.
function slider_data6_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=6;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)


% --- Executes on slider movement.
function slider_data7_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=7;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data8_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=8;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data9_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=9;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data10_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=10;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data11_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=11;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data12_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=12;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data13_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=13;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data14_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=14;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data15_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=15;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data16_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=16;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data17_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=17;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data18_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=18;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data19_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=19;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data20_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=20;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data21_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=21;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data22_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=22;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data23_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=23;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data24_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=24;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)



% --- Executes on slider movement.
function slider_data25_Callback(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% Set data_number
data_number=25;

% Edit T_shifts
handles.T_shifts(data_number,handles.chosen_analyser)=get(hObject,'Value');
  
% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_data25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Initialise slider
init_slider(hObject)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function init_slider(hObject)

set(hObject,'Min',-1)
set(hObject,'Max',+1)
set(hObject,'Value',0);
set(hObject,'SliderStep',[0.002 0.01])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in fit_data1.
function fit_data1_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=1;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in fit_data2.
function fit_data2_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=2;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data3.
function fit_data3_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=3;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in fit_data4.
function fit_data4_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=4;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in fit_data5.
function fit_data5_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=5;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data6_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=6;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data7_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=7;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data8_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=8;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in fit_data6.
function fit_data9_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=9;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data10_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=10;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data11_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=11;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data12_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=12;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data13_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=13;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data14_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=14;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data15_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=15;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data16_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=16;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data17_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=17;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data18_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=18;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data19_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=19;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data20_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=20;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data21_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=21;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data22_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=22;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data23_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=23;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data24_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=24;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fit_data6.
function fit_data25_Callback(hObject, eventdata, handles)
% hObject    handle to fit_data6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set data_number
data_number=25;

% Get x and y limits on temperature plot
xlim=get(handles.x_temp,'XLim');
ylim=get(handles.x_temp,'YLim');
T_shift_temp=handles.T_shifts(data_number,handles.chosen_analyser);

% Fit elastic line using limits on temperature plot
[handles.data,handles.T_shifts] = ID28_fitelasticline(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.T_shifts,xlim,ylim);

% Update data_tag value
handles=update_data_tag(handles,data_number);

% Update slider value
handles=update_slider(handles,data_number);

% Apply user-defined Tshift and replot data
handles=Tshift_and_replot(handles);

% Plot fit to elastic line
ID28_plotfit(handles.data,handles.specfile,handles.scan_numbers,data_number,handles.chosen_analyser,handles.x_temp)

% Get x and y limits on temperature plot
set(handles.x_temp,'XLim',xlim+T_shift_temp-handles.T_shifts(data_number,handles.chosen_analyser));
set(handles.x_temp,'YLim',ylim);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in conv_data1.
function conv_data_Callback(hObject, eventdata, handles)
% hObject    handle to conv_data1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Convert scans which are to be summed onto energy scale
handles.data = temp2energy(handles.data,handles.specfile,handles.scan_numbers,handles.state,handles.chosen_analyser,handles.Si_refl);

% If there are more than two scans (i.e. combining is required)
if sum(handles.state)>1
    
    % Create interpolated energy scales
    handles.Xs=ID28_Xinterpolate(handles.data,handles.specfile,handles.scan_numbers,handles.state,handles.chosen_analyser);
    
    % Sum data
    [runs,handles.Is_sum,handles.Ns_sum,handles.Es_sum,handles.Ys,handles.Es]=ID28_sumdata(handles.data,handles.specfile,handles.scan_numbers,handles.state,handles.chosen_analyser,handles.Xs);

    % Plot summed data on energy axis
    [handles.Xs,handles.Ys,handles.Es]=ID28_Eplotsummed_GUI(handles.chosen_analyser,handles.Xs,handles.Ys,handles.Es,handles.x_energy);

% If there is only one scan (no combining is required)
elseif isequal(sum(handles.state),1)
    
    % Plot converted data on energy axis (no interpolation of energy axis)
    [handles.Xs,handles.Is_sum,handles.Ns_sum,handles.Es_sum,handles.Ys,handles.Es]=ID28_Eplotunsummed(handles.data,handles.specfile,handles.scan_numbers,handles.state,handles.chosen_analyser,handles.x_energy);

end

% make automatic filenamestem
handles.filenamestem = ID28_make_filenamestem(handles.specfile,handles.scan_numbers,handles.state);

% update filename_tag with automatic choice
set(handles.filename_tag,'string',handles.filenamestem)

% Update handles structure
guidata(hObject, handles);


function file1_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file1_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file1_tag as text
%        str2double(get(hObject,'String')) returns contents of file1_tag as a double


% --- Executes during object creation, after setting all properties.
function file1_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file1_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file2_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file2_tag as text
%        str2double(get(hObject,'String')) returns contents of file2_tag as a double


% --- Executes during object creation, after setting all properties.
function file2_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file2_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file3_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file3_tag as text
%        str2double(get(hObject,'String')) returns contents of file3_tag as a double


% --- Executes during object creation, after setting all properties.
function file3_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file3_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file4_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file4_tag as text
%        str2double(get(hObject,'String')) returns contents of file4_tag as a double


% --- Executes during object creation, after setting all properties.
function file4_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file4_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file5_tag_Callback(hObject, eventdata, handles)
% hObject    handle to file5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file5_tag as text
%        str2double(get(hObject,'String')) returns contents of file5_tag as a double


% --- Executes during object creation, after setting all properties.
function file5_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file5_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function filename_tag_Callback(hObject, eventdata, handles)
% hObject    handle to filename_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_tag as text
%        str2double(get(hObject,'String')) returns contents of filename_tag as a double

handles.filenamestem = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filename_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in output_tag.
function output_tag_Callback(hObject, eventdata, handles)
% hObject    handle to output_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ID28_writedata_GUI(handles.datadir,handles.specfile,handles.scan_numbers,handles.state,handles.chosen_analyser,handles.Xs,handles.Ys,handles.Es,handles.Is_sum,handles.Ns_sum,handles.Es_sum,handles.filenamestem);
