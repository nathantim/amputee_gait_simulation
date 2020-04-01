function animPostImpulse(animData, snapShotFlag, roughGroundFlag, intactFlag, impulseTime)

%
% animPost.m: animates the neuromechanical
%   model form logged data
%

%%%%%%%%%%%%%%%%
% Option Flags %
%%%%%%%%%%%%%%%%

if nargin == 1
    snapShotFlag = 0;
    roughGroundFlag = 0;
    intactFlag = 0;
elseif nargin == 2
    roughGroundFlag = 0;
    intactFlag = 0;
elseif nargin == 3
    intactFlag = 0;
end

%%%%%%%%%%%%%%%%%%
% Initialization %
%%%%%%%%%%%%%%%%%%
% Axes and Figure Options
% -----------------------
        
    % view window size 
    ViewWin   =   9;%12; %[m]
    TolFrac   = 1/50; %[ViewWin]
    tShiftTot =  0*1; %[s] total time of view window shift

    % figure name (identifier)
    FigName = 'Neuromuscular Walker';

% Initialize Figure
% -----------------

    animInit(FigName);% initialize animation figure
    FigHndl = findobj('Type', 'figure',  'Name', FigName);% store figure handle for repeated access
    figDim = get(FigHndl,'Position');
    xlim([3 ViewWin+3])
    ylim([-1 1])
    zlim([-0.5 2.5]);
    axis off

set(gca, 'YColor', [1 1 1], 'ZColor', [1 1 1])% switch off the y- and z-axis
set(gca, 'XTick', -10:1:100)% set x-axis labels
view(0,0)

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
        prosKneeFile = 'Prosthetic/kneeUnitAnimLowRes.STL';
        prosShankFile = 'Prosthetic/shankAnimLowRes.STL';
        prosFootFile = 'Prosthetic/footAnimLowRes.STL';
        ProstheticObjects = createProstheticObjects(prosKneeFile, prosShankFile, prosFootFile);
    end

% 3D Walk Way
% -----------
    nPlates = 100;
    WayCol = [0.95 0.95 1];% walkway color
    createWalkwayObject(nPlates, WayCol, roughGroundFlag, rCP);

% Set Scene Lighting
% ------------------
    lighting gouraud % lighting goraud (much faster than lghting phong)
    camlight % camlights on

% Create Text Labels
% ------------------
txt = text(0,0,'Reflex Control','HorizontalAlignment','center');
impulsetxt = text(0,0,'\leftarrow IMPULSE','HorizontalAlignment','left','Color','r');

% create snapshot directory
% -------------------------
if snapShotFlag
    if ~exist('SnapShots','dir')
        mkdir('SnapShots');
    end
end

starti = find(animData.time > impulseTime);
starti = starti(1);
endi = find(animData.time > (impulseTime+0.1));
endi = endi(1);

%%%%%%%%%%
% Update %
%%%%%%%%%%
x = zeros(animData.signals.dimensions,1);
for i = 1:1:length(animData.time)
    u = animData.signals.values(i,:);
    t = animData.time(i);

    % search root for FigHndl
    if any( get(0,'Children') == FigHndl )
        if strcmp(get( FigHndl,'Name' ), FigName) % check handle validity 
            set(0, 'CurrentFigure', FigHndl); % set actual figure to handle

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
            
            set(txt,'Position',[u(1), yShift, u(2)+0.75])

            % Update Figure
            % -------------
            drawnow
        end
    end
    x = u;

    % Save snap shot
    if snapShotFlag
        ImgName = fullfile('SnapShots',['Shot_', int2str(i), '.png']);
        export_fig(ImgName,'-nocrop',FigHndl)
        %export_fig(ImgName,'-transparent','-nocrop',FigHndl)
    end
    if(intactFlag)
        pause(1/30)
    end

    if (i >= starti)
        set(impulsetxt,'Position',[u(17), yShift, u(18)])
    end
    if (i >= endi)
        set(impulsetxt,'Visible','off')
    end
end
end
