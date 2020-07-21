function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 12-Jun-2020 09:58:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
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
global m;
global n;
global k;
global c_x;
global c_y;
global rows;
global cols;
global img;
global bin;
global mode;
global img_num;
global change_k;
global query_img;
global slect_inx;
global slect_his;
global change_mn;
if isempty(mode) 
    mode='histogram';
end
if isempty(rows) 
    rows=240;
    change_mn=1;
else
    rows = size(query_img,1);
end
if isempty(cols) 
    cols=320;
    change_mn=1;
else
    cols = size(query_img,2);
end
img = zeros(rows,cols,3,length(img(:,:,:,:)));
if exist('img_data.mat','file')   
    data = load( 'img_data.mat' );
    img = imresize(data.img,[rows cols]);
else 
    for i = 1:length(img(:,:,:,:))
        img(:,:,:,i) = imresize(imread(['collection_for_1052/collection_for_1052/1 (' num2str(i) ').jpg']),[rows cols]);
    end
    save img_data.mat img
end
s_img=[];
if strcmp('histogram',mode)
    rows = 240;
    cols = 320;
    img = imresize(img,[rows cols]);
    set(handles.edit13,'String',num2str(cols));
    set(handles.edit14,'String',num2str(rows));
    query_img = imresize(query_img,[rows cols]);
    axes(handles.axes11);
    imshow(query_img)
    axes(handles.axes12);
    gray_query = rgb2gray(uint8(query_img));
    histogram(fix(gray_query/16)+1)
    bin = hist(gray_query(:),0:16:255);
    for i = 1:length(img(:,:,:,:))
        his_img = rgb2gray(uint8(img(:,:,:,i)));
        hist_img = hist(his_img(:),0:16:255);
        s_img = [s_img;sum( abs( hist_img-bin ) )];
    end
    s_img = s_img/sum(bin);
elseif strcmp('Vgg Net',mode)
    net = vgg16;
    sz = net.Layers(1).InputSize;
    rows = sz(1);
    cols = sz(2);
    img = imresize(img,[rows cols]);
    set(handles.edit13,'String',num2str(cols));
    set(handles.edit14,'String',num2str(rows));
    query_img = imresize(query_img,[rows cols]);
    axes(handles.axes11);
    imshow(query_img)
    ansf_fc7 = activations(net,query_img,'fc7','OutputAs','rows');
    if exist('f_fc7.mat','file')   
        Sf_fc7 = load( 'f_fc7.mat' );
        f_fc7 = Sf_fc7.f_fc7;
    else 
        for i = 1:length(img(:,:,:,:))
            img(:,:,:,i) = imresize(imread(['collection_for_1052/collection_for_1052/1 (' num2str(i) ').jpg']),[rows cols]);
            f_fc7(i,:) = activations(net,img(:,:,:,i),'fc7','OutputAs','rows');
            i
        end
        save('f_fc7.mat','f_fc7');
    end    
    ansf_fc7_normalizing = normalize(ansf_fc7,2);
    f_fc7_normalizing = normalize(f_fc7,2);
    for j=1:size(f_fc7_normalizing,1)
        diff = ansf_fc7_normalizing - f_fc7_normalizing(j,:);
        s_img(j) = sum(abs(diff));
    end
    s_img = s_img/max(s_img);
