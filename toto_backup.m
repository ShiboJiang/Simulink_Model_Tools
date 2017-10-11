function varargout = toto(varargin)
% TOTO MATLAB code for toto.fig
%      TOTO, by itself, creates a new TOTO or raises the existing
%      singleton*.
%
%      H = TOTO returns the handle to a new TOTO or the handle to
%      the existing singleton*.
%
%      TOTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOTO.M with the given input arguments.
%
%      TOTO('Property','Value',...) creates a new TOTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before toto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to toto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help toto

% Last Modified by GUIDE v2.5 18-Sep-2017 15:30:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @toto_OpeningFcn, ...
                   'gui_OutputFcn',  @toto_OutputFcn, ...
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


% --- Executes just before toto is made visible.
function toto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to toto (see VARARGIN)

% Choose default command line output for toto
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes toto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = toto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in add_sig_para.
function add_sig_para_Callback(hObject, eventdata, handles)
% hObject    handle to add_sig_para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
add_sig_parameter()


% --- Executes on button press in resolve_sig.
function resolve_sig_Callback(hObject, eventdata, handles)
% hObject    handle to resolve_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resolve_signals()

% --- Executes on button press in propagate_sig.
function propagate_sig_Callback(hObject, eventdata, handles)
% hObject    handle to propagate_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
propagate_signals()


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in rename_port.
function rename_port_Callback(hObject, eventdata, handles)
% hObject    handle to rename_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rename_port_to_sig()


% --- Executes on button press in clear_resolve.
function clear_resolve_Callback(hObject, eventdata, handles)
% hObject    handle to clear_resolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear_resolve()


% --- Executes on button press in clear_propagate.
function clear_propagate_Callback(hObject, eventdata, handles)
% hObject    handle to clear_propagate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear_propagate()


% --- Executes on button press in creat_p_file.
function creat_p_file_Callback(hObject, eventdata, handles)
% hObject    handle to creat_p_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
creat_p_files()


% --- Executes on button press in ERT_target.
function ERT_target_Callback(hObject, eventdata, handles)
% hObject    handle to ERT_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ERT_configuration()

% --- Executes on button press in AutoSAR_target.
function AutoSAR_target_Callback(hObject, eventdata, handles)
% hObject    handle to AutoSAR_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Autosar_configuration()


% --- Executes on button press in hide_block_name.
function hide_block_name_Callback(hObject, eventdata, handles)
% hObject    handle to hide_block_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hide_name_blocks()


% --- Executes on button press in hide_port_name.
function hide_port_name_Callback(hObject, eventdata, handles)
% hObject    handle to hide_port_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hide_name_ports()

% --- Executes on button press in show_port_name.
function show_port_name_Callback(hObject, eventdata, handles)
% hObject    handle to show_port_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_name_ports()

% --- Executes on button press in show_block_name.
function show_block_name_Callback(hObject, eventdata, handles)
% hObject    handle to show_block_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_name_blocks()


% --- Executes on button press in fix_sf_datatype.
function fix_sf_datatype_Callback(hObject, eventdata, handles)
% hObject    handle to fix_sf_datatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fix_stateflow_parameter_type()






