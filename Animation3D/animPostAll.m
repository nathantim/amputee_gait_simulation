function animPostAll(varargin) %(animDataInt, animDataRef, animDataImp, snapShotFlag)

%
% animPostAll.m: animates intact, amputee with reflex control, and amputee with impedance controlled prosthetics
%   from logged dataneuromechanical model form logged data
%

%%%%%%%%%%%%%%%%%%%%
% Parse Argmuments %
%%%%%%%%%%%%%%%%%%%%

persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'animPostAll';
    addRequired(p,'animDataInt');
    addRequired(p,'animDataRef');
    addRequired(p,'animDataImp');

    validFrameSkipFcn = @(i) isnumeric(i) && isscalar(i) && ~mod(i,1) && (i > 0);
    addParamValue(p,'frameSkip',1,validFrameSkipFcn);

    validSpeedFcn = @(i) isnumeric(i) && isscalar(i) && (i > 0);
    addParamValue(p,'speed',1,validSpeedFcn);

    validBoolFcn = @(i) islogical(i) && isscalar(i);
    addParamValue(p,'saveFrames',false,validBoolFcn);
end
parse(p,varargin{:});
animDataInt = p.Results.animDataInt;
animDataRef = p.Results.animDataRef;
animDataImp = p.Results.animDataImp;

frameSkip = p.Results.frameSkip;
speed = p.Results.speed;
snapShotFlag = p.Results.saveFrames;


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
    xlim([-2 ViewWin-2])
    ylim([-4 4])
    zlim([-0 2]);
    axis off

% init view shift parameters:  1. shift flag, 2. shift start time, and
%                              3. actual shift distance
set(gca, 'YColor', [1 1 1], 'ZColor', [1 1 1])% switch off the y- and z-axis
set(gca, 'XTick', -10:1:100)% set x-axis labels

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
    yShiftHip = rHJ; %[m]

    yShiftInt = 2; %[m]
    yShiftRef = 0; %[m]
    yShiftImp = -2; %[m]

    % create sphere objects (contact points and joints and HAT top)
    SphereObjectsInt = createSphereObjects(SphereRes, yShiftHip, rCP, rAJ, rKJ, rHJ, 1, yShiftInt);
    SphereObjectsRef = createSphereObjects(SphereRes, yShiftHip, rCP, rAJ, rKJ, rHJ, 0, yShiftRef);
    SphereObjectsImp = createSphereObjects(SphereRes, yShiftHip, rCP, rAJ, rKJ, rHJ, 0, yShiftImp);

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
    ConeObjectsInt = createConeObjects(ConeRes, yShiftHip, rFoot, rShank, rThigh, rHAT_Cone, 1, yShiftInt);
    ConeObjectsRef = createConeObjects(ConeRes, yShiftHip, rFoot, rShank, rThigh, rHAT_Cone, 0, yShiftRef);
    ConeObjectsImp = createConeObjects(ConeRes, yShiftHip, rFoot, rShank, rThigh, rHAT_Cone, 0, yShiftImp);

% 3D Prosthetic Objects
% ---------------
    prosKneeFile  = '/Prosthesis/kneeStatorForAnim.STL';
    prosShankFile = '/Prosthesis/shankForAnim.STL';
    prosFootFile  = '/Prosthesis/footForAnim.STL'; 
    ProstheticObjectsRef = createProstheticObjects(prosKneeFile, prosShankFile, prosFootFile, yShiftRef);
    ProstheticObjectsImp = createProstheticObjects(prosKneeFile, prosShankFile, prosFootFile, yShiftImp);

% 3D Walk Way
% -----------
    WayCol = [0.95 0.95 1];% walkway color
    createWalkwayObject(WayCol, rCP,5);

% Set Scene Lighting
% ------------------
    lighting gouraud % lighting goraud (much faster than lghting phong)
    camh = camlight; % camlights on

% Create Text Labels
% ------------------
txtInt = text(0,0,'Intact Model','HorizontalAlignment','center','FontSize',15);
txtRef = text(0,0,'Reflex Control','HorizontalAlignment','center','FontSize',15);
txtImp = text(0,0,'Impedance Control','HorizontalAlignment','center','FontSize',15);

% create snapshot directory
% -------------------------
if snapShotFlag
    if ~exist('SnapShots','dir')
        disp('here')
        mkdir('SnapShots');
    end
end

%%%%%%%%%%
% Update %
%%%%%%%%%%
xInt = zeros(animDataInt.signals.dimensions,1);
xRef = zeros(animDataRef.signals.dimensions,1);
xImp = zeros(animDataImp.signals.dimensions,1);

iStartInt = 1;
iStartRef = 50;
iStartImp = 60;

iMaxInt = length(animDataInt.time);
iMaxRef = length(animDataRef.time);
%iMaxImp = length(animDataImp.time);
iMaxImp = length(animDataImp.time(animDataImp.time < 15));

