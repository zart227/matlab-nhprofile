function varargout = nhprofile(varargin)
% NHPROFILE MATLAB code for nhprofile.fig
%      NHPROFILE, by itself, creates a new NHPROFILE or raises the existing
%      singleton*.
%
%      H = NHPROFILE returns the handle to a new NHPROFILE or the handle to
%      the existing singleton*.
%
%      NHPROFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NHPROFILE.M with the given input arguments.
%
%      NHPROFILE('Property','Value',...) creates a new NHPROFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nhprofile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nhprofile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nhprofile

% Last Modified by GUIDE v2.5 16-Jun-2017 11:22:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @nhprofile_OpeningFcn, ...
    'gui_OutputFcn',  @nhprofile_OutputFcn, ...
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


% --- Executes just before nhprofile is made visible.
function nhprofile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nhprofile (see VARARGIN)
clc
% Choose default command line output for nhprofile
handles.output = hObject;
handles.nhplot=[];
handles.hour=0;
handles.minute=0;
handles.day=0;
handles.mouth=0;
load('Nhprofile2')
handles.c=c;
handles.i=1;
handles.fh=cell(1,2);
handles.CurrentFile='';

handles.ReadDir='';
handles.WorkDir='';
guidata(hObject, handles);
% Update handles structure
initvars(hObject)
handles=guidata(hObject);
guidata(hObject, handles);



% UIWAIT makes nhprofile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nhprofile_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function openDir_Callback(hObject, eventdata, handles)
% hObject    handle to openDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
initvars(hObject)
handles=guidata(hObject);
guidata(hObject, handles);
dir='Febr\';
try
    handles.ReadDir = uigetdir(dir,'Извольте выбрать каталог с желанными ионограммами');
catch e
    fprinft(e);
