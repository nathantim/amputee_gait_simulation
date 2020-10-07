clc, clear all, close all

%%
fileDir = uigetdir;

%% Exploratory data analysis
% Determine what metadata file type to be imported as a table
T = readtable([fileDir filesep 'WBDSinfo.xlsx'],'FileType','spreadsheet',...
    'ReadVariableNames',true,'ReadRowNames',false,'Sheet','Planilha1');

% Remove duplicate rows based on Subject column
[~,ind] = unique(T(:,1),'rows');
Tnew = T(ind,:);
Tnew = Tnew(1:43-1,:);

%%
%% Example of batching processing the data. This can be used to open the processed files and generate plots of angles, moments, and GRFs.
nsubjsY = 24; % number of subjects in the Young Adult group
nsubjsO = 18; % number of subjects in the Old Adult group

speedlabel    = {'Slow','Comf','Fast'}; % Overground walking speeds

% Parameters to perform exploration of walking biomechanics data
if 1
    % Overground condition
    Condition = 'O';
    speed     = {'S','C','F'}; % walking speeds
    
    corR =[0.6196 0.7922 0.8824   0.4196 0.6824 0.8392   0.2588 0.5725 0.7765];
else
    % Treadmill condition
    Condition = 'T';
    speed     = [1:8]; % walking speeds
    
    corR =[0.9686 0.9843 1.0000   0.8706 0.9216 0.9686   0.7765 0.8588 0.9373,...
        0.6196 0.7922 0.8824   0.4196 0.6824 0.8392   0.2588 0.5725 0.7765,...
        0.1294 0.4431 0.7098   0.0314 0.2706 0.5804];
end

axesXYZ   = {'Z','X','Y'}; % Reference system
varType   = {'Angle','Moment','GRF'}; % Biomechanical variable types
units     = {'[º]','[Nm/kg]','[N/kg]'};

varType2 = {'ang','knt'}; % type of biomechanical variables

% Parameters for plotting data
corR = reshape(corR,3,length(speed))';

% jointsA    = {'Pelvis','Hip','Knee','Ankle','Foot'}; % lower extremity joints/segments - Angles
jointsA    = {'Hip','Knee','Ankle'}; % lower extremity joints/segments - Angles

jointsT    = {'Hip','Knee','Ankle'}; % lower extremity joints/segments - Moments

% Re-arrange order of direction to reflect sagittal, frontal, and
% transverse planes
orderXYZ = [3 1 2];

%%
averageSpeed = nan(max(T.Subject),length(speed));

for idx = 1:max(T.Subject)
    subLabel = ['WBDS' num2str(idx,'%02i') 'walkO']; % Subject label
    %     averageSpeed(subjectIndices(idx),1) = subjectIndices(idx);
    for ispeed = 1:length(speed)
        gaitSpeed = T.GaitSpeed_m_s_(contains(T.FileName,subLabel) & contains(T.FileName,[speed{ispeed} 'mkr']) & ~contains(T.FileName,'.c3d') & ~contains(T.FileName,'ang') & ~contains(T.FileName,'knt'));
        averageSpeed(idx,ispeed) = round( mean( str2double(string(gaitSpeed)) ) ,1);
    end
end



% [rows0_5, cols0_5] = find(averageSpeed == 0.5);
% [rows0_9, cols0_9] = find(averageSpeed == 0.9);
% [rows1_2, cols1_2] = find(averageSpeed == 1.2);

