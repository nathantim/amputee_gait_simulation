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

    validFrameSkipFcn = @(i) isnumeric(i) && isscalar(i) && ~mod(i,1) && (i > 0);
    addParamValue(p,'frameSkip',1,validFrameSkipFcn);

    validSpeedFcn = @(i) isnumeric(i) && isscalar(i) && (i > 0);
    addParamValue(p,'speed',1,validSpeedFcn);

    validBoolFcn = @(i) islogical(i) && isscalar(i);
    addParamValue(p,'intact',false,validBoolFcn);
    addParamValue(p,'obstacle',false,validBoolFcn);
    addParamValue(p,'CMG',false,validBoolFcn);
    addParamValue(p,'saveAllFrames',false,validBoolFcn);
    addParamValue(p,'createVideo',false,validBoolFcn);
    addParamValue(p,'showFrameNum',false,validBoolFcn);
    addParamValue(p,'showTime',true,validBoolFcn);
    addParamValue(p,'followModel',true,validBoolFcn);

    validTimeRangeFcn = @(i) isnumeric(i) && length(i) == 2 && i(1) <= i(2);
    addParamValue(p,'saveFramesInTimeRange',[],validTimeRangeFcn);

    validLabelFcn = @(i) ischar(i) && length(i)>0;
    addParamValue(p,'label','',validLabelFcn);
    addParamValue(p,'view','',validLabelFcn);
    addParamValue(p,'info','',validLabelFcn);

end
parse(p,varargin{:});
animData = p.Results.animData;
frameRate = animData.time(2) - animData.time(1);
frameSkip = p.Results.frameSkip;
speed = p.Results.speed;
intactFlag = p.Results.intact;
obstacleFlag = p.Results.obstacle;
CMGFlag = p.Results.CMG;
txtLabel = p.Results.label;
animInfo = p.Results.info;
showFrameNum = p.Results.showFrameNum;
showTime = p.Results.showTime;
followModel = p.Results.followModel;
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
    FigName = 'Neuromuscular Walker';

% Initialize Figure
% -----------------

    animInit(FigName);% initialize animation figure
    FigHndl = findobj('Type', 'figure',  'Name', FigName);% store figure handle for repeated access
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
    rAJ  = 0.04; %[m]
    rKJ  = 0.05; %[m]
    rHJ  = 0.075; %[m]
    rCMG = 0.04;
    % y-shift (arbitrary, since sagittal model displayed with 3D objects)
    yShift = 0;%0*rHJ; %[m]

    % create sphere objects (contact points and joints and HAT top)
    SphereObjects = createSphereObjects3D(SphereRes, yShift, rCP, rAJ, rKJ, rHJ,rCMG, intactFlag, CMGFlag);

% 3D Cone Objects
% ---------------

    % cone resolution
    ConeRes = 10;

    % cone radii (bottom and top)
    rFoot           = [rCP rCP]-0.01; %[m]
    rShank          = [rAJ-0.02 rAJ-0.02 rAJ-0.02 rAJ-0.02 rAJ-0.01 rAJ]; %[m]
    rThigh          = [rKJ-0.01 rKJ-0.02 rKJ-0.02 rKJ-0.01 rKJ rKJ+0.01]; %[m]
    rHAT_Cone       = [rHJ-0.02 rHJ-0.02 0.06 0.07 rHJ-0.01 rHJ-0.01 0]; %[m] male
    prosthFactor = 0.65;
    rFootProsth     = prosthFactor*[rCP rCP]-0.01; %[m]
    rShankProsth    = [prosthFactor*rAJ-0.02 prosthFactor*rAJ-0.02 prosthFactor*rAJ-0.02 prosthFactor*rAJ-0.02 prosthFactor*rAJ-0.01 prosthFactor*rAJ]; %[m]
    
    % create cone objects (bones)
    ConeObjects = createConeObjects3D(ConeRes, yShift, rFoot, rShank, rThigh, rHAT_Cone, rShankProsth, rFootProsth, intactFlag, CMGFlag);
    if obstacleFlag
        obstacle_height = 0.08;
        obstacle_width = 0.15;
        obstacle_depth = 0.02;
        xoffset = 8.85;
        yoffset = -1;
        zoffset = 0;
        v = [xoffset, yoffset - obstacle_width/2, 0;...
            xoffset, yoffset + obstacle_width/2, 0;...
            xoffset, yoffset + obstacle_width/2, obstacle_height;...
            xoffset, yoffset - obstacle_width/2, obstacle_height;...
            xoffset + obstacle_depth, yoffset - obstacle_width/2, 0;...
            xoffset + obstacle_depth, yoffset + obstacle_width/2, 0;...
            xoffset + obstacle_depth, yoffset + obstacle_width/2, obstacle_height;...
            xoffset + obstacle_depth, yoffset - obstacle_width/2, obstacle_height];
        f = [ 1,2,3,4; ... %front
            5,6,7,8; ... % back
            1,5,8,4; ... % y- side
            2,3,7,6; ... % y+ side
            3,4,8,7]; % top
        Obstacle = patch('Faces',f,'Vertices',v,'FaceColor','green');
%         Obstacle = patch('Faces',f,'Vertices',v,'FaceColor',[1 1 0.8]);
    end
    
  
    
% 3D Prosthetic Objects
% ---------------
%     if(~intactFlag)
%         ProstheticObjects = createProstheticObjects();
%     end

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
    writerObj = VideoWriter(['SnapShots',filesep,dateNow,'-',intactInfo,fileInfo,'_',viewOpt],'MPEG-4');
    writerObj.FrameRate = 1/frameRate;
    open(writerObj);
end
%%%%%%%%%%
% Update %
%%%%%%%%%%
x = zeros(animData.signals.dimensions,1);

tframe = frameSkip/30/speed;
    for ii = 1:frameSkip:length(animData.time)
        tic;
        u = animData.signals.values(ii,:);
        t = animData.time(ii);
        
        Lhip = u(4:6);
        Rhip = u(19:21);
        unitVecHip = (Rhip-Lhip)./(sqrt(sum( (Rhip-Lhip).^2 )));
%         curView = get(gca,'view');
%         viewAngle = 180/pi*atan2(Lhip(2)-Rhip(2),Lhip(1)-Rhip(1)) -90
%         set(gca,'view',c);
%         view([unitVecHip(1:2)*3,0]);
        % search root for FigHndl
        if any( get(0,'Children') == FigHndl) 
            if strcmp(get( FigHndl,'Name' ), FigName) % check handle validity 
                set(0, 'CurrentFigure', FigHndl); % set actual figure to handle

                % Check if view window is out of sight. If so, shift it
                if followModel
                    viewFollowModel(u, ViewWin)
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
%                   if(~intactFlag)
%                       set(ProstheticObjects,   'Visible', 'on')
%                   end
                end
                
                
                % Update 3D-Objects Position and Orientation
                % ------------------------------------------
                updateSphereObjects3D( SphereObjects, u, x, yShift, intactFlag, CMGFlag)
                updateConeObjects3D( ConeObjects, u, x, t, intactFlag, CMGFlag, rCMG);
%                 if(~intactFlag)
%                     updateProstheticObjects( ProstheticObjects, u, x);
%                 end
                
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
        
        tpause = tframe - toc;
%         pause(tpause)
    end
 
    if videoFlag
        close(writerObj);
    end

    close(FigHndl);
end