end
if handles.ReadDir==0, return, end
handles.i=1;
c=strsplit(handles.ReadDir,'\');
handles.ReadDir=[c{end-1} '\' c{end} '\'];
handles.WorkDir=['TempDir\',c{end},'\'];
guidata(hObject, handles);
showIonogramm(hObject)
handles=guidata(hObject);
handles.checkbox1.Enable='on';
handles.htxt.Enable='on';
handles.mtxt.Enable='on';
handles.selBtn.Enable='on';
% handles.slider1.Enable='on';
handles.iga.Visible='on';
guidata(hObject, handles);
if ~exist(handles.WorkDir,'dir')
    [IOresult,message,messageid]= mkdir(handles.WorkDir);
    if IOresult == 0,   disp(message); end;
end
[IOresult,message,messageid]= mkdir('Nhprofile');
if IOresult == 0,   disp(message); end;

% --------------------------------------------------------------------
function loadSesion_Callback(hObject, eventdata, handles)
% hObject    handle to loadSesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('save','i','WorkDir','ReadDir');
handles.WorkDir=WorkDir;
handles.ReadDir=ReadDir;
handles.i=i;
guidata(hObject, handles);
showIonogramm(hObject)
handles=guidata(hObject);
handles.checkbox1.Enable='on';
handles.htxt.Enable='on';
handles.mtxt.Enable='on';
handles.selBtn.Enable='on';
if ~isvalid(hObject), return, end
guidata(hObject, handles);



function  im_ButtonDownFcn(hObject, eventdata, handles)
ca=gca;
cp=ca.CurrentPoint;
xi=cp(1,1);
yi=cp(1,2);
btn=eventdata.Button;
key=handles.figure1.SelectionType;
% k=handles.k;
% n=handles.n;
if btn==1,
    hold(handles.iga,'on')
    set(gcf,'WindowButtonMotionFcn',@MouseMoving)
    set(gcf,'WindowButtonUpFcn',@ButtonUp)
elseif btn==3
%     k=k+1;
    if ~isempty(handles.fh{1})
        if xi<=handles.fh{1}(end),xi=handles.fh{1}(end)+.01; end
%         if xi<=handles.fv(end),xi=handles.fv(end)+.01; end
    end
%     handles.hndl(end+1)=plot(xi,yi,'rs','MarkerFaceColor',[1 1 1]); % метится квадратом
    maxy=handles.iga.YLim(2);
    handles.hndl(end+1)=line([xi, xi],[0,maxy],'LineWidth',1,'color', [0,0,0]);
%     handles.hndl(end+1)=text(xi-.045,yi+9,num2str(handles.Ntrace), 'color', [1,1,1],'FontSize', 15);   % и номером следа
    handles.fh{1}(end+1)=xi+0.05;
    handles.fh{2}(end+1)=0;
    if isequal(key, 'alt')
        handles.fh{1}(end)=0;
    end
%     handles.fv(end+1)=xi+0.05;
%     handles.ht(end+1)=0;
    handles.Ntrace=handles.Ntrace+1;
    guidata(hObject, handles);
elseif btn==2
    %     handles.hndl(end+1)=plot(xi,yi,'r>','MarkerFaceColor',[1 1 1]);
    guidata(hObject, handles);
    f(hObject)
    handles=guidata(hObject);
    hold(handles.iga,'off')
end
% handles.k=k;
% hold off
guidata(hObject, handles);

function MouseMoving(hObject, eventdata)
% Подфункция для события WindowButtonMotionFcn
% получаем координаты текущей точки осей
handles=guidata(hObject);
C = get(gca, 'CurrentPoint');
x = C(1,1);
y = C(1,2);
% получаем пределы осей
xlim = get(gca, 'XLim');
ylim = get(gca, 'YLim');
% в inaxes 1, если не вышли за оси, иначе - 0
inaxes = xlim(1)< x  & xlim(2) > x & ...
    ylim(1)< y  & ylim(2) > y;
key=get(hObject, 'SelectionType'); 
if inaxes
    % если находимся в пределах осей,
    % то изменяем координаты маркера
%     handles.k=handles.k+1;
    
        
    if ~isempty(handles.fh{1})
        if x<=abs(handles.fh{1}(end))+0.01,x=abs(handles.fh{1}(end))+.007; end
        if y<=abs(handles.fh{2}(end))+0.01,y=abs(handles.fh{2}(end))+.1; end

%         if x<=abs(handles.fv(end))+0.01,x=abs(handles.fv(end))+.01; end
%         if y<=abs(handles.ht(end))+0.01,y=abs(handles.ht(end))+.1; end
    end
    if isequal(key, 'alt')
        handles.fh{1}(end+1)=-x;
        handles.fh{2}(end+1)=-y;
%         handles.fv(end+1)=-x;
%         handles.ht(end+1)=-y; 
    else
        handles.fh{1}(end+1)=x;
        handles.fh{2}(end+1)=y;
%         handles.fv(end+1)=x;
%         handles.ht(end+1)=y;
    end
    handles.hndl(end+1)=line(x,y,'Marker','o','MarkerSize',6,'MarkerFaceColor', 'r');
end
guidata(hObject, handles);


function ButtonUp(hObject, eventdata, handles)
% Подфункция для события WindowButtonUpFcn
% Когда отпустили кнопку мыши, графическое окно должно перестать
% реагировать на движение мыши
set(gcf,'WindowButtonMotionFcn', '')
set(gcf,'WindowButtonUpFcn', '')

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% double(eventdata.Character)
if eventdata.Character==32
    f(hObject);
end
if eventdata.Character==28
    handles.i=handles.i-1;
    guidata(hObject, handles);
showIonogramm(hObject);
end
if eventdata.Character==29
    handles.i=handles.i+1;
    guidata(hObject, handles);
showIonogramm(hObject)

end
if eventdata.Character==18
    delhandles(hObject)
    handles.im.HitTest='on';
end
if eventdata.Character==26
    if ~isempty(handles.hndl)
        delete(handles.hndl(end))
        handles.hndl(end)=[];
        handles.fh=cellfun(@(x) x(1:end-1),handles.fh,'UniformOutput', false);
        guidata(hObject, handles);
    end
end
handles=guidata(hObject);
guidata(hObject, handles);

% --- Executes on button press in prevBtn.
function prevBtn_Callback(hObject, eventdata, handles)
% hObject    handle to prevBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.i=handles.i-1;
guidata(hObject, handles);
showIonogramm(hObject)
handles=guidata(hObject);
guidata(hObject, handles);


% --- Executes on button press in nextBtn.
function nextBtn_Callback(hObject, eventdata, handles)
% hObject    handle to nextBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.i=handles.i+1;
guidata(hObject, handles);
showIonogramm(hObject)
handles=guidata(hObject);
guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1
c=handles.c;
% hold(handles.nha,'on')
if ischecked(hObject)
    hold(handles.nha,'on')
    f=0;
    date=handles.CurrentFile(end-11:end-8);
    z=finddate(c(:,1),date);
    d=cell(length(z),2);
%         hold on
%         k=1;
        delete(handles.nhplot);
    for i=1:length(z)
        h=c{z(i)}(5:6);
        m=c{z(i)}(7:8);
        [fv, ht]=c{z(i),2:3};
        fv2=fv+f;
        d(i,1)={[h ':' m]};
        plot(handles.nha,fv2,ht,'k');
        f=f+.5;
        d(i,2)={f};
    end
    xmin=handles.nha.XLim(1);
    xmax=handles.nha.XLim(2);
    handles.nha.XTick=[];
    handles.nha.XTickLabel=cell(fix(length(z)/4),1);
    n=32;
    i=1:length(z)/n;
    handles.nha.XTick(i)=cell2mat(d(i*n,2));
    handles.nha.XTickLabel(i)=d(i*n-1,1);
%     hold off
    handles.slider1.Enable='on';
    handles.slider1.Min=xmin+0.5;
    handles.slider1.Value=xmin+0.5;
    if xmax>24
        handles.slider1.Max=xmax-40;
        handles.nha.XLim=[xmin+0.5 xmin+120];
        handles.nha.YLim=[100 500];
    else
        handles.slider1.Max=xmax;
        handles.nha.XLim(1)=xmin+0.5;
    end
    xlabel(handles.nha,'time');
else
    hold(handles.nha,'off')
    handles=guidata(hObject);
    fln=handles.CurrentFile(end-11:end);
    r=finddate(c(:,1),fln(1:end-4));
    if ~isempty(r)
        
        guidata(hObject, handles);
        showprofile(hObject,c(r,2:3));
        handles=guidata(hObject);
    end
    handles.slider1.Enable='off';
end
guidata(hObject, handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v=handles.slider1.Value;
if ischecked(hObject)
    handles.nha.XLim=[v v+120];
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function showIonogramm(hObject)
check(hObject)
delhandles(hObject)
handles=guidata(hObject);
[handles.CurrentFile, ~] = openIonogramm (handles.ReadDir, handles.WorkDir, handles.i);
[handles.ff, handles.hh, CData, ~] = readIonogramm(handles.CurrentFile);
handles.im=imagesc(handles.iga,handles.ff,handles.hh,CData);
handles.iga.YDir='normal';
xlabel(handles.iga,'MHz');
ylabel(handles.iga,'km');
h=handles.CurrentFile(end-7:end-6);
m=handles.CurrentFile(end-5:end-4);
handles.htxt.String=h;
handles.mtxt.String=m;
handles.hour=(h);
handles.minute=(m);
fln=handles.CurrentFile(end-11:end);
SoundDate=[fln(1:2) '.' fln(3:4) '.20' fln(11:12)];
title(handles.iga,['date= ' SoundDate '   time=' h ':' m]);
if ~ischecked(hObject)
    r=finddate(handles.c(:,1),fln(1:end-4));
    
    if ~isempty(r)
        guidata(hObject, handles);
        showprofile(hObject,handles.c(r,2:3));
        handles=guidata(hObject);
    end
end
guidata(hObject, handles);
handles.im.ButtonDownFcn=@(hObject,eventdata)nhprofile('im_ButtonDownFcn',hObject,eventdata,guidata(hObject));
guidata(hObject, handles);

function f(hObject)
handles=guidata(hObject);
%     handles.hndl(end+1)=plot(xi,yi,'r>','MarkerFaceColor',[1 1 1]);
persistent fb dip amode start valley list n QQ
if isempty(fb)
    fb=1.3;dip=62.7;amode=89;start=-1;valley=0;list=0; n=399; QQ=zeros(1,100);
end
fh=handles.fh;
if ~isempty(fh{1})
    disp([handles.hour ':' handles.minute]);
    [fh1, fh2]=cf(fh,n);
    [n1,fh1{1:2},~]=polan(n,fh1{1:2},QQ,fb,dip,start,amode,valley,list,1);
    if fh2{1}(1)~=0
        [n2,fh2{1:2},~]=polan(n,fh2{1:2},QQ,fb,dip,start,amode,valley,list,1);
    end
    if fh2{1}(1)~=0
        fh=cf(fh1,fh2,n1,n2);
       [fh1,fh2]=cf(fh1,fh2,n1,n2);
    else
        fh=cf(fh1,n1);
    end
    
    if ~ischecked(hObject)
        showprofile(hObject,fh);
    end
    name=handles.CurrentFile(end-11:end-4);
    r=finddate(handles.c(:,1),name);
    if ~isempty(r)
%         handles.c(r,1)={name};
        handles.c(r,2:3)=fh;
    else
        d=find(cellfun(@(x) str2double(name)-str2double(x)>0,handles.c(:,1)));
        d=d(end);
        m=cell(1,3);
        m(1)={name};
        m(2:3)=fh;
        m=cat(1,handles.c(1:d,:),m,handles.c(d+1:end,:));
        handles.c=m;
    end
    handles.fh=fh;
    c=handles.c;
    save('Nhprofile2','c');
end
% handles.n=n;
% handles.k=0;
handles.i=handles.i+1;
guidata(hObject, handles);
showIonogramm(hObject)
handles=guidata(hObject);
WorkDir=handles.WorkDir;
ReadDir=handles.ReadDir;
i=handles.i;
save('save.mat','i','WorkDir','ReadDir');
guidata(hObject, handles);


function showprofile(hObject,c)
handles=guidata(hObject);
fln=handles.CurrentFile(end-11:end);
% [fv, ht]=c{1:2};
handles.nhplot=plot(handles.nha,c{1:2},'r');
% fln=handles.CurrentFileName;
SoundDate=[fln(1:2) '.' fln(3:4) '.20' fln(11:12)];
SoundTime=[fln(5:6) ':' fln(7:8)];
title(handles.nha,['date= ' SoundDate '   time=' SoundTime]);
xlabel(handles.nha,'MHz');
ylabel(handles.nha,'km');
if strcmp(handles.nha.Visible,'off')
    handles.nha.Visible='on';
end
guidata(hObject, handles);

function check(hObject)
handles=guidata(hObject);
d=cellstr(ls(handles.ReadDir));
if handles.i<=1
    handles.prevBtn.Enable='off';
    handles.i=1;
else
    handles.prevBtn.Enable='on';
end
if handles.i>=numel(d)-2
    handles.i=numel(d)-2;
    handles.nextBtn.Enable='off';
else
    handles.nextBtn.Enable='on';
end
guidata(hObject, handles);

function i=ischecked(hObject)
handles=guidata(hObject);
i=handles.checkbox1.Value;

function initvars(hObject)
handles=guidata(hObject);
% handles.n=399;
% n=handles.n;
handles.fh{1}=[];
handles.fh{2}=[];
% handles.fv=[];
% handles.ht=[];
% handles.k=0;
handles.Ntrace=1;
handles.hndl=[];
guidata(hObject,handles);

function delhandles(hObject)
handles=guidata(hObject);
for i=1:length(handles.hndl);
    delete(handles.hndl(i));
end
guidata(hObject,handles)
initvars(hObject)
handles=guidata(hObject);
guidata(hObject,handles)



function htxt_Callback(hObject, eventdata, handles)
% hObject    handle to htxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of htxt as text
%        str2double(get(hObject,'String')) returns contents of htxt as a double
r=1;



% --- Executes during object creation, after setting all properties.
function htxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to htxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mtxt_Callback(hObject, eventdata, handles)
% hObject    handle to mtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mtxt as text
%        str2double(get(hObject,'String')) returns contents of mtxt as a double
r=1;

% --- Executes during object creation, after setting all properties.
function mtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selBtn.
function selBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=handles.htxt.String;
str(str>'9'|str<'0')=[];
if str2double(str)>23, str='23'; end
n=numel(str);
if n>2,str(1:n-2)=[];end
if n==1, str=['0' str]; end
handles.htxt.String=str;
str=handles.mtxt.String;
str(str>'9'|str<'0')=[];
if str2double(str)>59, str='59'; end
n=numel(str);
if n==1, str=['0' str]; end
handles.mtxt.String=str;
guidata(hObject, handles);
h=handles.htxt.String;
m=handles.mtxt.String;
d=ls(handles.ReadDir);
d=cellstr(d(3:end,:));
handles.i=finddate(d,[h m]);
guidata(hObject, handles);
showIonogramm(hObject)
handles=guidata(hObject);
guidata(hObject, handles);



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=handles.htxt.String;
str(str>'9'|str<'0')=[];
if str2double(str)>23, str='23'; end
handles.htxt.String=str;
str=handles.mtxt.String;
str(str>'9'|str<'0')=[];
if str2double(str)>59, str='59'; end
handles.mtxt.String=str;
guidata(hObject, handles);





% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str1=handles.htxt.String;
str1(str1>'9'|str1<'0')=[];
if str2double(str1)>23, str1='23'; end
handles.htxt.String=str1;
str1=handles.mtxt.String;
str1(str1>'9'|str1<'0')=[];
if str2double(str1)>59, str1='59'; end
handles.mtxt.String=str1;
guidata(hObject, handles);


% --- Executes on key press with focus on htxt and none of its controls.
function htxt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to htxt (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject,'String');
str(str>'9'|str<'0')=[];
if str2double(str)>23, str='23'; end
set(hObject,'String',str)
guidata(hObject, handles);


% --- Executes on key press with focus on mtxt and none of its controls.
function mtxt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to mtxt (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject,'String');
str(str>'9'|str<'0')=[];
if str2double(str)>59, str='59'; end
set(hObject,'String',str)
guidata(hObject, handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

function [c1,c2]=cf(c,n,n1,n2)

if nargin==2
    if nargout==1
        [c1]=cellfun(@(x) x(1:n),c,'UniformOutput', false);
        
    else
        c1=cellfun(@(x) x(x>=0),c,'UniformOutput', false);
        c2=cellfun(@(x) -x(x<0),c,'UniformOutput', false);
        c1=cellfun(@(x) [x zeros(1,n-numel(x))],c1,'UniformOutput', false);
        c2=cellfun(@(x) [x zeros(1,n-numel(x))],c2,'UniformOutput', false);
    end
elseif nargin==4
    
    [c1]=cellfun(@(x) x(1:n1),c,'UniformOutput', false);
    [c2]=cellfun(@(x) x(1:n2),n,'UniformOutput', false);
    if nargout==1
        c1=cellfun(@(x,y) [x y], c1, c2,'UniformOutput', false);
    end
end

