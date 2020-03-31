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
    p.FunctionName = 'animPost';
    addRequired(p,'animData');

    validFrameSkipFcn = @(i) isnumeric(i) && isscalar(i) && ~mod(i,1) && (i > 0);
    addParamValue(p,'frameSkip',1,validFrameSkipFcn);

    validSpeedFcn = @(i) isnumeric(i) && isscalar(i) && (i > 0);
    addParamValue(p,'speed',1,validSpeedFcn);

    validBoolFcn = @(i) islogical(i) && isscalar(i);
    addParamValue(p,'intact',false,validBoolFcn);
    addParamValue(p,'saveAllFrames',false,validBoolFcn);
    addParamValue(p,'showFrameNum',false,validBoolFcn);
    addParamValue(p,'showTime',false,validBoolFcn);
    addParamValue(p,'followModel',false,validBoolFcn);

    validTimeRangeFcn = @(i) isnumeric(i) && length(i) == 2 && i(1) <= i(2);
    addParamValue(p,'saveFramesInTimeRange',[],validTimeRangeFcn);

    validLabelFcn = @(i) ischar(i) && length(i)>0;
    addParamValue(p,'label','',validLabelFcn);

end
parse(p,varargin{:});
animData = p.Results.animData;
frameRate = animData.time(2) - animData.time(1);
frameSkip = p.Results.frameSkip;
speed = p.Results.speed;
intactFlag = p.Results.intact;
txtLabel = p.Results.label;
showFrameNum = p.Results.showFrameNum;
showTime = p.Results.showTime;
followModel = p.Results.followModel;

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
    ViewWin   =   7;%12; %[m]
    TolFrac   = 1/50; %[ViewWin]
    tShiftTot =  0*1; %[s] total time of view window shift

    % figure name (identifier)
    FigName = 'Neuromuscular Walker';

% Initialize Figure
% -----------------

    animInit(FigName);% initialize animation figure
    FigHndl = findobj('Type', 'figure',  'Name', FigName);% store figure handle for repeated access
    figDim = get(FigHndl,'Position');
    winHeight = ViewWin*figDim(4)/figDim(3);
    xlim([-3 ViewWin-3])
    ylim([-10 10])
    zlim([-winHeight/4 winHeight/4+1.5]);
    axis off

% init view shift parameters:  1. shift flag, 2. shift start time, and
%                              3. actual shift distance
ViewShiftParams = [0 0 0];

set(gca, 'YColor', [1 1 1], 'ZColor', [1 1 1])% switch off the y- and z-axis
set(gca, 'XTick', -10:1:100)% set x-axis labels
view(0,0)
%view(25,25)

% Generate 3D Objects
% -------------------

% 3D Sphere Objects
% -----------------

    SphereRes = 15; % sphere resolutions
    rCP  = 0.03; %[m] % contact point radius

    % joint radii (ankle, knee, and hip)
    rAJ  = 0.04; %[m]
    rKJ  = 0.05; %[m]
    rHJ  = 0.09; %[m]

    % y-shift (arbitrary, since sagittal model displayed with 3D objects)
    yShift = rHJ; %[m]

    % create sphere objects (contact points and joints and HAT top)
    SphereObjects = createSphereObjects(SphereRes, yShift, rCP, rAJ, rKJ, rHJ, intactFlag);

% 3D Cone Objects
% ---------------

    % cone resolution
    ConeRes = 10;

    % cone radii (bottom and top)
    rFoot     = [rCP rCP]-0.01; %[m]
    rShank    = [rAJ-0.02 rAJ-0.02 rAJ-0.02 rAJ-0.02 rAJ-0.01 rAJ]; %[m]
    rThigh    = [rKJ-0.01 rKJ-0.02 rKJ-0.02 rKJ-0.01 rKJ rKJ+0.01]; %[m]
    rHAT_Cone = [rHJ-0.02 rHJ-0.02 0.06 0.07 rHJ-0.01 rHJ-0.01 0]; %[m] male

    % create cone objects (bones)
    ConeObjects = createConeObjects(ConeRes, yShift, rFoot, rShank, rThigh, rHAT_Cone, intactFlag);

% 3D Prosthetic Objects
% ---------------
    if(~intactFlag)
        ProstheticObjects = createProstheticObjects();
    end

% 3D Walk Way
% -----------
    WayCol = [0.95 0.95 1];% walkway color
    createWalkwayObject(WayCol, rCP,3);

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
if snapShotFlag || ~all(isnan(timeRangeToSave))
    if ~exist('SnapShots','dir')
        mkdir('SnapShots');
    end
end

%%%%%%%%%%
% Update %
%%%%%%%%%%
x = zeros(animData.signals.dimensions,1);
    tframe = frameSkip/30/speed;
    for i = 1:frameSkip:length(animData.time)
        tic;
        u = animData.signals.values(i,:);
        t = animData.time(i);

        % search root for FigHndl
        if any( get(0,'Children') == FigHndl) 
            if strcmp(get( FigHndl,'Name' ), FigName) % check handle validity 
                set(0, 'CurrentFigure', FigHndl); % set actual figure to handle

                % Check if view window is out of sight. If so, shift it
                if followModel
                    viewFollowModel(u, ViewWin)
                else
                    ViewShiftParams = checkViewWin( u, t, ViewWin, TolFrac, ...
                        ViewShiftParams, tShiftTot);
                end
                camlight(camh);
                
                % Switch on all objects
                % ---------------------
                if t==0
                  set(SphereObjects, 'Visible', 'on')
                  set(ConeObjects,   'Visible', 'on')
                  if(~intactFlag)
                      set(ProstheticObjects,   'Visible', 'on')
                  end
                end
                
                
                % Update 3D-Objects Position and Orientation
                % ------------------------------------------
                updateSphereObjects( SphereObjects, u, x, intactFlag)
                updateConeObjects( ConeObjects, u, x, t, intactFlag);
                if(~intactFlag)
                    updateProstheticObjects( ProstheticObjects, u, x);
                end
                
                % Update Text objects
                % -------------------
                set(txt,'Position',[u(1), yShift, u(2)+0.75])
                if showFrameNum
                    set(frmtxt,'String',num2str(i));
                end
                if showTime
                    set(timetxt,'String',num2str(animData.time(i)));
                end

                % Update Figure
                % -------------
                drawnow
            end
        end
        x = u;

        % Save snap shot
        if snapShotFlag || (i*frameRate >= timeRangeToSave(1) && i*frameRate <= timeRangeToSave(2))
            ImgName = fullfile('SnapShots',['Shot_', int2str(i), '.png']);
            %export_fig(ImgName,'-nocrop',FigHndl)
            export_fig(ImgName,'-transparent','-nocrop',FigHndl)
        end

        tpause = tframe - toc;
        pause(tpause)
    end
end 
