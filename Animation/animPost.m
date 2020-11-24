function animPost(varargin) %animData, speed, snapShotFlag, intactFlag)

%
% animPost.m: animates the neuromechanical
%   model form logged data
%

%%%%%%%%%%%%%%%%%%%%
% Parse Argmuments %
%%%%%%%%%%%%%%%%%%%%

persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'animPost3D';
    addRequired(p,'animData');
    
    validFrameSkipFcn = @(ii) isnumeric(ii) && isscalar(ii) && ~mod(ii,1) && (ii > 0);
    addParamValue(p,'frameSkip',1,validFrameSkipFcn);
    
    validSpeedFcn = @(ii) isnumeric(ii) && isscalar(ii) && (ii > 0);
    addParamValue(p,'speed',1,validSpeedFcn);
    
    validBoolFcn = @(ii) islogical(ii) && isscalar(ii);
    addParamValue(p,'intact',false,validBoolFcn);
    addParamValue(p,'obstacle',false,validBoolFcn);
    addParamValue(p,'CMG',false,validBoolFcn);
    addParamValue(p,'saveAllFrames',false,validBoolFcn);
    addParamValue(p,'createVideo',false,validBoolFcn);
    addParamValue(p,'showFrameNum',false,validBoolFcn);
    addParamValue(p,'showTime',true,validBoolFcn);
    addParamValue(p,'followModel',true,validBoolFcn);
    addParamValue(p,'followProsthesis',false,validBoolFcn);
    addParamValue(p,'showFigure',true,validBoolFcn);
    
    validTimeRangeFcn = @(ii) isnumeric(ii) && length(ii) == 2 && i(1) <= i(2);
    addParamValue(p,'saveFramesInTimeRange',[],validTimeRangeFcn);
    
    validLabelFcn = @(ii) ischar(ii) && ~isempty(ii);
    addParamValue(p,'label','',validLabelFcn);
    addParamValue(p,'view','',validLabelFcn);
    addParamValue(p,'info','',validLabelFcn);
    addParamValue(p,'saveLocation','',validLabelFcn);
    
end
parse(p,varargin{:});
animData = p.Results.animData;
frameRate = animData.time(2) - animData.time(1);
frameSkip = p.Results.frameSkip;
speed = p.Results.speed;
intactFlag = p.Results.intact;
obstacleFlag = p.Results.obstacle;
showFigure = p.Results.showFigure;
CMGFlag = p.Results.CMG;
txtLabel = p.Results.label;
animInfo = p.Results.info;
saveLocation = p.Results.saveLocation;
if isempty(strtrim(saveLocation))
    saveLocation = 'SnapShots';
end
showFrameNum = p.Results.showFrameNum;
showTime = p.Results.showTime;
followModel = p.Results.followModel;
followProsthesis = p.Results.followProsthesis;
viewOpt = p.Results.view;

videoFlag = p.Results.createVideo;
snapShotFlag = p.Results.saveAllFrames;
timeRangeToSave = p.Results.saveFramesInTimeRange;
if isempty(timeRangeToSave)
    timeRangeToSave = [nan, nan];
end

%%%%%%%%%%%%%%%%%%
% Initialization %
%%%%%%%%%%%%%%%%%%
% Axes and Figure Options
% -----------------------

% view window size
ViewWin   =   4;%12; %[m]
TolFrac   = 1/50; %[ViewWin]
tShiftTot =  0*1; %[s] total time of view window shift

% figure name (identifier)
FigName = ['Neuromuscular Walker - ' animInfo];

% Initialize Figure
% -----------------

animInit(FigName);% initialize animation figure
FigHndl = findobj('Type', 'figure',  'Name', FigName);% store figure handle for repeated access
if ~showFigure
    set(FigHndl,'WindowState','minimized');
end
figDim = get(FigHndl,'Position');
winHeight = ViewWin*figDim(4)/figDim(3);
xlim([-3 ViewWin-3])
ylim([-1 1])
zlim([-winHeight/4 winHeight/4+1.5]);
axis off

% init view shift parameters:  1. shift flag, 2. shift start time, and
%                              3. actual shift distance
ViewShiftParamsX = [0 0 0];
ViewShiftParamsY = [0 0 0];

set(gca, 'YColor', [1 1 1], 'ZColor', [1 1 1])% switch off the y- and z-axis
set(gca, 'XTick', -10:1:100)% set x-axis labels

% view(25,25)
if contains(viewOpt,'front')
    view(90,0);
    followModel = true;
elseif contains(viewOpt,'side')
    view(0,0);
elseif contains(viewOpt,'perspective')
    view(25,25);
else
    fprintf('Default view.\n');
    viewOpt = 'default';
    view(0,0);
end

% Generate 3D Objects
% -------------------

% 3D Sphere Objects
% -----------------

SphereRes = 15; % sphere resolutions
rCP  = 0.03; %[m] % contact point radius

% joint radii (ankle, knee, and hip)
rAJ  = 0.04;    % m
rKJ  = 0.05;    % m
rHJ  = 0.075;   % m
if CMGFlag
    rCMG = 0.04;    % m
else
    rCMG = [];
end
amputeeFactor = 0.6;
% y-shift (arbitrary, since sagittal model displayed with 3D objects)
yShift = 0;%0*rHJ; %[m]

% create sphere objects (contact points and joints and HAT top)
SphereObjects = createSphereObjects(SphereRes, yShift, rCP, rAJ, rKJ, rHJ,amputeeFactor,rCMG, intactFlag, CMGFlag);

