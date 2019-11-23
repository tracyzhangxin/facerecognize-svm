function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 24-Nov-2019 01:34:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in takephoto.
function takephoto_Callback(hObject, eventdata, handles)
% hObject    handle to takephoto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 获取本机中已经安装的硬件资源列表
imaqhwinfo

% 建立videoinput对象
obj = videoinput('macvideo',1);

% 设置属性
set(obj, 'FramesPerTrigger', 1);
set(obj, 'TriggerRepeat', Inf);
set(obj, 'ReturnedColorSpace','rgb');
% 建立界面
hf = figure('Units', 'Normalized', 'Menubar', 'None', ...
    'NumberTitle', 'off', 'Name', '拍照系统');
ha = axes('Parent', hf, 'Units', 'Normalized', ...
    'Position', [.02 .2 .96 .7]);
axis off
hb1 = uicontrol('Parent', hf, 'Units', 'Normalized', ...
    'Position', [.05 .05 .15 .1], 'String', '预览', ...
    'Callback', ...
    ['objRes = get(obj, ''VideoResolution'');' ...
     'nBands = get(obj, ''NumberOfBands'');' ...
     'hImage = image(zeros(objRes(2), objRes(1), nBands));' ...
     'preview(obj, hImage);']);
hb2 = uicontrol('Parent', hf, 'Units', 'Normalized', ...
    'Position', [.3 .05 .15 .1], 'String', '拍照', ...
    'Callback', 'imwrite(imresize(getsnapshot(obj),[112,92]), ''dataset/test/im.pgm'');');
hb3 = uicontrol('Parent',hf,'Units','Normalized', ...
    'Position',[.55 .05 .15 .1],'String', '查看', ...
    'Callback','imshow(''dataset/test/im.pgm'')');
hb4 = uicontrol('Parent',hf,'Units','Normalized', ...
    'Position',[.8 .05 .15 .1],'String', '删除', ...
    'Callback','delete(''dataset/test/im.pgm'')');


% --- Executes on button press in svmtrain.
function svmtrain_Callback(hObject, eventdata, handles)
% hObject    handle to svmtrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global V
global model
global train_label
[train_faceContainer,train_label] = ReadFace(40,0);
[pcaA,V]=fastPCA(train_faceContainer,33);
[scaledface] = trainscaling( pcaA,-1,1 );
model = svmtrain(train_label,scaledface,'-t 0 ');


% --- Executes on button press in recognize.
function recognize_Callback(hObject, eventdata, handles)
% hObject    handle to recognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_label
global scaled_testData
global model
[predict_label,accuracy,prob_estimates]=svmpredict(test_label,scaled_testData,model);
facepath = strcat('dataset/train/s', num2str(predict_label),'/1.pgm');
axes(handles.axes3);
imshow(facepath);



% --- Executes on button press in choosephoto.
function choosephoto_Callback(hObject, eventdata, handles)
% hObject    handle to choosephoto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global test_label
global scaled_testData
[filename, pathname] = uigetfile({'*.pgm'},'choose photo');
facepath = [pathname, filename];
[test_faceContainer,test_label]=readOnePersion(facepath);

load 'ORL/PCA.mat'
testData = (test_faceContainer - meanVec) * V;
scaled_testData = scaling( testData,-1,1);

im = imread(facepath);
axes( handles.axes1);
imshow(im);


% --- Executes on button press in accuracy.
function accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global model
[test_faceContainer,test_label]=ReadFace(40, 1);
load 'ORL/PCA.mat'
testData = (test_faceContainer - meanVec) * V;
scaled_testData2 = testscaling(testData,-1,1);
[predict_label,accuracy,prob_estimates]=svmpredict(test_label, scaled_testData2, model);
result = accuracy(1);
result = strcat( num2str(result), '%');
h = msgbox(['Classifier accuracy:   ', result]);
set(h,'resize','on')