%camera spline
numFrames = max([iMaxInt, iMaxRef, iMaxImp]);
camKeyFrame = [100 200];
camAzKey = [25 0];
camElKey = [25 0];
zLimLowKey = [0 -1];
zLimUpKey = [1.2 3];
camAz = [camAzKey(1)*ones(1,99), spline(camKeyFrame,[0, camAzKey, 0],100:200), camAzKey(end)*ones(1,numFrames - 200)];
camEl = [camElKey(1)*ones(1,99), spline(camKeyFrame,[0, camElKey, 0],100:200), camElKey(end)*ones(1,numFrames - 200)];
zLimLow = [zLimLowKey(1)*ones(1,99), spline(camKeyFrame,[0, zLimLowKey, 0],100:200), zLimLowKey(end)*ones(1,numFrames - 200)];
zLimUp = [zLimUpKey(1)*ones(1,99), spline(camKeyFrame,[0, zLimUpKey, 0],100:200), zLimUpKey(end)*ones(1,numFrames - 200)];

tframe = frameSkip/30/speed;
for i = 1:frameSkip:numFrames
    view(camAz(i),camEl(i))
    zlim([zLimLow(i), zLimUp(i)])

    if i > (iMaxInt + iStartInt - 1)
        uInt = animDataInt.signals.values(iMaxInt,:);
        tInt = animDataInt.time(iMaxInt);
    elseif i < iStartInt
        uInt = animDataInt.signals.values(1,:);
        tInt = animDataInt.time(i);
    else
        uInt = animDataInt.signals.values(i - iStartInt + 1,:);
        if i <= iMaxInt
            tInt = animDataInt.time(i);
        else
            tInt = animDataInt.time(iMaxInt);
        end
    end

    if i > (iMaxRef + iStartRef - 1)
        uRef = animDataRef.signals.values(iMaxRef,:);
        tRef = animDataRef.time(iMaxRef);
    elseif i < iStartRef
        uRef = animDataRef.signals.values(1,:);
        tRef = animDataRef.time(i);
    else
        uRef = animDataRef.signals.values(i - iStartRef + 1,:);
        if i <= iMaxRef
            tRef = animDataRef.time(i);
        else
            tRef = animDataRef.time(iMaxRef);
        end

    end

    if i > (iMaxImp + iStartImp - 1)
        uImp = animDataImp.signals.values(iMaxImp,:);
        tImp = animDataImp.time(iMaxImp);
    elseif i < iStartImp
        uImp = animDataImp.signals.values(1,:);
        tImp = animDataImp.time(i);
    else
        uImp = animDataImp.signals.values(i - iStartImp + 1,:);
        if i <= iMaxImp
            tImp = animDataImp.time(i);
        else 
            tImp = animDataImp.time(iMaxImp);
        end
    end

    % search root for FigHndl
    if any( get(0,'Children') == FigHndl )
        if strcmp(get( FigHndl,'Name' ), FigName) % check handle validity 
            set(0, 'CurrentFigure', FigHndl); % set actual figure to handle

            % Check if view window is out of sight. If so, shift it
            moveViewWindow(uInt, uRef, uImp, ViewWin, TolFrac, i, iMaxImp, iMaxRef);
            camlight(camh)
            
            % Switch on all objects
            % ---------------------
            if i==1
              set(SphereObjectsInt, 'Visible', 'on')
              set(SphereObjectsRef, 'Visible', 'on')
              set(SphereObjectsImp, 'Visible', 'on')

              set(ConeObjectsInt, 'Visible', 'on')
              set(ConeObjectsRef, 'Visible', 'on')
              set(ConeObjectsImp, 'Visible', 'on')

              set(ProstheticObjectsRef, 'Visible', 'on')
              set(ProstheticObjectsImp, 'Visible', 'on')
            end
            
            
            % Update 3D-Objects Position and Orientation
            % ------------------------------------------
            updateSphereObjects( SphereObjectsInt, uInt, xInt, 1)
            updateSphereObjects( SphereObjectsRef, uRef, xRef, 0)
            updateSphereObjects( SphereObjectsImp, uImp, xImp, 0)

            updateConeObjects( ConeObjectsInt, uInt, xInt, tInt, 1);
            updateConeObjects( ConeObjectsRef, uRef, xRef, tRef, 0);
            updateConeObjects( ConeObjectsImp, uImp, xImp, tImp, 0);

            updateProstheticObjects( ProstheticObjectsRef, uRef, xRef);
            updateProstheticObjects( ProstheticObjectsImp, uImp, xImp);
            
            set(txtInt,'Position',[uInt(1), yShiftInt, uInt(2)+0.75])
            set(txtRef,'Position',[uRef(1), yShiftRef, uRef(2)+0.75])
            set(txtImp,'Position',[uImp(1), yShiftImp, uImp(2)+0.75])
            
            % Update Figure
            % -------------
            drawnow
        end
    end
    xInt = uInt;
    xRef = uRef;
    xImp = uImp;

    % Save snap shot
    if snapShotFlag
        ImgName = fullfile('SnapShots',['Shot_', int2str(i), '.png']);
        export_fig(ImgName,'-nocrop',FigHndl)
        %export_fig(ImgName,'-transparent','-nocrop',FigHndl)
    end
end
end 