% 3D Cone Objects
% ---------------

% cone resolution
ConeRes = 10;

% cone radii (bottom and top)
rFoot           = [rCP rCP]*2/3; %[m]
rShank          = [rAJ*0.5 rAJ*0.5 rAJ*0.5 rAJ*0.5 rAJ*0.75 rAJ]; %[m]
rThigh          = [rKJ*0.8 rKJ*0.6 rKJ*0.6 rKJ*0.8 rKJ rKJ*1.2]; %[m]
rHAT_Cone       = [rHJ*11/15 rHJ*11/15 rHJ*0.8 rHJ*14/15 rHJ*13/15 rHJ*13/15 0]; %[m] male
rAmputeeThigh = [rKJ*0.8 rKJ*0.6 rKJ*0.6 rKJ*0.8 rKJ rKJ*1.2]*amputeeFactor; %[m]

% create cone objects (bones)
ConeObjects = createConeObjects(ConeRes, yShift, rFoot, rShank, rThigh, rHAT_Cone, rAmputeeThigh, intactFlag);






% 3D Prosthetic Objects
% ---------------
if (~intactFlag)
    [prosthSphereObjects, prosthLinkObjects] = createProstheticObjects(yShift,SphereRes,ConeRes,rKJ,rAJ,rCP,amputeeFactor,rCMG);
else
    prosthSphereObjects = [];
    prosthLinkObjects   = [];
end

% 3D Walk Way
% -----------
WayCol = [0.95 0.95 1];% walkway color
createWalkwayObject(WayCol, rCP,5);

% Obstacle
if obstacleFlag
    createObstacle();
end

% Set Scene Lighting
% ------------------
lighting gouraud % lighting goraud (much faster than lghting phong)
camh = camlight; % camlights on

% Create Text Labels
% ------------------
txt = text(0,0,txtLabel,'HorizontalAlignment','center');
if showFrameNum
    frmtxt = text(0.05,0.05,'0','Units','normalized');
end
if showTime
    timetxt = text(0.05,0.05,'0','Units','normalized');
end

% create snapshot directory
% -------------------------
if snapShotFlag || videoFlag || ~all(isnan(timeRangeToSave))
    if ~exist('SnapShots','dir')
        mkdir('SnapShots');
    end
    
end

if videoFlag
    dateNow = char(datestr(now,'yyyy-mm-dd_HH.MM'));
    if intactFlag
        intactInfo = 'healthy';
    else
        intactInfo = 'prosthetic';
    end
    if ~isempty(animInfo)
        fileInfo = ['_',animInfo];
    end
    writerObj = VideoWriter([saveLocation,filesep,dateNow,'-',intactInfo,fileInfo,'_',viewOpt],'MPEG-4');
    writerObj.FrameRate = 1/frameRate;
    open(writerObj);
end
%%%%%%%%%%
% Update %
%%%%%%%%%%
x = zeros(animData.signals.dimensions,1);

for ii = 1:frameSkip:length(animData.time)
    %         tic;
    u = animData.signals.values(ii,:);
    t = animData.time(ii);
    
   
    % search root for FigHndl
    if any( get(0,'Children') == FigHndl)
        if strcmp(get( FigHndl,'Name' ), FigName) % check handle validity
            set(0, 'CurrentFigure', FigHndl); % set actual figure to handle
            
            % Check if view window is out of sight. If so, shift it
            if followModel
                viewFollowModel(u, ViewWin);
            elseif followProsthesis
                viewProsthesis(u, ViewWin);
            else
                [ViewShiftParamsX,ViewShiftParamsY] = checkViewWin( u, t, ViewWin, TolFrac, ...
                    ViewShiftParamsX, ViewShiftParamsY, tShiftTot);
            end
            camlight(camh);
            
            % Switch on all objects
            % ---------------------
            if t==0
                set(SphereObjects, 'Visible', 'on')
                set(ConeObjects,   'Visible', 'on')
                if(~intactFlag)
                    set(prosthSphereObjects,   'Visible', 'on')
                    set(prosthLinkObjects,   'Visible', 'on')
                end
            end
            
            
            % Update 3D-Objects Position and Orientation
            % ------------------------------------------
            updateSphereObjects( SphereObjects, u, x, yShift, intactFlag)
            updateConeObjects( ConeObjects, u, x, t, intactFlag);
            if(~intactFlag)
                updateProstheticObjects(prosthSphereObjects, prosthLinkObjects, u, x, t,rCMG);
            end
            
            % Update Text objects
            % -------------------
            set(txt,'Position',[u(1), yShift, u(3)+0.75])
            if showFrameNum
                set(frmtxt,'String',num2str(ii));
            end
            if showTime
                set(timetxt,'String',num2str(animData.time(ii)));
            end
            
            % Update Figure
            % -------------
            drawnow
        end
    end
    x = u;
    
    % Save snap shot
    if snapShotFlag || (ii*frameRate >= timeRangeToSave(1) && ii*frameRate <= timeRangeToSave(2))
        ImgName = fullfile('SnapShots',['Shot_', int2str(ii), '.png']);
        %export_fig(ImgName,'-nocrop',FigHndl)
        export_fig(ImgName,'-transparent','-nocrop',FigHndl);
        % https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig/
        % is needed
    end
    
    if videoFlag
        writeVideo(writerObj, getframe(FigHndl));
    end
    
end

if videoFlag
    close(writerObj);
end

close(FigHndl);
end