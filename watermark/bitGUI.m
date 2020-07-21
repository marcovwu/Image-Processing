function varargout = bitGUI(varargin)
% BITGUI MATLAB code for bitGUI.fig
%      BITGUI, by itself, creates a new BITGUI or raises the existing
%      singleton*.
%
%      H = BITGUI returns the handle to a new BITGUI or the handle to
%      the existing singleton*.
%
%      BITGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BITGUI.M with the given input arguments.
%
%      BITGUI('Property','Value',...) creates a new BITGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bitGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bitGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bitGUI

% Last Modified by GUIDE v2.5 24-Apr-2020 11:29:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bitGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @bitGUI_OutputFcn, ...
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


% --- Executes just before bitGUI is made visible.
function bitGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bitGUI (see VARARGIN)

% Choose default command line output for bitGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bitGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bitGUI_OutputFcn(hObject, eventdata, handles) 
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
global file;
[file ,ori_path] = uigetfile();
%ori = imread(ori_path);
ori=file;
axes(handles.axes13);
imshow(ori)
img = imread('yzu.jpg');
axes(handles.axes14);
imshow(img)
img_gray = rgb2gray(img);

img_bin1 = bitand(img_gray,1)*255;
img_bin2 = bitand(img_gray,2)*255;
img_bin3 = bitand(img_gray,4)*255;
img_bin4 = bitand(img_gray,8)*255;
img_bin5 = bitand(img_gray,16)*255;
img_bin6 = bitand(img_gray,32)*255;
img_bin7 = bitand(img_gray,64)*255;
img_bin8 = bitand(img_gray,128)*255;

axes(handles.axes1);
imshow(img_bin1)
axes(handles.axes2);
imshow(img_bin2)
axes(handles.axes4);
imshow(img_bin3)
axes(handles.axes5);
imshow(img_bin4)
axes(handles.axes8);
imshow(img_bin5)
axes(handles.axes9);
imshow(img_bin6)
axes(handles.axes10);
imshow(img_bin7)
axes(handles.axes11);
imshow(img_bin8)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ori = imread('lena.jpg');
global file;
ori = file;
axes(handles.axes13);
imshow(ori)
ori_gray = rgb2gray(ori);
img = imread('yzu.jpg');
img = imresize(img,[size(ori,1),size(ori,2)]);
axes(handles.axes14);
imshow(img)
img_gray = rgb2gray(img);

img_bin1 = zeros(size(ori,1),size(ori,2));
img_bin2 = zeros(size(ori,1),size(ori,2));
img_bin3 = zeros(size(ori,1),size(ori,2));
img_bin4 = zeros(size(ori,1),size(ori,2));
img_bin5 = zeros(size(ori,1),size(ori,2));
img_bin6 = zeros(size(ori,1),size(ori,2));
img_bin7 = zeros(size(ori,1),size(ori,2));
img_bin8 = zeros(size(ori,1),size(ori,2));
for i = 1:size(ori_gray,1)
    for j = 1:size(ori_gray,2)
        bin_ori = dec2bin( ori_gray(i,j),8 );
        bin_img = dec2bin( img_gray(i,j),8 );
        sta_ori = bin_ori;
        sta_ori(1) =  bin_img(1);
        img_bin1(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(2) =  bin_img(2);
        img_bin2(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(3) =  bin_img(3);
        img_bin3(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(4) =  bin_img(4);
        img_bin4(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(5) =  bin_img(5);
        img_bin5(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(6) =  bin_img(6);
        img_bin6(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(7) =  bin_img(7);
        img_bin7(i,j) = bin2dec( sta_ori );
        sta_ori = bin_ori;
        sta_ori(8) =  bin_img(8);
        img_bin8(i,j) = bin2dec( sta_ori );
    end
end

axes(handles.axes1);
imshow(uint8(img_bin1))
axes(handles.axes2);
imshow(uint8(img_bin2))
axes(handles.axes4);
imshow(uint8(img_bin3))
axes(handles.axes5);
imshow(uint8(img_bin4))
axes(handles.axes8);
imshow(uint8(img_bin5))
axes(handles.axes9);
imshow(uint8(img_bin6))
axes(handles.axes10);
imshow(uint8(img_bin7))
axes(handles.axes11);
imshow(uint8(img_bin8))


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
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ori = imread('lena.jpg');
axes(handles.axes13);
imshow(ori)
img = imread('yzu.jpg');
img = imresize(img,[size(ori,1),size(ori,2)]);
axes(handles.axes14);
imshow(img)

img_bin1 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin2 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin3 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin4 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin5 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin6 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin7 = zeros(size(ori,1),size(ori,2),size(ori,3));
img_bin8 = zeros(size(ori,1),size(ori,2),size(ori,3));
ori_gray = double(ori);
img_gray = double(img);
for k =1:3
    for i = 1:size(ori_gray,1)
        for j = 1:size(ori_gray,2)
            bin_ori = dec2bin( ori_gray(i,j,k),8 );
            bin_img = dec2bin( img_gray(i,j,k),8 );
            sta_ori = bin_ori;
            sta_ori(1) =  bin_img(1);
            img_bin1(i,j,k) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(2) =  bin_img(2);
            img_bin2(i,j,k) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(3) =  bin_img(3);
            img_bin3(i,j,k) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(4) =  bin_img(4);
            img_bin4(i,j) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(5) =  bin_img(5);
            img_bin5(i,j,k) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(6) =  bin_img(6);
            img_bin6(i,j,k) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(7) =  bin_img(7);
            img_bin7(i,j,k) = bin2dec( sta_ori );
            sta_ori = bin_ori;
            sta_ori(8) =  bin_img(8);
            img_bin8(i,j,k) = bin2dec( sta_ori );
        end
    end
end

axes(handles.axes1);
imshow(uint8(img_bin1))
axes(handles.axes2);
imshow(uint8(img_bin2))
axes(handles.axes4);
imshow(uint8(img_bin3))
axes(handles.axes5);
imshow(uint8(img_bin4))
axes(handles.axes8);
imshow(uint8(img_bin5))
axes(handles.axes9);
imshow(uint8(img_bin6))
axes(handles.axes10);
imshow(uint8(img_bin7))
axes(handles.axes11);
imshow(uint8(img_bin8))


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
