function varargout = Compress(varargin)
% COMPRESS MATLAB code for Compress.fig
%      COMPRESS, by itself, creates a new COMPRESS or raises the existing
%      singleton*.
%
%      H = COMPRESS returns the handle to a new COMPRESS or the handle to
%      the existing singleton*.
%
%      COMPRESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPRESS.M with the given input arguments.
%
%      COMPRESS('Property','Value',...) creates a new COMPRESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Compress_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Compress_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Compress

% Last Modified by GUIDE v2.5 08-May-2020 15:13:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Compress_OpeningFcn, ...
                   'gui_OutputFcn',  @Compress_OutputFcn, ...
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


% --- Executes just before Compress is made visible.
function Compress_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Compress (see VARARGIN)

% Choose default command line output for Compress
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Compress wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Compress_OutputFcn(hObject, eventdata, handles) 
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
global ori_img;
[file ,ori_path] = uigetfile;
ori_file = fullfile(ori_path,file);
ori_img = imread(ori_file);
axes(handles.axes1);
imshow(ori_img)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mark_img;
[file ,ori_path] = uigetfile;
mark_file = fullfile(ori_path,file);
mark_img = imread(mark_file);
axes(handles.axes3);
imshow(mark_img)




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global Qv;
Qv = get(handles.edit1,'String');


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bit;
bit = get(handles.edit2,'String');

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.

function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ori_img;
global mark_img;
global bit;
global mode;
global rate;

ori_img = imresize(ori_img,[size(ori_img,1),size(ori_img,1)]);
mark_img = imresize(mark_img,[size(ori_img,1),size(ori_img,1)]);
rsize=floor(size(ori_img,1)/floor(rate));
mar_img = imresize(mark_img,[rsize,rsize]);
state=mar_img;
sty=mar_img;
stx=mar_img;
for i=1:rate-1
    mar_img = [mar_img sty];
    stx = [stx state];
    sty = [sty ; state];
    mar_img = [mar_img ; stx];
end
% axes(handles.axes5);
% imshow(mar_img)
if isequal(mode,{'gray'})
    ori_gray = rgb2gray(ori_img);
    img_gray = rgb2gray(mar_img);
    img_gray = imresize(img_gray,[size(ori_gray,1),size(ori_gray,2)]);
    img_bin = zeros(size(img_gray,1),size(img_gray,2));
    img_gray = imbinarize(img_gray);
    axes(handles.axes5);
    imshow(img_gray)
    imwrite(img_gray,'watermrak.jpg','jpg');
    for i = 1:size(ori_gray,1)
        for j = 1:size(ori_gray,2)
            bin_ori = dec2bin( ori_gray(i,j),8 );
            %bin_img = dec2bin( img_gray(i,j),8 );
            sta_ori = bin_ori;
            %sta_ori(str2double(bit)) =  bin_img(str2double(bit));
            sta_ori(str2double(bit)) = dec2bin(double(img_gray(i,j)));
            img_bin(i,j) = bin2dec( sta_ori );
        end
    end
else
    mrk_img = imresize(mar_img,[size(ori_img,1),size(ori_img,2)]);
    img_bin = zeros(size(ori_img,1),size(ori_img,2),size(ori_img,3));

    ori_gray = double(ori_img);
    %img_gray = double(mrk_img);
    img_gray = rgb2gray(mrk_img);
%    img_gray(:,:,1) = imbinarize(img_gray(:,:,1));
%    img_gray(:,:,2) = imbinarize(img_gray(:,:,2));
%    img_gray(:,:,3) = imbinarize(img_gray(:,:,3));
    img_gray = imbinarize(img_gray);
    axes(handles.axes5);
    imshow(img_gray*255)
    imwrite(img_gray,'watermrak.jpg','jpg');
    for k =1:3
        for i = 1:size(ori_gray,1)
            for j = 1:size(ori_gray,2)
                bin_ori = dec2bin( ori_gray(i,j,k),8 );
                %bin_img = dec2bin( img_gray(i,j,k),8 );
                sta_ori = bin_ori;
                %sta_ori(str2double(bit)) =  bin_img(str2double(bit));
                sta_ori(str2double(bit)) =  dec2bin(double(img_gray(i,j)));
                img_bin(i,j,k) = bin2dec( sta_ori );
            end
        end
    end
end
%  mrk_img = imread('yzu.jpg');
%  imshow(mrk_img)
global Qv;
qv=str2double(Qv);
imwrite(uint8(img_bin),'watermraked.jpg','jpg','Quality',qv);
axes(handles.axes2);
compress = imread('watermraked.jpg');
imshow(compress)
de_bin = bitand(compress,2^(7-(str2double(bit)-1)));
imwrite(de_bin*255,'dewatermrak.jpg','jpg');
de_bin= imread('dewatermrak.jpg');
if isequal(mode,{'rgb'})
    img_gray(:,:,1)=img_gray(:,:,1);
    img_gray(:,:,2)=img_gray(:,:,1);
    img_gray(:,:,3)=img_gray(:,:,1);
end
axes(handles.axes4);
imshow(de_bin)
psnr_img=[];
energy=[];
for i=1:rate
    for j=1:rate
        psnr_now = psnr(de_bin( (i-1)*size(de_bin,1)/rate+1:i*size(de_bin,1)/rate, (j-1)*size(de_bin,1)/rate+1:j*size(de_bin,1)/rate, : ),uint8(img_gray( (i-1)*size(de_bin,1)/rate+1:i*size(de_bin,1)/rate, (j-1)*size(de_bin,1)/rate+1:j*size(de_bin,1)/rate, : ))*255);
        psnr_img = [psnr_img psnr_now];
        energy_new = imgradient(ori_gray( (i-1)*size(de_bin,1)/rate+1:i*size(de_bin,1)/rate, (j-1)*size(de_bin,1)/rate+1:j*size(de_bin,1)/rate, : ),'prewitt');
        eng_new = sum(energy_new,'all')/size(energy_new,1)/size(energy_new,2);
        energy = [energy eng_new];
    end
end
ps = psnr_img/max(psnr_img);
en = energy/max(energy);
axes(handles.axes6);
bar(ps)
axes(handles.axes7);
x=1:rate*rate;
plot(x,ps,x,en)
legend('PSNR','Energy')


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
port = {'gray','rgb'};
set(hObject,'String',port);
global mode;
mo = get(hObject,'Value');
mode = port(mo);
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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rate;
rate = str2double(get(hObject,'String'));
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