elseif strcmp('HSV',mode)
    if isempty(m) 
        m=20;
    end
    if isempty(n) 
        n=30;
    end
    if isempty(change_mn) 
        change_mn=1;
    end
    qhsv_img = rgb2hsv(uint8(query_img));
    imresize(qhsv_img,[floor(rows/m)*m floor(cols/n)*n]);  
    qnew_img = zeros(m,n,size(qhsv_img,3));
    for x = 1:m
        for y = 1:n
            sta1=qhsv_img(floor(rows/m)*(x-1)+1:floor(rows/m)*x,floor(cols/n)*(y-1)+1:floor(cols/n)*y,1);
            sta2=qhsv_img(floor(rows/m)*(x-1)+1:floor(rows/m)*x,floor(cols/n)*(y-1)+1:floor(cols/n)*y,2);
            sta3=qhsv_img(floor(rows/m)*(x-1)+1:floor(rows/m)*x,floor(cols/n)*(y-1)+1:floor(cols/n)*y,3);
            [qhist1_img,qinx1] = max(hist(sta1(:),0:0.06:1));
            [qhist2_img,qinx2] = max(hist(sta2(:),0:0.06:1));
            [qhist3_img,qinx3] = max(hist(sta3(:),0:0.06:1));
            qnew_img(x,y,1)=qinx1/17;
            qnew_img(x,y,2)=qinx2/17;
            qnew_img(x,y,3)=qinx3/17;
        end
    end
    if exist('all_img.mat','file')   
        All_img = load( 'all_img.mat' );
        all_img = All_img.all_img;
    end
    if change_mn == 1 
        all_img=[];
        for i = 1:length(img(:,:,:,:))
            hsv_img = rgb2hsv(uint8(img(:,:,:,i)));
            imresize(hsv_img,[floor(rows/m)*m floor(cols/n)*n]);   
            new_img = zeros(m,n,size(hsv_img,3));
            for x = 1:m
                for y = 1:n
                    sta1=hsv_img(floor(rows/m)*(x-1)+1:floor(rows/m)*x,floor(cols/n)*(y-1)+1:floor(cols/n)*y,1);
                    sta2=hsv_img(floor(rows/m)*(x-1)+1:floor(rows/m)*x,floor(cols/n)*(y-1)+1:floor(cols/n)*y,2);
                    sta3=hsv_img(floor(rows/m)*(x-1)+1:floor(rows/m)*x,floor(cols/n)*(y-1)+1:floor(cols/n)*y,3);
                    [hist1_img,inx1] = max(hist(sta1(:),0:0.06:1));
                    [hist2_img,inx2] = max(hist(sta2(:),0:0.06:1));
                    [hist3_img,inx3] = max(hist(sta3(:),0:0.06:1));
                    new_img(x,y,1)=inx1/17;
                    new_img(x,y,2)=inx2/17;
                    new_img(x,y,3)=inx3/17;
                end
            end
            all_img(end+1,:)=new_img(:)';
            i
        end
        change_mn=0;
        save('all_img.mat','all_img');
    end     
    for i =1:size(all_img,1)
        s_img = [s_img;sum(abs( qnew_img(:)'-all_img(i,:) ),'all')];
    end
    s_img = s_img/m/n/3;
elseif strcmp('AutoEncoder',mode)
    e_data=load('encoded_data.mat');
    encode_data = e_data.encode_data;
    q_data = squeeze(encode_data(img_num,:,:));
    for i=1:size(encode_data,1)
        s_img(i) = sum(abs(q_data-squeeze(encode_data(i,:,:))))/2000;
    end
    s_img = s_img/max(s_img);
elseif strcmp('Color-correloggram',mode)
    cols=320;
    rows=240;
    if isempty(k) 
        k=1;
    end
    if isempty(change_k) 
        change_k=1;
    end
    img = imresize(img,[rows cols]);
    set(handles.edit13,'String',num2str(cols));
    set(handles.edit14,'String',num2str(rows));
    query_img = imresize(query_img,[rows cols]);
    axes(handles.axes11);
    imshow(query_img)
    quantRGB = imquantize(query_img,0:32:255);
    %quantRGB = imresize(quantRGB,[rows cols]);  
    his_value = zeros(9,9,9);
    padimg_q = padarray(quantRGB,[k,k],-1);
    for x=k+1:size(quantRGB,1)+k
        for y=k+1:size(quantRGB,2)+k
            kimg = padimg_q(x-k:x+k,y-k:y+k,:);
            kimg(2:end-1,2:end-1,:) = -1;
            inx = ( (padimg_q(x,y,1)==kimg(:,:,1)) & (padimg_q(x,y,2)==kimg(:,:,2)) ) & (padimg_q(x,y,3)==kimg(:,:,3));
            pluse = find(1==inx);
            if not(isempty(pluse))
                his_value(padimg_q(x,y,1),padimg_q(x,y,2),padimg_q(x,y,3)) = his_value(padimg_q(x,y,1),padimg_q(x,y,2),padimg_q(x,y,3))+1;
            end
        end
    end
    all_value = zeros(length(img(:,:,:,:)),9,9,9);
    if exist('all_value.mat','file')   
        All_value = load( 'all_value.mat' );
        all_value = All_value.all_value;
    end
    if change_k==1
        for i = 1:length(img(:,:,:,:))
            quantRGB = imquantize(img(:,:,:,i),0:32:255);
            %quantRGB = imresize(quantRGB,[rows cols]);  
            padimg_q = padarray(quantRGB,[k,k],-1);
            for x=k+1:size(quantRGB,1)+k
                for y=k+1:size(quantRGB,2)+k
                    kimg = padimg_q(x-k:x+k,y-k:y+k,:);
                    kimg(2:end-1,2:end-1,:) = -1;
                    inx = ( (padimg_q(x,y,1)==kimg(:,:,1)) & (padimg_q(x,y,2)==kimg(:,:,2)) ) & (padimg_q(x,y,3)==kimg(:,:,3));
                    pluse = find(1==inx);
                    if not(isempty(pluse))
                        all_value(i,padimg_q(x,y,1),padimg_q(x,y,2),padimg_q(x,y,3)) = all_value(i,padimg_q(x,y,1),padimg_q(x,y,2),padimg_q(x,y,3))+1;
                    end
                end
            end
            i
        end
        save('all_value.mat','all_value');
        change_k=0;        
    end
    
    for i =1:size(all_value,1)
        s_img = [s_img;sum(abs( his_value(:)'-all_value(i,:) ),'all')];
    end
    s_img = s_img/max(s_img);
elseif strcmp('LBP Features',mode)
    if isempty(c_x) 
        c_x=32;
    end
    if isempty(c_y) 
        c_y=32;
    end
    gray_query = rgb2gray(uint8(query_img));
    query_LBPfeatures = extractLBPFeatures(gray_query, 'CellSize',[c_y,c_x],'Upright',false);
    s_img = [];
    img = imresize(img,[rows cols]);
    for i = 1:length(img(:,:,:,:))
        gray_img = rgb2gray(uint8(img(:,:,:,i)));
        img_LBPfeature = extractLBPFeatures(gray_img, 'CellSize',[c_y,c_x],'Upright',false);
        s_img(i) = sum( abs(img_LBPfeature-query_LBPfeatures)/10, 'all');
    end
elseif strcmp('other',mode)
    for i=1:length(img(:,:,:,:))
        s_img(i) = i;
    end
end
[slect_his,slect_inx] = sort(s_img);
for i=1:10
    eval(['axes(handles.axes' num2str(i) ');'])
    imshow(uint8(img(:,:,:,slect_inx(i))));
    set(eval(['handles.text' num2str(i+4)]),'String',[num2str(slect_inx(i)) '']);
    set(eval(['handles.edit' num2str(i+1)]),'String',[num2str(slect_his(i)) '']);
end

global image_num;
image_num = 10;

global page;
page=1;
set(handles.edit13,'String',num2str(cols));
set(handles.edit14,'String',num2str(rows));
set(handles.text24,'String',mode);
set(handles.edit1,'String',[ num2str(page) '/' num2str((length(img(:,:,:,:))-mod(length(img(:,:,:,:)),10))/10+1)]);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_num;
global mode;
global rows;
global cols;
global bin;
global ori_img;
global query_img;
if isempty(mode)
    mode = 'histogram';
end
if isempty(rows) 
    rows=240;
end
if isempty(cols) 
    cols=320;
end
[file ,ori_path] = uigetfile;
ori_file = fullfile(ori_path,file);
sta = split(ori_file,'\');
sta = split(sta(end),'.');
sta = split(sta(1),' ');
sta = split(sta(2),')');
sta = split(sta(1),'(');
img_num = str2double(sta(2));
ori_img = imread(ori_file);
query_img = imresize(imread(ori_file),[rows cols]);
gray_query = rgb2gray(uint8(query_img));
axes(handles.axes11);
imshow(query_img)
axes(handles.axes12);
histogram(fix(gray_query/16)+1)
bin = hist(gray_query(:),0:16:255);
set(handles.edit13,'String',num2str(cols));
set(handles.edit14,'String',num2str(rows));
set(handles.text24,'String',mode);



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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global page;
global img;
global bin;
global slect_inx;
global slect_his;
if ~exist('page','var') 
    page=1;
else
    if page~=1
        page=page-1;
        inx=1;
        for i=(page-1)*10+1:(page-1)*10+10
            eval(['axes(handles.axes' num2str(inx) ');']);
            set(eval(['handles.text' num2str(inx+4)]),'String',[num2str(slect_inx(i)) '']);
            set(eval(['handles.edit' num2str(inx+1)]),'String',[num2str(slect_his(i)/sum(bin)) '']);
            imshow(uint8(img(:,:,:,slect_inx(i))));
            inx=inx+1;
        end
    end
end
set(handles.edit1,'String',[ num2str(page) '/' num2str((length(img(:,:,:,:))-mod(length(img(:,:,:,:)),10))/10+1)]);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global page;
global img;
global bin;
global slect_inx;
global slect_his;
if ~exist('page','var') 
    page=1;
else
    if page~=(length(img(:,:,:,:))-mod(length(img(:,:,:,:)),10))/10+1
        page=page+1;
        inx=1;
        if (page-1)*10+10>length(img(:,:,:,:))
            for i=(page-1)*10+1:(page-1)*10+10
                eval(['axes(handles.axes' num2str(inx) ');']);
                if i<=length(img(:,:,:,:))
                    set(eval(['handles.text' num2str(inx+4)]),'String',[num2str(slect_inx(i)) '']);
                    set(eval(['handles.edit' num2str(inx+1)]),'String',[num2str(slect_his(i)/sum(bin)) '']);
                    imshow(uint8(img(:,:,:,slect_inx(i))));
                else
                    set(eval(['handles.text' num2str(inx+4)]),'String',['1' '']);
                    set(eval(['handles.edit' num2str(inx+1)]),'String',['nan' '']);
                    imshow(uint8(zeros(10,10,3)+255));
                end
                inx=inx+1;
            end
        else
            for i=(page-1)*10+1:(page-1)*10+10
                eval(['axes(handles.axes' num2str(inx) ');']);
                set(eval(['handles.text' num2str(inx+4)]),'String',[num2str(slect_inx(i)) '']);
                set(eval(['handles.edit' num2str(inx+1)]),'String',[num2str(slect_his(i)/sum(bin)) '']);
                imshow(uint8(img(:,:,:,slect_inx(i))));
                inx=inx+1;
            end
        end
    end
end
set(handles.edit1,'String',[num2str(page) '/' num2str((length(img(:,:,:,:))-mod(length(img(:,:,:,:)),10))/10+1)]);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
global cols;
cols_str = get(handles.edit13,'String');
cols = str2double(cols_str);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
global rows;
rows_str = get(handles.edit14,'String');
rows = str2double(rows_str);

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode;
global rows;
global cols;
global bin;
global query_img;
global ori_img;
if isempty(mode)
    mode = 'histogram';
end
if isempty(rows) 
    rows=240;
end
if isempty(cols) 
    cols=320;
end
query_img = imresize(ori_img,[rows cols]);
gray_query = rgb2gray(uint8(query_img));
axes(handles.axes11);
imshow(query_img)
axes(handles.axes12);
histogram(fix(gray_query/16)+1)
bin = hist(gray_query(:),0:16:255);
set(handles.edit13,'String',num2str(cols));
set(handles.edit14,'String',num2str(rows));
set(handles.text24,'String',mode);



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
global find_inx;
inx = get(handles.edit15,'String');
find_inx = str2double(inx);


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global find_inx;
global img;
global slect_inx;
global slect_his;
if find_inx<=length(slect_inx)
    set(handles.text22,'String',[num2str(slect_inx(find_inx)) '']);
    set(handles.edit16,'String',[num2str(slect_his(find_inx)) '']);
    axes(handles.axes13);
    imshow(uint8(img(:,:,:,slect_inx(find_inx))));
else
    set(handles.text22,'String',['1' '']);
    set(handles.edit16,'String',['nan' '']);
    axes(handles.axes13);
    imshow(uint8(zeros(10,10,3)+255));
end




function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
global mode;
mode = 'histogram';
set(handles.text24,'String',mode);
% set(handles.radiobutton1,'value',1);
% set(handles.radiobutton2,'value',0);
% set(handles.radiobutton3,'value',0);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
global mode;
mode = 'Vgg Net';
set(handles.text24,'String',mode);
% set(handles.radiobutton1,'value',0);
% set(handles.radiobutton2,'value',1);
% set(handles.radiobutton3,'value',0);


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
global mode;
mode = 'other';
set(handles.text24,'String',mode);
% set(handles.radiobutton1,'value',0);
% set(handles.radiobutton2,'value',0);
% set(handles.radiobutton3,'value',1);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
global mode;
mode = 'HSV';
set(handles.text24,'String',mode);



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double
global m;
global change_mn;
cols_str = get(handles.edit17,'String');
if str2double(cols_str)==m
    change_mn=0;
else
    change_mn=1;
end
m = str2double(cols_str);




% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double
global n;
global change_mn;
cols_str = get(handles.edit18,'String');
if str2double(cols_str)==n
    change_mn=0;
else
    change_mn=1;
end
n = str2double(cols_str);


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode;
mode = 'AutoEncoder';
set(handles.text24,'String',mode);
% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode;
mode = 'Color-correloggram';
set(handles.text24,'String',mode);
% Hint: get(hObject,'Value') returns toggle state of radiobutton6



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double
global k;
global change_k;
ker = get(handles.edit18,'String');
if str2double(ker)==k
    change_k=0;
else
    change_k=1;
end
k = str2double(ker);



% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode;
mode = 'LBP Features';
set(handles.text24,'String',mode);
% Hint: get(hObject,'Value') returns toggle state of radiobutton7



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c_x;
cols_str = get(handles.edit20,'String');
c_x = str2double(cols_str);
% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c_y;
cols_str = get(handles.edit21,'String');
c_y = str2double(cols_str);
% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