walkingVelocities = [0.5, 0.9, 1.2];
for iVelocity = 1:length(walkingVelocities)
    
    [subjectIndices, speedIndices] = find(averageSpeed == walkingVelocities(iVelocity));
    if isempty(subjectIndices)
        continue;
    end
    % subjectIndices = rows0_9;
    % speedIndices = cols0_9;
    %%
    
    
    %% Angular kinematics for pelvis, hip, knee, ankle and foot
    % Labels of graph axes
    planesA = {'sagittal';'frontal';'transverse'};
    
    ylabelA = {'ABD(-)/ADD(+)','ER(-)/IR(+)','FLX(-)/EXT(+)',...
        'ABD(-)/ADD(+)','ER(-)/IR(+)','EXT(-)/FLX(+)',...
        'EVE(-)/INV(+)','ABD(-)/ADD(+)','PF(+)/DF(-)'};
    selectAxesAngles = [1 3 6 9];
    signFactor = [1 1 -1, ...
        1 1 1, ...
        1 1 -1];
    columnSaveVector = [17 5 9 13];
    %     ylabelA = ylabelA(selectAxes);
    angularData.signals.values = zeros(101,17);
    dirA    = {'Hip Add/Abduction','Hip Int/External Rotation','Hip Flexion/Extension',...
        'Knee Add/Abduction','Knee Int/External Rotation','Knee Flx/Extension',...
        'Ankle Inv/Eversion','Ankle Add/Abduction','Ankle Dorsi/Plantarflexion'};
    %     dirA = dirA(selectAxes);
    %     yaxisLim = [-20 40 -10 10 -20 5 -20 100 -10 10 -30 0 -20 20 -10 20 0 30];
    
    %     hcurve = []; %preallocating
    
    % hwb = waitbar(0,'Please wait...');
    
    % figure(1)
    % fidxize = get(0,'screensize');
    % set(gcf,'position',fidxize);
    
    
    
    for ij = 1:length(jointsA)
        for xyz = 1:length(axesXYZ)
            selectIdx = find(selectAxesAngles == (3*ij-3)+orderXYZ(xyz));
            if isempty(selectIdx)
                continue
            end
            varName = strcat('R',jointsA{ij},'Angle',...
                axesXYZ{xyz});
            xXx = []; %create empty array
            for idx = 1:length(subjectIndices)
                
                % Import files
                subLabel = ['WBDS' num2str(subjectIndices(idx),'%02i')]; % Subject label
                
                
                xVn = importdata([fileDir filesep 'WBDSascii' filesep subLabel 'walkO' speed{speedIndices(idx)} 'ang.txt']);
                
                
                % Find the column corresponding to the variable based on the header
                iVar = find(strcmp(varName,xVn.colheaders));
                xX = xVn.data(:,iVar);
                xXx = [xXx xX]; % Concatenate data of different subjects
            end
            
            angA = signFactor((3*ij-3)+orderXYZ(xyz))*nanmean(xXx,2); % average curves across subjects
            
            % Generate the average curves across subjects
            time = xVn.data(:,1); % time normalized vector
           
            
            variableString = dirA{(3*ij-3)+orderXYZ(xyz)};
            variableString = variableString(variableString~= ' ' & variableString~= '/');
            
            angularData.signals.values(:,columnSaveVector(selectIdx)) = pi/180*angA;
            [angles.(variableString)] = angA;
        end
        
    end
    angles.convention = ylabelA(selectAxesAngles);
    angles.time= time;
    angularData.time = time;
    % Legend of the graphs
    % legend(hleg,legText)
    % close(hwb)
    % clear hleg
    disp(angularData);
    %% Torques
    
    %% Joint moments for hip, knee and ankle
    % Labels of graph axes
    ylabelM = {'ADD(-)/ABD(+)','INT(-)/EXT(+)','EXT(-)/FLX(+)',...
        'ADD(-)/ABD(+)','INT(-)/EXT(+)','FLX(-)/EXT(+)',...
        'INV(-)/EVE(+)','ADD(-)/ABD(+)','DF(-)/PF(+)'};
    
    dirM    = {'Hip Abd/Adduction','Hip Ext/Internal Rotation','Hip Flexion/Extension',...
        'Knee Abd/Adduction','Knee Ext/Internal Rotation','Knee Ext/Flexion',...
        'Ankle Ev/Inversion','Ankle Abd/Adduction','Ankle PF/Dorsiflexion'};
    
    selectAxesTorque = [1 3 6 9];
    columnSaveVector = [8 4 5 6];
    signFactor = ones(1,9);
    % yaxisLim = [-1.5 1 -.5 1.5 -.4 .5 -1 1.5 -.5 1 -.2 .5 -.5 2 -.2 .4 -.2 1];
    
    % hcurve = []; %preallocating
    
    % hwb = waitbar(0,'Please wait...');
    % figure(2)
    % fspeedIndices(idx)ize = get(0,'screensize');
    % set(gcf,'position',fspeedIndices(idx)ize);
    
    for ij = 1:length(jointsT)
        for xyz = 1:length(axesXYZ)
            selectIdx = find(selectAxesTorque == (3*ij-3)+orderXYZ(xyz));
            if isempty(selectIdx)
                continue
            end
            varName = strcat('R',jointsT{ij},'Moment',...
                axesXYZ{xyz});
            
            xXx = []; %create empty array
            for idx = 1:length(subjectIndices)
                % Import files
                subLabel = ['WBDS' num2str(subjectIndices(idx),'%02i')]; % Subject label
                xVn = importdata([fileDir filesep 'WBDSascii' filesep subLabel 'walkO' speed{speedIndices(idx)} 'knt.txt']);
                
                % Find the column corresponding to the variable based on the header
                iVar = find(strcmp(varName,xVn.colheaders));
                xX = xVn.data(:,iVar);
                xXx = [xXx xX]; % Concatenate data of different subjects
            end
            
            momM = signFactor((3*ij-3)+orderXYZ(xyz))*nanmean(xXx,2); % average curves across subjects
            
            % Generate the average curves across subjects
            time = xVn.data(:,1); % time normalized vector
   
            
            variableString = dirA{(3*ij-3)+orderXYZ(xyz)};
            variableString = variableString(variableString~= ' ' & variableString~= '/');
            [torques.(variableString)] = momM;
            jointTorquesData.signals.values(:,columnSaveVector(selectIdx)) = momM;
        end
    end
    torques.convention = ylabelM(selectAxesTorque);
    torques.time = time;
    jointTorquesData.time = time;
    
    disp(jointTorquesData);
    % Legend of the graphs
    % legend(hleg,legText)
    % close(hwb)
    % clear hleg
    
    %%
    %% Making figure displaying Ground reaction forces data
    planesA = {'sagittal';'frontal';'transverse'};
    ylabelGRF = {'BREAK(-)/PROP(+)','INF(-)/SUP(+)','LAT(-)/MED(+)'};
    dirGRF    = {'ANTERIOR-POSTERIOR','VERTICAL','MEDIAL-LATERAL'};
       
    selectAxesTorque = [1 2 3];
    columnSaveVector = [4 6 5];
    signFactor = ones(1,3);   
    for xyz = 1:length(axesXYZ)
        selectIdx = find(selectAxesTorque == orderXYZ(xyz));
            if isempty(selectIdx)
                continue
            end
        varName = strcat('RGRF',axesXYZ{xyz});
        
        hleg=[];legText=[];
        
        xXx = []; %create empty array
        for isubj = 1:length(subjectIndices)
            
            % Import files
     
            subLabel = ['WBDS' num2str(subjectIndices(idx),'%02i')]; % Subject label
            xVn = importdata([fileDir filesep 'WBDSascii' filesep subLabel 'walkO' speed{speedIndices(idx)} 'knt.txt']);
            
            
            % Find the column corresponding to the variable based on the header
            iVar = find(strcmp(varName,xVn.colheaders));
            xX = xVn.data(:,iVar);
            xXx = [xXx xX]; % Concatenate data of different subjects
        end
        
        grfM = signFactor(orderXYZ(xyz))*nanmean(xXx,2); % average curves across subjects
        
        % Generate the average curves across subjects
        time = xVn.data(:,1); % time normalized vector
        
        variableString = dirGRF{orderXYZ(xyz)};
            variableString = variableString(variableString~= ' ' & variableString~= '/'  & variableString~= '-');
            [GRF.(variableString)] = grfM;
            GRFData.signals.values(:,columnSaveVector(selectIdx)) = grfM;
    end
    GRF.convention = ylabelGRF(selectAxesTorque);
    GRF.time = time;
    GRFData.time = time;
    
    disp(GRFData);
    

    
    %%
    gaitV = num2str(walkingVelocities(iVelocity));
    gaitV(gaitV == '.') = '_';
    gaitData.(['v' gaitV]).angles = angles;
    gaitData.(['v' gaitV]).angularData = angularData;
    gaitData.(['v' gaitV]).torques = torques;
    gaitData.(['v' gaitV]).jointTorquesData = jointTorquesData;
    gaitData.(['v' gaitV]).GRF = GRF;
    gaitData.(['v' gaitV]).GRFData = GRFData;
end
disp(gaitData);