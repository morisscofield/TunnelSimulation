%--------------------------------------------------------------------------
function varargout = simulateTunnel(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulateTunnel_OpeningFcn, ...
                   'gui_OutputFcn',  @simulateTunnel_OutputFcn, ...
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
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function CloseRequestFcn_Callback(hObject, eventdata, handles)
if (ishandle(2))
  close(2);
end
if (ishandle(3))
  close(3);
end
if (ishandle(4))
  close(4);
end

closereq

%--------------------------------------------------------------------------
function simulateTunnel_OpeningFcn(hObject, eventdata, handles, varargin)


handles.output = hObject;

installDir = getenv('TUNNELROOT');
if (isempty(installDir))
  uiwait(warndlg('The environment variable TUNNELROOT has not been set', 'Installation error'));
else
  if (installDir(end) ~= '\')
    installDir(end+1) = '\';
  end
  handles.userdata.installDir = installDir;
end

fileName = [handles.userdata.installDir, 'config.txt'];
handles.userdata.configFileName = fileName;

hFile = fopen (fileName, 'rt');
if (hFile == -1)
  handles = SetDefaultParamters (handles);
  WriteConfigFile (handles);
else
  handles = ReadConfigFile (handles);
end

handles = SetInitialSliderPositions (handles);
%set (handles.SimulatePB, 'enable', 'off');

set(0,'units','normalized');

set (handles.SimulateTunnelWindow, 'units', 'normalized');
pos = get (handles.SimulateTunnelWindow, 'position');
pos(1) = 0;
pos(2) = 1-pos(4);
set (handles.SimulateTunnelWindow, 'position', pos);
set (handles.SimulateTunnelWindow, 'units', 'normalized');
set (handles.SimulatePB, 'enable', 'off');

set (handles.LowestMModesST, 'string', '1');
set (handles.HighestMModesST, 'string', '201');
set (handles.LowestNModesST, 'string', '1');
set (handles.HighestNModesST, 'string', '201');


hMainWindow = findobj ('name', 'Simulate Tunnel Communications');
myPos = get (hMainWindow, 'position');

h = figure(2); 
set (h, 'units', 'normalized');
figPos = get(h, 'outerposition');
set(h, 'position', [myPos(3)+0.03   figPos(2)    0.2917    0.3889]);


guidata(hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function varargout = simulateTunnel_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

  %--------------------------------------------------------------------------
  %Edit boxes
  %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function WidthMaxEB_Callback(hObject, eventdata, handles)

maxWidth = str2num(get(hObject, 'string'));
if (maxWidth > 0)
  if (maxWidth < handles.userdata.minWidth)
    uiwait(warndlg ('Max less than min width', 'User problem'));
    set(hObject, 'string', handles.userdata.maxWidth);
    return;
  end
    
  handles.userdata.maxWidth = maxWidth;
  val = get (handles.TunnelWidthSL, 'value');
  if (val > maxWidth)
    set (handles.TunnelWidthSL, 'value', maxWidth);
    set (handles.TunnelWidthST, 'string', maxWidth);
    handles.userdata.width = maxWidth;
  end
  set (handles.TunnelWidthSL, 'max', maxWidth);

  width = get (handles.TunnelWidthSL, 'value');
  txLRPercent = get (handles.TxLeftRightSL, 'value');
  handles.userdata.x0 = width*(txLRPercent/100 - 0.5);
  rxLRPercent = get (handles.RxLeftRightSL, 'value');
  handles.userdata.x = width*(rxLRPercent/100 - 0.5);

else
  set(hObject, 'string', handles.userdata.maxWidth);
  uiwait(warndlg ('Problem with max width entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > maxWidth)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function WidthMinEB_Callback(hObject, eventdata, handles)

minWidth = str2num(get(hObject, 'string'));
if (minWidth > 0)
  if (minWidth > handles.userdata.maxWidth)
    uiwait(warndlg ('Min greater than max width', 'User problem'));
    set(hObject, 'string', handles.userdata.minWidth);
    return;
  end
    
  handles.userdata.minWidth = minWidth;
  val = get (handles.TunnelWidthSL, 'value');
  if (val < minWidth)
    set (handles.TunnelWidthSL, 'value', minWidth);
    set (handles.TunnelWidthST, 'string', minWidth);
    handles.userdata.width = minWidth;
  end
  set (handles.TunnelWidthSL, 'min', minWidth);
  
  width = get (handles.TunnelWidthSL, 'value');
  txLRPercent = get (handles.TxLeftRightSL, 'value');
  handles.userdata.x0 = width*(txLRPercent/100 - 0.5);
  rxLRPercent = get (handles.RxLeftRightSL, 'value');
  handles.userdata.x = width*(rxLRPercent/100 - 0.5);
  
else
  set(hObject, 'string', handles.userdata.minWidth);
  uiwait(warndlg ('Problem with min width entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < minWidth)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function HeightMaxEB_Callback(hObject, eventdata, handles)

maxHeight = str2num(get(hObject, 'string'));
if (maxHeight > 0)
  if (maxHeight < handles.userdata.minHeight)
    uiwait(warndlg ('Max less than min height', 'User problem'));
    set(hObject, 'string', handles.userdata.maxHeight);
    return;
  end
    
  handles.userdata.maxHeight = maxHeight;
  val = get (handles.TunnelHeightSL, 'value');
  if (val > maxHeight)
    set (handles.TunnelHeightSL, 'value', maxHeight);
    set (handles.TunnelHeightST, 'string', maxHeight);
    handles.userdata.height = maxHeight;
  end
  set (handles.TunnelHeightSL, 'max', maxHeight);
  
  height = get (handles.TunnelHeightSL, 'value');
  txHPercent = get (handles.TxUpDownSL, 'value');
  handles.userdata.y0 = height*(txHPercent/100 - 0.5);
  rxLRPercent = get (handles.RxUpDownSL, 'value');
  handles.userdata.y = height*(rxLRPercent/100 - 0.5);
  
else
  set(hObject, 'string', handles.userdata.maxHeight);
  uiwait(warndlg ('Problem with max height entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > maxHeight)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function HeightMinEB_Callback(hObject, eventdata, handles)

minHeight = str2num(get(hObject, 'string'));
if (minHeight > 0)
  if (minHeight > handles.userdata.maxHeight)
    uiwait(warndlg ('Min greater than max height', 'User problem'));
    set(hObject, 'string', handles.userdata.minHeight);
    return;
  end
    
  handles.userdata.minHeight = minHeight;
  val = get (handles.TunnelHeightSL, 'value');
  if (val < minHeight)
    set (handles.TunnelHeightSL, 'value', minHeight);
    set (handles.TunnelHeightST, 'string', minHeight);
    handles.userdata.height = minHeight;
  end
  set (handles.TunnelHeightSL, 'min', minHeight);

  height = get (handles.TunnelHeightSL, 'value');
  txHPercent = get (handles.TxUpDownSL, 'value');
  handles.userdata.y0 = height*(txHPercent/100 - 0.5);
  rxLRPercent = get (handles.RxUpDownSL, 'value');
  handles.userdata.y = height*(rxLRPercent/100 - 0.5);
  
else
  set(hObject, 'string', handles.userdata.minHeight);
  uiwait(warndlg ('Problem with min height entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < minHeight)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function ConductivityMaxEB_Callback(hObject, eventdata, handles)
conductivity = str2num(get(hObject, 'string'));
if (conductivity > 0)
  if (conductivity < handles.userdata.minConductivity)
    uiwait(warndlg ('Max less than min conductivity', 'User problem'));
    set(hObject, 'string', handles.userdata.maxConductivity);
    return;
  end
    
  handles.userdata.maxConductivity = conductivity;
  val = get (handles.ConductivitySL, 'value');
  if (val > conductivity)
    set (handles.ConductivitySL, 'value', conductivity);
    set (handles.ConductivityST, 'string', conductivity);
    handles.userdata.conductivity = conductivity;
  end
  set (handles.ConductivitySL, 'max', conductivity);
else
  set(hObject, 'string', handles.userdata.maxConductivity);
  uiwait(warndlg ('Problem with max conductivity entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > conductivity)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function ConductivityMinEB_Callback(hObject, eventdata, handles)

conductivity = str2num(get(hObject, 'string'));
if (conductivity > 0)
  if (conductivity > handles.userdata.maxConductivity)
    uiwait(warndlg ('Min greater than max conductivity', 'User problem'));
    set(hObject, 'string', handles.userdata.minConductivity);
    return;
  end
    
  handles.userdata.minConductivity = conductivity;
  val = get (handles.ConductivitySL, 'value');
  if (val < conductivity)
    set (handles.ConductivitySL, 'value', conductivity);
    set (handles.ConductivityST, 'string', conductivity);
    handles.userdata.conductivity = conductivity;
  end
  set (handles.ConductivitySL, 'min', conductivity);
else
  set(hObject, 'string', handles.userdata.minConductivity);
  uiwait(warndlg ('Problem with min conductivity entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < conductivity)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function RoofPermMaxEB_Callback(hObject, eventdata, handles)

roofPerm = str2num(get(hObject, 'string'));
if (roofPerm > 0)
  if (roofPerm < handles.userdata.minErH)
    uiwait(warndlg ('Max less than min roofPerm', 'User problem'));
    set(hObject, 'string', handles.userdata.maxErH);
    return;
  end
    
  handles.userdata.maxErH = roofPerm;
  val = get (handles.RoofPermSL, 'value');
  if (val > roofPerm)
    set (handles.RoofPermSL, 'value', roofPerm);
    set (handles.RoofPermST, 'string', roofPerm);
    handles.userdata.erH = roofPerm;
  end
  set (handles.RoofPermSL, 'max', roofPerm);
else
  set(hObject, 'string', handles.userdata.maxErH);
  uiwait(warndlg ('Problem with max roof permittivity entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > roofPerm)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function RoofPermMinEB_Callback(hObject, eventdata, handles)

roofPerm = str2num(get(hObject, 'string'));
if (roofPerm > 0)
  if (roofPerm > handles.userdata.maxErH)
    uiwait(warndlg ('Min greater than max roofPerm', 'User problem'));
    set(hObject, 'string', handles.userdata.erH);
    return;
  end
    
  handles.userdata.minErH = roofPerm;
  val = get (handles.RoofPermSL, 'value');
  if (val < roofPerm)
    set (handles.RoofPermSL, 'value', roofPerm);
    set (handles.RoofPermST, 'string', roofPerm);
    handles.userdata.erH = roofPerm;
  end
  set (handles.RoofPermSL, 'min', roofPerm);
else
  set(hObject, 'string', handles.userdata.minErH);
  uiwait(warndlg ('Problem with min roof permittivity entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < roofPerm)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function WallPermMaxEB_Callback(hObject, eventdata, handles)

wallPerm = str2num(get(hObject, 'string'));
if (wallPerm > 0)
  if (wallPerm < handles.userdata.minErV)
    uiwait(warndlg ('Max less than min wallPerm', 'User problem'));
    set(hObject, 'string', handles.userdata.maxErV);
    return;
  end
    
  handles.userdata.maxErV = wallPerm;
  val = get (handles.WallPermSL, 'value');
  if (val > wallPerm)
    set (handles.WallPermSL, 'value', wallPerm);
    set (handles.WallPermST, 'string', wallPerm);
    handles.userdata.erV = wallPerm;
  end
  set (handles.WallPermSL, 'max', wallPerm);
else
  set(hObject, 'string', handles.userdata.maxErV);
  uiwait(warndlg ('Problem with max wall permittivity entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > wallPerm)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function WallPermMinEB_Callback(hObject, eventdata, handles)

wallPerm = str2num(get(hObject, 'string'));
if (wallPerm > 0)
  if (wallPerm > handles.userdata.maxErV)
    uiwait(warndlg ('Min greater than max wall permittivity', 'User problem'));
    set(hObject, 'string', handles.userdata.minErV);
    return;
  end
    
  handles.userdata.minErV = wallPerm;
  val = get (handles.WallPermSL, 'value');
  if (val < wallPerm)
    set (handles.WallPermSL, 'value', wallPerm);
    set (handles.WallPermST, 'string', wallPerm);
    handles.userdata.ErV = wallPerm;
  end
  set (handles.WallPermSL, 'min', wallPerm);
else
  set(hObject, 'string', handles.userdata.minErV);
  uiwait(warndlg ('Problem with min wall permittivity entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < wallPerm)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function RoughnessMaxEB_Callback(hObject, eventdata, handles)

roughness = str2num(get(hObject, 'string'));
if (roughness > 0)
  if (roughness < handles.userdata.minRoughness)
    uiwait(warndlg ('Max less than min roughness', 'User problem'));
    set(hObject, 'string', handles.userdata.maxRoughness);
    return;
  end
    
  handles.userdata.maxRoughness = roughness;
  val = get (handles.RoughnessSL, 'value');
  if (val > roughness)
    set (handles.RoughnessSL, 'value', roughness);
    set (handles.RoughnessST, 'string', roughness);
    handles.userdata.roughness = roughness;
  end
  set (handles.RoughnessSL, 'max', roughness);
else
  set(hObject, 'string', handles.userdata.maxRoughness);
  uiwait(warndlg ('Problem with max roughness entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > roughness)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function RoughnessMinEB_Callback(hObject, eventdata, handles)

roughness = str2num(get(hObject, 'string'));
if (roughness > 0)
  if (roughness > handles.userdata.maxRoughness)
    uiwait(warndlg ('Min greater than max roughness', 'User problem'));
    set(hObject, 'string', handles.userdata.minRoughness);
    return;
  end
    
  handles.userdata.minRoughness = roughness;
  val = get (handles.RoughnessSL, 'value');
  if (val < roughness)
    set (handles.RoughnessSL, 'value', roughness);
    set (handles.RoughnessST, 'string', roughness);
    handles.userdata.roughness = roughness;
  end
  set (handles.RoughnessSL, 'min', roughness);
else
  set(hObject, 'string', handles.userdata.minRoughness);
  uiwait(warndlg ('Problem with min roughness entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < roughness)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function WallTiltMaxEB_Callback(hObject, eventdata, handles)
tilt = str2num(get(hObject, 'string'));
if (tilt > 0)
  if (tilt < handles.userdata.minTilt)
    uiwait(warndlg ('Max less than min tilt', 'User problem'));
    set(hObject, 'string', handles.userdata.maxTilt);
    return;
  end
    
  handles.userdata.maxTilt = tilt;
  val = get (handles.WallTiltSL, 'value');
  if (val > tilt)
    set (handles.WallTiltSL, 'value', tilt);
    set (handles.WallTiltST, 'string', tilt);
    handles.userdata.tilt = tilt;
  end
  set (handles.WallTiltSL, 'max', tilt);
else
  set(hObject, 'string', handles.userdata.maxTilt);
  uiwait(warndlg ('Problem with max tilt entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > tilt)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function WallTiltMinEB_Callback(hObject, eventdata, handles)

wallTilt = str2num(get(hObject, 'string'));
if (wallTilt > 0)
  if (wallTilt > handles.userdata.maxTilt)
    uiwait(warndlg ('Min greater than max wall tilt', 'User problem'));
    set(hObject, 'string', handles.userdata.minTilt);
    return;
  end
    
  handles.userdata.minTilt = wallTilt;
  val = get (handles.WallTiltSL, 'value');
  if (val < wallTilt)
    set (handles.WallTiltSL, 'value', wallTilt);
    set (handles.WallTiltST, 'string', wallTilt);
    handles.userdata.tilt = wallTilt;
  end
  set (handles.WallTiltSL, 'min', wallTilt);
else
  set(hObject, 'string', handles.userdata.minTilt);
  uiwait(warndlg ('Problem with min wall tilt entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < wallTilt)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function FrequencyMaxEB_Callback(hObject, eventdata, handles)

frequency = str2num(get(hObject, 'string'));
if (frequency > 0)
  if (frequency < handles.userdata.minFrequency)
    uiwait(warndlg ('Max less than min frequency', 'User problem'));
    set(hObject, 'string', handles.userdata.maxFrequency);
    return;
  end;
    
  handles.userdata.maxFrequency = frequency;
  val = get (handles.FrequencySL, 'value');
  if (val > frequency)
    set (handles.FrequencySL, 'value', frequency);
    set (handles.FrequencyST, 'string', frequency);
    handles.userdata.frequency = frequency;
  end
  set (handles.FrequencySL, 'max', frequency);
else
  set(hObject, 'string', handles.userdata.maxFrequency);
  uiwait(warndlg ('Problem with max frequency entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > frequency)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function FrequencyMinEB_Callback(hObject, eventdata, handles)

frequency = str2num(get(hObject, 'string'));
if (frequency > 0)
  if (frequency > handles.userdata.maxFrequency)
    uiwait(warndlg ('Min greater than max frequency', 'User problem'));
    set(hObject, 'string', handles.userdata.minFrequency);
    return;
  end
    
  handles.userdata.minFrequency = frequency;
  val = get (handles.FrequencySL, 'value');
  if (val < frequency)
    set (handles.FrequencySL, 'value', frequency);
    set (handles.FrequencyST, 'string', frequency);
    handles.userdata.frequency = frequency;
  end
  set (handles.FrequencySL, 'min', frequency);
else
  set(hObject, 'string', handles.userdata.minFrequency);
  uiwait(warndlg ('Problem with min frequency entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < frequency)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function TxGainMaxEB_Callback(hObject, eventdata, handles)

txGain = str2num(get(hObject, 'string'));
if (txGain > 0)
  if (txGain < handles.userdata.minTxGain)
    uiwait(warndlg ('Max less than min txGain', 'User problem'));
    set(hObject, 'string', handles.userdata.maxTxGain);
    return;
  end
    
  handles.userdata.maxTxGain = txGain;
  val = get (handles.TxGainSL, 'value');
  if (val > txGain)
    set (handles.TxGainSL, 'value', txGain);
    set (handles.TxGainST, 'string', txGain);
    handles.userdata.txGain = txGain;
  end
  set (handles.TxGainSL, 'max', txGain);
else
  set(hObject, 'string', handles.userdata.maxTxGain);
  uiwait(warndlg ('Problem with max txGain entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > txGain)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function TxGainMinEB_Callback(hObject, eventdata, handles)

txGain = str2num(get(hObject, 'string'));
if (txGain > 0)
  if (txGain > handles.userdata.maxTxGain)
    uiwait(warndlg ('Min greater than max txGain', 'User problem'));
    set(hObject, 'string', handles.userdata.minTxGain);
    return;
  end
    
  handles.userdata.minTxGain = txGain;
  val = get (handles.TxGainSL, 'value');
  if (val < txGain)
    set (handles.TxGainSL, 'value', txGain);
    set (handles.TxGainST, 'string', txGain);
    handles.userdata.txGain = txGain;
  end
  set (handles.TxGainSL, 'min', txGain);
else
  set(hObject, 'string', handles.userdata.minTxGain);
  uiwait(warndlg ('Problem with min txGain entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < txGain)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function RxGainMaxEB_Callback(hObject, eventdata, handles)

rxGain = str2num(get(hObject, 'string'));
if (rxGain > 0)
  if (rxGain < handles.userdata.minRxGain)
    uiwait(warndlg ('Max less than min rxGain', 'User problem'));
    set(hObject, 'string', handles.userdata.maxRxGain);
    return;
  end
    
  handles.userdata.maxRxGain = rxGain;
  val = get (handles.RxGainSL, 'value');
  if (val > rxGain)
    set (handles.RxGainSL, 'value', rxGain);
    set (handles.RxGainST, 'string', rxGain);
    handles.userdata.rxGain = rxGain;
  end
  set (handles.RxGainSL, 'max', rxGain);
else
  set(hObject, 'string', handles.userdata.maxRxGain);
  uiwait(warndlg ('Problem with max rxGain entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > rxGain)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function RxGainMinEB_Callback(hObject, eventdata, handles)

rxGain = str2num(get(hObject, 'string'));
if (rxGain > 0)
  if (rxGain > handles.userdata.maxRxGain)
    uiwait(warndlg ('Min greater than max rxGain', 'User problem'));
    set(hObject, 'string', handles.userdata.minRxGain);
    return;
  end
    
  handles.userdata.minRxGain = rxGain;
  val = get (handles.RxGainSL, 'value');
  if (val < rxGain)
    set (handles.RxGainSL, 'value', rxGain);
    set (handles.RxGainST, 'string', rxGain);
    handles.userdata.rxGain = rxGain;
  end
  set (handles.RxGainSL, 'min', rxGain);
else
  set(hObject, 'string', handles.userdata.minRxGain);
  uiwait(warndlg ('Problem with min rxGain entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < rxGain)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function LengthMaxEB_Callback(hObject, eventdata, handles)

maxLength = str2num(get(hObject, 'string'));
if (maxLength > 0)
  if (maxLength < handles.userdata.minLength)
    uiwait(warndlg ('Max less than min length', 'User problem'));
    set(hObject, 'string', handles.userdata.maxLength);
    return;
  end
    
  handles.userdata.maxLength = maxLength;
  val = get (handles.CrossSectionSL, 'value');
  if (val > maxLength)
    set (handles.CrossSectionSL, 'value', maxLength);
    set (handles.CrossSectionPB, 'string', maxLength);
    handles.userdata.rxGain = maxLength;
  end
  set (handles.CrossSectionSL, 'max', maxLength);
else
  set(hObject, 'string', handles.userdata.maxLength);
  uiwait(warndlg ('Problem with max tunnel length entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val > maxLength)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function LengthMinEB_Callback(hObject, eventdata, handles)

minLength = str2num(get(hObject, 'string'));
if (minLength > 0)
  if (minLength > handles.userdata.maxLength)
    uiwait(warndlg ('Min greater than max tunnel length', 'User problem'));
    set(hObject, 'string', handles.userdata.minLength);
    return;
  end
    
  handles.userdata.minLength = minLength;
  val = get (handles.CrossSectionSL, 'value');
  if (val < minLength)
    set (handles.CrossSectionSL, 'value', minLength);
    set (handles.CrossSectionPB, 'string', minLength);
    handles.userdata.minLength = minLength;
  end
  set (handles.CrossSectionSL, 'min', minLength);
else
  set(hObject, 'string', handles.userdata.minLength);
  uiwait(warndlg ('Problem with min tunnel length entered', 'User problem'));
  return;
end

guidata(hObject, handles);
if (val < minLength)
  UpdateFigures (handles);
end
  
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function NoOfXPointsEB_Callback(hObject, eventdata, handles)
val = str2num(get (hObject, 'string'));
if (val > 0)
  handles.userdata.noOfXPoints = val;
else
  set (hObject, 'value', handles.userdata.noOfXPoints);
end
guidata (hObject, handles);
UpdateFigures (handles);
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function NoOfYPointsEB_Callback(hObject, eventdata, handles)
val = str2num(get (hObject, 'string'));
if (val > 0)
  handles.userdata.noOfYPoints = val;
else
  set (hObject, 'value', handles.userdata.noOfYPoints);
end
guidata (hObject, handles);
UpdateFigures (handles);
WriteConfigFile (handles);
%--------------------------------------------------------------------------
function NoOfZPointsEB_Callback(hObject, eventdata, handles)
val = str2num(get (hObject, 'string'));
if (val > 0)
  handles.userdata.noOfZPoints = val;
else
  set (hObject, 'value', handles.userdata.noOfZPoints);
end
guidata (hObject, handles);
UpdateFigures (handles);
WriteConfigFile (handles);


  %--------------------------------------------------------------------------
  %List boxes
  %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function PolarisationLB_Callback(hObject, eventdata, handles)
val = get(hObject, 'value');
handles.userdata.polarisation = val;
guidata (hObject, handles);

UpdateFigures (handles);


  %--------------------------------------------------------------------------
  %Sliders
  %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function RxLeftRightSL_Callback(hObject, eventdata, handles)
percent = get (hObject, 'value');
set (handles.RxLeftRightST, 'string', num2str(percent));

width = get (handles.TunnelWidthSL, 'value');
handles.userdata.x = width*(percent/100 - 0.5);
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function RxUpDownSL_Callback(hObject, eventdata, handles)
percent = get (hObject, 'value');
set (handles.RxUpDownST, 'string', num2str(percent));

height = get (handles.TunnelHeightSL, 'value');
handles.userdata.y = height*(percent/100 - 0.5);
guidata (hObject, handles);

UpdateFigures (handles);
%--------------------------------------------------------------------------
function TxLeftRightSL_Callback(hObject, eventdata, handles)
percent = get (hObject, 'value');
set (handles.TxLeftRightST, 'string', num2str(percent));

width = get (handles.TunnelWidthSL, 'value');
handles.userdata.x0 = width*(percent/100 - 0.5);
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function TxUpDownSL_Callback(hObject, eventdata, handles)
percent = get (hObject, 'value');
set (handles.TxUpDownST, 'string', num2str(percent));

height = get (handles.TunnelHeightSL, 'value');
handles.userdata.y0 = height*(percent/100 - 0.5);
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function CrossSectionSL_Callback(hObject, eventdata, handles)
pos = get (handles.CrossSectionSL, 'value');
set (handles.CrossSectionPB, 'string', num2str(pos));
handles.userdata.z = pos;
handles.userdata.plot2D = 1;
handles.userdata.plot3D = 0;
set (handles.SignalStrength3DPB, 'value', 0);

guidata(hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function WallTiltSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.WallTiltST, 'string', val);
handles.userdata.tilt = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function RoughnessSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.RoughnessST, 'string', val);
handles.userdata.roughness = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function WallPermSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.WallPermST, 'string', val);
handles.userdata.erV = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function RoofPermSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.RoofPermST, 'string', val);
handles.userdata.erH = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function ConductivitySL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.ConductivityST, 'string', val);
handles.userdata.conductivity = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function TunnelWidthSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.TunnelWidthST, 'string', val);
handles.userdata.width = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function TunnelHeightSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.TunnelHeightST, 'string', val);
handles.userdata.height = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function FrequencySL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.FrequencyST, 'string', val);
handles.userdata.frequency = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function RxGainSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.RxGainST, 'string', val);
handles.userdata.rxGain = val;
guidata (hObject, handles);
UpdateFigures (handles);

%--------------------------------------------------------------------------
function TxGainSL_Callback(hObject, eventdata, handles)
val = get (hObject, 'value');
set (handles.TxGainST, 'string', val);
handles.userdata.txGain = val;
guidata (hObject, handles);
UpdateFigures (handles);
%--------------------------------------------------------------------------
function NoOfReflectionsSL_Callback(hObject, eventdata, handles)
value = get (hObject, 'value');
set (handles.NoOfReflectionsST, 'string', value); 


  %--------------------------------------------------------------------------
  %Buttons
  %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function SimulatePB_Callback(hObject, eventdata, handles)
set (handles.MainSystemPanel, 'visible', 'on');
set (handles.SystemPanel, 'visible', 'on');
set (handles.SimulateTunnelPropertiesPanel, 'visible', 'on');
set (handles.TransmitterPositionPanel, 'visible', 'on');
set (handles.ReceiverPositionPanel, 'visible', 'on');
set (handles.TunnelDimensionsPanel, 'visible', 'on');
set (handles.OtherPlotsPanel, 'visible', 'on');

set (handles.MainPropertiesPanel, 'visible', 'off');
set (handles.TunnelPropertiesPanel, 'visible', 'off');
set (handles.SystemPropertiesPanel, 'visible', 'off');
set (hObject, 'enable', 'off');
set (handles.SetLimitsPB, 'enable', 'on');
%--------------------------------------------------------------------------
function SetLimitsPB_Callback(hObject, eventdata, handles)
set (handles.MainSystemPanel, 'visible', 'off');
set (handles.SystemPanel, 'visible', 'off');
set (handles.SimulateTunnelPropertiesPanel, 'visible', 'off');
set (handles.TransmitterPositionPanel, 'visible', 'off');
set (handles.ReceiverPositionPanel, 'visible', 'off');
set (handles.TunnelDimensionsPanel, 'visible', 'off');
set (handles.OtherPlotsPanel, 'visible', 'off');

set (handles.MainPropertiesPanel, 'visible', 'on');
set (handles.TunnelPropertiesPanel, 'visible', 'on');
set (handles.SystemPropertiesPanel, 'visible', 'on');
set (hObject, 'enable', 'off');
set (handles.SimulatePB, 'enable', 'on');
%--------------------------------------------------------------------------
function SignalStrength3DPB_Callback(hObject, eventdata, handles)
tick = get(hObject, 'value');
if (tick == 1)
  handles.userdata.plot3D = 1;
  handles.userdata.plot2D = 0;
else
  handles.userdata.plot3D = 0;
end
guidata (hObject, handles);
if (tick == 1)
  UpdateFigures(handles);
end
%--------------------------------------------------------------------------
function CrossSectionPB_Callback(hObject, eventdata, handles)
CrossSectionSL_Callback(hObject, eventdata, handles);


  %--------------------------------------------------------------------------
  % Create functions
  %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function TxGainSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function ConductivityMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function RoofPermMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WallPermMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function RoughnessMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WallTiltMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function FrequencyMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function TxGainMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WidthMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function RxGainMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function LengthMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function PolarisationLB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set (hObject, 'string', {'Horizontal', 'Vertical', 'Circular'});
%--------------------------------------------------------------------------
function RxLeftRightSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'Max', 2);
set (hObject, 'Min', -2);
%--------------------------------------------------------------------------
function RxUpDownSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'Max', 1);
set (hObject, 'Min', -1);
%--------------------------------------------------------------------------
function TxLeftRightSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'Max', 2);
set (hObject, 'Min', -2);
%--------------------------------------------------------------------------
function TxUpDownSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'Max', 1);
set (hObject, 'Min', -1);
%--------------------------------------------------------------------------
function CrossSectionSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'Max', 1000);
set (hObject, 'Min', 0);
%--------------------------------------------------------------------------
function FrequencyMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function TxGainMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function RxGainMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WidthMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function HeightMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function HeightMinEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function ConductivityMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function RoofPermMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WallPermMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WallTiltMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function RoughnessMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function LengthMaxEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function WallTiltSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function RoughnessSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function WallPermSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function RoofPermSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function TunnelWidthSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function TunnelHeightSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function RxGainSL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function FrequencySL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function ConductivitySL_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%--------------------------------------------------------------------------
function NoOfXPointsEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function NoOfYPointsEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function NoOfZPointsEB_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function NoOfReflectionsSL_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'sliderstep', [0.1, 0.2]);
set (hObject, 'value', 6);

  %--------------------------------------------------------------------------
  % My functions
  %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function WriteConfigFile (handles)
P

fileName = handles.userdata.configFileName;

hFile = fopen (fileName, 'wt');
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minWidth, handles.userdata.maxWidth);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minHeight, handles.userdata.maxHeight);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minLength, handles.userdata.maxLength);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minConductivity, handles.userdata.maxConductivity);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minErH, handles.userdata.maxErH);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minErV, handles.userdata.maxErV);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minRoughness, handles.userdata.maxRoughness);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minTilt, handles.userdata.maxTilt);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minFrequency, handles.userdata.maxFrequency);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minTxGain, handles.userdata.maxTxGain);
fprintf (hFile, '%5.3f %5.3f \n', handles.userdata.minRxGain, handles.userdata.maxRxGain);
fprintf (hFile, '%i %i %i \n', handles.userdata.noOfXPoints, handles.userdata.noOfYPoints, handles.userdata.noOfZPoints);
fclose (hFile);
%--------------------------------------------------------------------------
function handles = ReadConfigFile (handles)

fileName = handles.userdata.configFileName;

hFile = fopen (fileName, 'rt');
tline = str2num(fgetl (hFile));
handles.userdata.minWidth = tline(1);
handles.userdata.maxWidth = tline(2);
set(handles.WidthMinEB, 'string', num2str(tline(1)));
set(handles.WidthMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minHeight = tline(1);
handles.userdata.maxHeight = tline(2);
set(handles.HeightMinEB, 'string', num2str(tline(1)));
set(handles.HeightMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minLength = tline(1);
handles.userdata.maxLength = tline(2);
set(handles.LengthMinEB, 'string', num2str(tline(1)));
set(handles.LengthMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minConductivity = tline(1);
handles.userdata.maxConductivity = tline(2);
set(handles.ConductivityMinEB, 'string', num2str(tline(1)));
set(handles.ConductivityMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minErH = tline(1);
handles.userdata.maxErH = tline(2);
set(handles.RoofPermMinEB, 'string', num2str(tline(1)));
set(handles.RoofPermMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minErV = tline(1);
handles.userdata.maxErV = tline(2);
set(handles.WallPermMinEB, 'string', num2str(tline(1)));
set(handles.WallPermMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minRoughness = tline(1);
handles.userdata.maxRoughness = tline(2);
set(handles.RoughnessMinEB, 'string', num2str(tline(1)));
set(handles.RoughnessMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minTilt = tline(1);
handles.userdata.maxTilt = tline(2);
set(handles.WallTiltMinEB, 'string', num2str(tline(1)));
set(handles.WallTiltMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minFrequency = tline(1);
handles.userdata.maxFrequency = tline(2);
set(handles.FrequencyMinEB, 'string', num2str(tline(1)));
set(handles.FrequencyMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minTxGain = tline(1);
handles.userdata.maxTxGain = tline(2);
set(handles.TxGainMinEB, 'string', num2str(tline(1)));
set(handles.TxGainMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.minRxGain = tline(1);
handles.userdata.maxRxGain = tline(2);
set(handles.RxGainMinEB, 'string', num2str(tline(1)));
set(handles.RxGainMaxEB, 'string', num2str(tline(2)));

tline = str2num(fgetl (hFile));
handles.userdata.noOfXPoints = tline(1);
handles.userdata.noOfYPoints = tline(2);
handles.userdata.noOfZPoints = tline(3);
set(handles.NoOfXPointsEB, 'string', num2str(tline(1)));
set(handles.NoOfYPointsEB, 'string', num2str(tline(2)));
set(handles.NoOfZPointsEB, 'string', num2str(tline(3)));

fclose (hFile);
%--------------------------------------------------------------------------
function handles = SetDefaultParamters (handles)

handles.userdata.minWidth = 1;
handles.userdata.maxWidth = 6;
handles.userdata.minHeight = 1;
handles.userdata.maxHeight = 4;

handles.userdata.minLength = 1000;
handles.userdata.maxLength = 4000;
handles.userdata.minConductivity = 0.001;
handles.userdata.maxConductivity = 10;

handles.userdata.minErH = 2;
handles.userdata.maxErH = 12;
handles.userdata.minErV = 2;
handles.userdata.maxErV = 12;

handles.userdata.minRoughness = 0.1;
handles.userdata.maxRoughness = 0.3;
handles.userdata.minTilt = 0.1;
handles.userdata.maxTilt = 2;

handles.userdata.minFrequency = 2000;
handles.userdata.maxFrequency = 6000;
handles.userdata.minTxGain = 2;
handles.userdata.maxTxGain = 20;

handles.userdata.minRxGain = 2;
handles.userdata.maxRxGain = 20;

handles.userdata.polarisation = 3;
%--------------------------------------------------------------------------
function handles = SetInitialSliderPositions (handles)

handles.userdata.x0 = 0;
handles.userdata.y0 = 0;
handles.userdata.x = 0;
handles.userdata.y = 0;
handles.userdata.polarisation = 3;
handles.userdata.plot3D = 0;
handles.userdata.plot2D = 0;

set (handles.CrossSectionSL, 'min', handles.userdata.minLength);
set (handles.CrossSectionSL, 'max', handles.userdata.maxLength);
set (handles.CrossSectionPB, 'string', 0.5*(handles.userdata.minLength+handles.userdata.maxLength));
set (handles.CrossSectionSL, 'value', 0.5*(handles.userdata.minLength+handles.userdata.maxLength));

set (handles.FrequencySL, 'min', handles.userdata.minFrequency);
set (handles.FrequencySL, 'max', handles.userdata.maxFrequency);
set (handles.FrequencyST, 'string', handles.userdata.minFrequency);
set (handles.FrequencySL, 'value', handles.userdata.minFrequency);
handles.userdata.frequency = handles.userdata.minFrequency;

set (handles.TxGainSL, 'min', handles.userdata.minTxGain);
set (handles.TxGainSL, 'max', handles.userdata.maxTxGain);
set (handles.TxGainSL, 'value', handles.userdata.minTxGain);
set (handles.TxGainST, 'string', handles.userdata.minTxGain);
handles.userdata.txGain = handles.userdata.minTxGain;

set (handles.RxGainSL, 'min', handles.userdata.minRxGain);
set (handles.RxGainSL, 'max', handles.userdata.maxRxGain);
set (handles.RxGainSL, 'value', handles.userdata.minRxGain);
set (handles.RxGainST, 'string', handles.userdata.minRxGain);
handles.userdata.rxGain = handles.userdata.minRxGain;

set (handles.ConductivitySL, 'min', handles.userdata.minConductivity);
set (handles.ConductivitySL, 'max', handles.userdata.maxConductivity);
set (handles.ConductivitySL, 'value', handles.userdata.minConductivity);
set (handles.ConductivityST, 'string', handles.userdata.minConductivity);
handles.userdata.conductivity = handles.userdata.minConductivity;

set (handles.RoofPermSL, 'min', handles.userdata.minErH);
set (handles.RoofPermSL, 'max', handles.userdata.maxErH);
set (handles.RoofPermSL, 'value', 0.5*(handles.userdata.minErH+handles.userdata.maxErH));
set (handles.RoofPermST, 'string', 0.5*(handles.userdata.minErH+handles.userdata.maxErH));
handles.userdata.erH = 0.5*(handles.userdata.minErH+handles.userdata.maxErH);

set (handles.WallPermSL, 'min', handles.userdata.minErV);
set (handles.WallPermSL, 'max', handles.userdata.maxErV);
set (handles.WallPermSL, 'value', 0.5*(handles.userdata.minErV+handles.userdata.maxErV));
set (handles.WallPermST, 'string', 0.5*(handles.userdata.minErV+handles.userdata.maxErV));
handles.userdata.erV = 0.5*(handles.userdata.minErV+handles.userdata.maxErV);

set (handles.RoughnessSL, 'min', handles.userdata.minRoughness);
set (handles.RoughnessSL, 'max', handles.userdata.maxRoughness);
set (handles.RoughnessSL, 'value', handles.userdata.minRoughness);
set (handles.RoughnessST, 'string', handles.userdata.minRoughness);
handles.userdata.roughness = handles.userdata.minRoughness;

set (handles.WallTiltSL, 'min', handles.userdata.minTilt);
set (handles.WallTiltSL, 'max', handles.userdata.maxTilt);
set (handles.WallTiltSL, 'value', handles.userdata.minTilt);
set (handles.WallTiltST, 'string', handles.userdata.minTilt);
handles.userdata.tilt = handles.userdata.minTilt;

set (handles.TunnelHeightSL, 'min', handles.userdata.minHeight);
set (handles.TunnelHeightSL, 'max', handles.userdata.maxHeight);
set (handles.TunnelHeightSL, 'value', handles.userdata.minHeight);
set (handles.TunnelHeightST, 'string', handles.userdata.minHeight);
handles.userdata.height = handles.userdata.minHeight;

set (handles.TunnelWidthSL, 'min', handles.userdata.minWidth);
set (handles.TunnelWidthSL, 'max', handles.userdata.maxWidth);
set (handles.TunnelWidthSL, 'value', handles.userdata.minWidth);
set (handles.TunnelWidthST, 'string', handles.userdata.minWidth);
handles.userdata.width = handles.userdata.minWidth;

set (handles.TxLeftRightSL, 'min', 0);
set (handles.TxLeftRightSL, 'max', 100);
set (handles.TxLeftRightSL, 'value', 50);
set (handles.TxLeftRightST, 'string', 50);

set (handles.TxUpDownSL, 'min', 0);
set (handles.TxUpDownSL, 'max', 100);
set (handles.TxUpDownSL, 'value', 50);
set (handles.TxUpDownST, 'string', 50);

set (handles.RxLeftRightSL, 'min', 0);
set (handles.RxLeftRightSL, 'max', 100);
set (handles.RxLeftRightSL, 'value', 50);
set (handles.RxLeftRightST, 'string', 50);

set (handles.RxUpDownSL, 'min', 0);
set (handles.RxUpDownSL, 'max', 100);
set (handles.RxUpDownSL, 'value', 50);
set (handles.RxUpDownST, 'string', 50);
%--------------------------------------------------------------------------
function [E, X, Y, Z] = ExperimentSignalStrength (handles, plotType)

width = handles.userdata.width;
height = handles.userdata.height;
maxLength = handles.userdata.maxLength;
minLength = handles.userdata.minLength;

freqMHz = handles.userdata.frequency;
sigma = handles.userdata.conductivity;
erH = handles.userdata.erH;
erV = handles.userdata.erV;
roughness = handles.userdata.roughness;
tilt = deg2rad(handles.userdata.tilt);
polarisation = handles.userdata.polarisation;

lambda = 300/freqMHz;
k = 2*pi/lambda;

x0 = handles.userdata.x0;
y0 = handles.userdata.y0;

mMax = 20;
nMax = 20;


kH = (erH - 1i*sigma);
kV = (erV - 1i*sigma);

a = width/2;
b = height/2;

if (plotType == 1)
  x = handles.userdata.x;
  y = handles.userdata.y;
  
  noOfXPoints = 1;
  noOfYPoints = 1;
  noOfZPoints = handles.userdata.noOfZPoints;
  
  z = linspace(minLength, maxLength, noOfZPoints);
elseif (plotType == 2) % 2D
  noOfXPoints = handles.userdata.noOfXPoints;
  noOfYPoints = handles.userdata.noOfYPoints;
  noOfZPoints = 1;
  x = linspace (-0.99*handles.userdata.width/2, 0.99*handles.userdata.width/2, handles.userdata.noOfXPoints);
  y = linspace (-0.99*handles.userdata.height/2, 0.99*handles.userdata.height/2, handles.userdata.noOfYPoints);
  z = handles.userdata.z;
elseif (plotType == 3) % 3D
  noOfXPoints = handles.userdata.noOfXPoints;
  noOfYPoints = 1;
  noOfZPoints = handles.userdata.noOfZPoints;
  x = linspace (-0.99*handles.userdata.width/2, 0.99*handles.userdata.width/2, handles.userdata.noOfXPoints);
  y = handles.userdata.y;
  z = linspace(5, maxLength, noOfZPoints);
end

TEx = zeros (noOfYPoints, noOfXPoints, noOfZPoints);
TEy = zeros (noOfYPoints, noOfXPoints, noOfZPoints);
[X, Y, Z] = meshgrid (x, y, z);

x0Store = x0;
y0Store = y0;

for dipoleEnd = 1:4
  if (dipoleEnd == 1)
    x0 = x0Store - lambda/4;
    y0 = y0Store;
  elseif (dipoleEnd == 2)
    x0 = x0Store + lambda/4;
    y0 = y0Store;
  elseif (dipoleEnd == 3)
    x0 = x0Store;
    y0 = y0Store - lambda/4;
  elseif (dipoleEnd == 4)
    x0 = x0Store;
    y0 = y0Store + lambda/4;
  end
  
  for m = 1:mMax
    for n = 1:nMax
      phiA = pi/2;
      if (rem(m, 2) == 0)
        phiA = 0;
      end

      phiB = 0;
      if (rem(n, 2) == 0)
        phiB = pi/2;
      end

      if ((k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2) > 0)
        eMNV = sin(m*pi/2/a .* Y + phiA) .* cos(n*pi/2/b .* X + phiB);
        eMNH = sin(m*pi/2/a .* X + phiA) .* cos(n*pi/2/b .* Y + phiB);

        betaMN = sqrt(k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2);

        alphaMNV = 1/2/a * (m*pi/2/a/k)^2 * (real(1/sqrt(kV-1))) + 1/2/b * (n*pi/2/b/k)^2 * (real(kH/sqrt(kH-1)));
        alphaMNH = 1/2/a * (m*pi/2/a/k)^2 * (real(kV/sqrt(kV-1))) + 1/2/b * (n*pi/2/b/k)^2 * (real(1/sqrt(kH-1)));

        alphaL = pi^2 * roughness^2 * lambda * (1/(2*a)^4 + 1/(2*b)^4);
        alphaT = pi^2 * tilt^2 / lambda;

        CMNV = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* y0 + phiA) .* cos(n*pi/2/b .* x0 + phiB);
        CMNH = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* x0 + phiA) .* cos(n*pi/2/b .* y0 + phiB);

        alphaV = alphaMNV + alphaL + alphaT;
        alphaH = alphaMNH + alphaL + alphaT;

        beta = betaMN;

        decayV = exp(-(alphaV + 1i*beta).*Z);
        decayH = exp(-(alphaH + 1i*beta).*Z);

        Ey = CMNV .* eMNV .* decayV;
        Ex = CMNH .* eMNH .* decayH;
      
        if (dipoleEnd == 1)
          TEx = TEx + Ex;
        elseif (dipoleEnd == 2)
          TEx = TEx - Ex;
        elseif (dipoleEnd == 3)
          TEy = TEy + Ey;
        elseif (dipoleEnd == 4)
          TEy = TEy - Ey;
        end
      end  
    end
  end
end

if (polarisation == 1)
  E = TEx;
elseif (polarisation == 2)
  E = TEy;
else
  E = TEx + 1i*TEy;
end

%E = E./max(max(E));
%--------------------------------------------------------------------------
function UpdateFigures (handles)
set (handles.GTDPB, 'enable', 'on');

if (handles.userdata.plot3D == 1)
  [E, X, Y, Z] = SignalStrength (handles, 3);
  h = figure(4);
  set(h, 'units', 'normalized');
  set (h, 'Position', [0.0193 0.1463 0.2917 0.3889]);
  
  h = surf (squeeze(X(1,:,:)), squeeze(Z(1,:,:)), 20*log10(squeeze(abs(E(1,:,:)))));
  colormap ('jet');

  view (-140, 40);
  %handles.userdata.plot3D = 0;
  ylabel ('Distance down tunnel');
  xlabel ('Position across tunnel');
  zlabel ('Relative signal strength, dB');
  titleStr = sprintf ('Plot across the tunnel at a height of %5.2fm from the centre of the tunnel', handles.userdata.y);
  title (titleStr);

end
if (handles.userdata.plot2D == 1)
  h = figure(3);
  set(h, 'units', 'normalized');
  set (h, 'Position', [0.6906 0.5046 0.2917 0.3889]);
  
  [E, X, Y, Z] = SignalStrength (handles, 2);
%  h = surf (X, Y, 20*log10(squeeze(abs(E))));
  h = surf (X, Y, (squeeze(abs(E))));
  colormap ('jet');
  view (2);
  ylabel ('Height (m)');
  xlabel ('Width (m)');
  zlabel ('Relative signal strength, dB');
  titleStr = sprintf ('Cross section fields %5.2fm down the tunnel', handles.userdata.z);
  title (titleStr);
  axis ('equal');
  h=colorbar;
end

[E, x, y, z] = SignalStrength (handles, 1);
signalPower = 20*log10(abs(squeeze(E)));
%signalPower = signalPower - max(signalPower);
h = figure (2);
hold off;
set(h, 'units', 'normalized');
set (h, 'Position', [0.3937 0.5037 0.2917 0.3889]);

plot (squeeze(z), signalPower);
grid on;
xlabel ('Distance down tunnel, m');
ylabel ('Relative signal power, dB');
%axis ([0, handles.userdata.length, -100, 0]);

guidata (handles.SimulateTunnelWindow, handles);

%--------------------------------------------------------------------------
function GTDPB_Callback(hObject, eventdata, handles)

noOfReflections = get (handles.NoOfReflectionsSL, 'value');
[E, X, Y, Z] = SignalStrength (handles, 2);
normE = abs(max(max(E)));

set (hObject', 'enable', 'off');
freqMHz = get(handles.FrequencySL, 'value');
height = get(handles.TunnelHeightSL, 'value');
width = get(handles.TunnelWidthSL, 'value');
tunnelLength = handles.userdata.maxLength;
crossSection = get(handles.CrossSectionSL, 'value');
sigma = get(handles.ConductivitySL, 'value');
epsRoof = get(handles.WallPermSL, 'value');
epsWall = get(handles.RoofPermSL, 'value');
sourceXPercent = get(handles.TxLeftRightSL, 'value');
sourceYPercent = get(handles.TxUpDownSL, 'value');
obsXPercent = get(handles.RxLeftRightSL, 'value');
obsYPercent = get(handles.RxUpDownSL, 'value');
polarisation = get(handles.PolarisationLB, 'value'); %H, V, C

noOfXPoints = str2num(get(handles.NoOfGTDXPointsEB, 'string'));
noOfYPoints = str2num(get(handles.NoOfGTDYPointsEB, 'string'));
noOfZPoints = str2num(get(handles.NoOfZPointsEB, 'string'));

x0 = width*(sourceXPercent/100 - 0.5);
y0 = height*(sourceYPercent/100 - 0.5);
x = width*(obsXPercent/100 - 0.5);
y = height*(obsYPercent/100 - 0.5);
lambda = 300/freqMHz;

snecin
snrotate3d('on');
strdll ('New');

source.type = 'AFVS';
source.voltage = 1;


position = [x0, y0, 0];
if (polarisation == 3) || (polarisation == 1)
  seg.end1 = [-lambda/4, 0, 0] + position;
  seg.end2 = [lambda/4, 0, 0] + position;
  seg.radius = 0.001;
  seg.conductivity = inf;
  seg.coupling =  0;
  seg.excitation = {source};
  
  strdll ('AddSegment', seg);
end

if (polarisation == 3)
  source.voltage = 1i;
end

if (polarisation == 3) || (polarisation == 2)
  seg.end1 = [0, -lambda/4, -0.001] + position;
  seg.end2 = [0, lambda/4, -0.001] + position;
  seg.radius = 0.001;
  seg.conductivity = inf;
  seg.coupling =  0;
  seg.excitation = {source};
  
  strdll ('AddSegment', seg);
end

z = -1;
c1 = [width/2, -height/2, z];
c2 = [width/2, height/2, z];
c3 = [-width/2, height/2, z];
c4 = [-width/2, -height/2, z];
farEnd = [0, 0, crossSection+10];

layer.thickness = 1;
layer.conductivity = sigma;
layer.permeability = 1;
plate.activeEdges = [1, 1, 1, 1];
plate.transparent = 1;

layer.permittivity = epsWall;
plate.layer = {layer};
plate.vertices = [c1;c2;c2+farEnd;c1+farEnd];
strdll ('AddPlate', plate);

layer.permittivity = epsRoof;
plate.layer = {layer};
plate.vertices = [c2;c3;c3+farEnd;c2+farEnd];
strdll ('AddPlate', plate);

layer.permittivity = epsWall;
plate.layer = {layer};
plate.vertices = [c3;c4;c4+farEnd;c3+farEnd];
strdll ('AddPlate', plate);

layer.permittivity = epsRoof;
plate.layer = {layer};
plate.vertices = [c4;c1;c1+farEnd;c4+farEnd];
strdll ('AddPlate', plate);

sim.freq = freqMHz;
ne1 = [1, noOfXPoints, noOfYPoints, 1, -width/2, -height/2, crossSection, width/(noOfXPoints-1), height/(noOfYPoints-1), 0];
ne2 = [1, 1, 1, noOfZPoints, x, y, 1, 1, 1, tunnelLength/(noOfZPoints-1)];
sim.nearEField = {ne1, ne2};

sim.UTDFill.plates = [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
sim.UTDPattern.direct = 1;
%sim.UTDPattern.plates = [6, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
sim.UTDPattern.plates = [noOfReflections, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

strdll ('SetSimulation', sim);

inputFileName = 'simulatedTunnel.nec';
outputFileName = 'simulatedTunnel.out';

strdll ('WriteNECFile', inputFileName);
[s, w] = dos (['snec ' inputFileName ' ' outputFileName]);

snres ('extract', outputFileName);
neSection = snres ('nearEField', 1, 1);
neLength = snres ('nearEField', 1, 2);
clear snres;

E = zeros (noOfYPoints, noOfXPoints, noOfZPoints);
[X, Y, Z] = meshgrid (neSection.x, neSection.y, neSection.z);

totalE = sqrt(squeeze(neSection.data(:,:,1,1)).^2 + squeeze(neSection.data(:,:,1,3)).^2 + squeeze(neSection.data(:,:,1,5)).^2);
totalE = normE*totalE/max(max(totalE));

lengthE = sqrt(squeeze(neLength.data(1,1,:,1)).^2 + squeeze(neLength.data(1,1,:,3)).^2 + squeeze(neLength.data(1,1,:,5)).^2);

figure(54);
%h = surf (X, Y, totalE);
h = surf (X, Y, totalE');
colormap ('jet');
ylabel ('Height (m)');
xlabel ('Width (m)');
zlabel ('Relative signal strength, dB');
titleStr = sprintf ('Cross section fields %5.2fm down the tunnel', crossSection);
title (titleStr);
%axis ('equal');
view (2);
colorbar
axis ('equal');

figure(2);
hold on;
lengthE = lengthE/max(lengthE);
z = linspace(1, tunnelLength, noOfZPoints);
h = plot (z, 20*log10(lengthE));
ylabel ('Relative signal power, dB');
xlabel ('Distance down tunnel, m');
titleStr = sprintf ('GTD estimation');
title (titleStr);
%axis ('equal');


set (handles.GTDPB, 'enable', 'on');
%--------------------------------------------------------------------------
function [E, X, Y, Z] = SignalStrength (handles, plotType)

width = handles.userdata.width;
height = handles.userdata.height;
maxLength = handles.userdata.maxLength;
minLength = handles.userdata.minLength;

freqMHz = handles.userdata.frequency;
sigma = handles.userdata.conductivity;
erH = handles.userdata.erH;
erV = handles.userdata.erV;
roughness = handles.userdata.roughness;
tilt = deg2rad(handles.userdata.tilt);
polarisation = handles.userdata.polarisation;

x0 = handles.userdata.x0;
y0 = handles.userdata.y0;

mMax = get (handles.HighestMModesSL, 'value');
nMax = get (handles.HighestNModesSL, 'value');
mMin = get (handles.LowestMModesSL, 'value');
nMin = get (handles.LowestNModesSL, 'value');

lambda = 300/freqMHz;
k = 2*pi/lambda;

kH = (erH - 1i*sigma);
kV = (erV - 1i*sigma);

a = width/2;
b = height/2;

if (plotType == 1)
  x = handles.userdata.x;
  y = handles.userdata.y;
  
  noOfXPoints = 1;
  noOfYPoints = 1;
%  noOfZPoints = handles.userdata.noOfZPoints;
  noOfZPoints = str2num(get (handles.NoOfZPointsEB, 'string'));
  
  z = linspace(1, maxLength, noOfZPoints);
elseif (plotType == 2) % 2D
  noOfXPoints = handles.userdata.noOfXPoints;
  noOfYPoints = handles.userdata.noOfYPoints;
  noOfZPoints = 1;
  x = linspace (-0.99*handles.userdata.width/2, 0.99*handles.userdata.width/2, handles.userdata.noOfXPoints);
  y = linspace (-0.99*handles.userdata.height/2, 0.99*handles.userdata.height/2, handles.userdata.noOfYPoints);
  z = get (handles.CrossSectionSL, 'value');

elseif (plotType == 3) % 3D
  noOfXPoints = handles.userdata.noOfXPoints;
  noOfYPoints = 1;
  noOfZPoints = handles.userdata.noOfZPoints;
  x = linspace (-0.99*handles.userdata.width/2, 0.99*handles.userdata.width/2, handles.userdata.noOfXPoints);
  y = handles.userdata.y;
  z = linspace(5, maxLength, noOfZPoints);
end

E = zeros (noOfYPoints, noOfXPoints, noOfZPoints);
[X, Y, Z] = meshgrid (x, y, z);

for m = mMin:mMax
  for n = nMin:nMax
    phiA = pi/2;
    if (rem(m, 2) == 0)
      phiA = 0;
    end

    phiB = 0;
    if (rem(n, 2) == 0)
      phiB = pi/2;
    end

    if ((k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2) > 0)
        eMNV = sin(n*pi/2/b .* Y + phiA) .* cos(m*pi/2/a .* X + phiB);
        eMNH = sin(m*pi/2/a .* X + phiA) .* cos(n*pi/2/b .* Y + phiB);
      
%      eMNV = sin(n*pi/2/b .* Y + phiA) .* cos(m*pi/2/a .* X + phiB);
      %eMNV = sin(n*pi/2/b .* Y + phiB) .* cos(m*pi/2/a .* X + phiA);
%      eMNV = sin(n*pi/2/a .* Y + phiA) .* cos(m*pi/2/b .* X + phiB);
%      eMNH = sin(m*pi/2/a .* X + phiA) .* cos(n*pi/2/b .* Y + phiB);

      betaMN = sqrt(k^2 - (m*pi/2/a)^2 - (n*pi/2/b)^2);

      alphaMNV = 1/2/a * (m*pi/2/a/k)^2 * (real(1/sqrt(kV-1))) + 1/2/b * (n*pi/2/b/k)^2 * (real(kH/sqrt(kH-1)));
      alphaMNH = 1/2/a * (m*pi/2/a/k)^2 * (real(kV/sqrt(kV-1))) + 1/2/b * (n*pi/2/b/k)^2 * (real(1/sqrt(kH-1)));

      alphaL = pi^2 * roughness^2 * lambda * (1/(2*a)^4 + 1/(2*b)^4);
      alphaT = pi^2 * tilt^2 / lambda;

      CMNV = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* y0 + phiA) .* cos(n*pi/2/b .* x0 + phiB);
      CMNH = pi/(a*b*sqrt(1-(m*pi/2/a/k)^2 - (n*pi/2/b/k)^2)) .* sin(m*pi/2/a .* x0 + phiA) .* cos(n*pi/2/b .* y0 + phiB);

      alphaV = alphaMNV + alphaL + alphaT;
      alphaH = alphaMNH + alphaL + alphaT;

      beta = betaMN;

      decayV = exp(-(alphaV + 1i*beta).*Z);
      decayH = exp(-(alphaH + 1i*beta).*Z);

      Ey = CMNV .* eMNV .* decayV;
      Ex = CMNH .* eMNH .* decayH;
      
      if (polarisation == 1)
        E = E + Ex;
      elseif (polarisation == 2)
        E = E + Ey;
      else
        E = E + (Ex + 1i*Ey);
      end
    end  
  end
end
E = E./max(max(E));


%--------------------------------------------------------------------------
function NoOfGTDXPointsEB_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function NoOfGTDXPointsEB_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function NoOfGTDYPointsEB_Callback(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function NoOfGTDYPointsEB_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function LowestMModesSL_Callback(hObject, eventdata, handles)
value = get (hObject, 'value');
set (handles.LowestMModesST, 'string', value);
%--------------------------------------------------------------------------
function LowestMModesSL_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'min', 1);
set (hObject, 'max', 401);
set (hObject, 'value', 1);
set (hObject, 'sliderStep', [0.0025, 0.025]);
%--------------------------------------------------------------------------
function HighestMModesSL_Callback(hObject, eventdata, handles)
value = get (hObject, 'value');
set (handles.HighestMModesST, 'string', value);
%--------------------------------------------------------------------------
function HighestMModesSL_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'min', 1);
set (hObject, 'max', 401);
set (hObject, 'value', 201);
set (hObject, 'sliderStep', [0.0025, 0.025]);
%--------------------------------------------------------------------------
function LowestNModesSL_Callback(hObject, eventdata, handles)
value = get (hObject, 'value');
set (handles.LowestNModesST, 'string', value);
%--------------------------------------------------------------------------
function LowestNModesSL_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'min', 1);
set (hObject, 'max', 401);
set (hObject, 'value', 1);
set (hObject, 'sliderStep', [0.0025, 0.025]);
%--------------------------------------------------------------------------
function HighestNModesSL_Callback(hObject, eventdata, handles)
value = get (hObject, 'value');
set (handles.HighestNModesST, 'string', value);
%--------------------------------------------------------------------------
function HighestNModesSL_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set (hObject, 'min', 1);
set (hObject, 'max', 401);
set (hObject, 'value', 201);
set (hObject, 'sliderStep', [0.0025, 0.025]);